%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function evaluates the metric CLEAR-MOT as described in the paper
% Keni Bernardin and Rainer Stiefelhagen. 2008. Evaluating multiple object
%tracking performance: the CLEAR MOT metrics. J. Image Video Process. 2008,
%Article 1 (January 2008), 10 pages. DOI=10.1155/2008/246309
% http://dx.doi.org/10.1155/2008/246309
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) Copyright 2013 - MICC - Media Integration and Communication Center,
% University of Florence. 
% Iacopo Masi and Giuseppe Lisanti  <masi,lisanti> @dsi.unifi.it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%EVALUTEMOT   evaluator function
%   CLEARMOT = EVALUTEMOT(GROUNDTRUTH,RESULT,DIST,DISPON) evaluted the CLEAR MOT metrics
%   on the multi-tracking result RESULT with the GROUNDTRUTH and
%   considering the distance threshold DIST:
%   
%   - INPUT:
%   GROUNDTRUTH is a cell array where the index referst to the i-th frame.
%   GROUNDTRUTH{i} is the set of lablled bounding boxes (bbox). The bbox
%   format is %   bbox = [id tl.x tl.y br.x br.y] where id is the ID of the target; tl
%   is the top-left corner of the bbox and br is the bottom-right one.
%
%   RESULT is the structure array that contains the tracking results. See
%   the resul.mat example for more information.
%
%   DIST is a distance threshold to consider an association as true positive.
%
%   DISPON enable disable display result
%
%   - OUTPUT:
%   CLEARMOT is the struct with each informations about the metric
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ClearMOT = evaluateMOT(groundtruth,result,dist,dispON)

%% Comparison Functions (other can be implemented in mydistance function)
CompFunctionName='VOCscore'; % DistFeet2D DistFeet3D %VOCscore
%%%


%% Init structures.
idswitch = 0;
truepos = 0;
falseneg = 0;
falsepos = 0;

%% distances
distances = 0.;
distances3D = 0.;
distancesBB = 0.;
premapping = [];
mapping = [];
gt = 0;

numFrames =min( length(groundtruth),length(result) );

for i=1:numFrames;
   %% Getting tracking data
   idxTracks=result(i).trackerData.idxTracks;
   target=result(i).trackerData.target;
   %% Getting annottions data
   bboxes = groundtruth{i};
   
   %% Tmp Counter
   idswitchTmp = 0;
   trueposTmp = 0;
   falsenegTmp = 0;
   falseposTmp = 0;
   Ass = [];
   Cost = [];
   
   %% Count annotations at current frames.
   gt = gt + size(bboxes,1);
   
   %% Compute current mapping procedure.
   score = [];
   indexObj = [];
   
   %% Getting the distance matrix Tracks vs Annotations
   currentAllLabel = [];
   for b=1:size(bboxes,1);
      currentAllLabel = [currentAllLabel bboxes(b,1) ];
      for l=1:length(idxTracks)
         tt = idxTracks(l);
         distance = mydistance(bboxes(b,:),target(tt), 'VOCscore' );
         score(b,l) = distance;
         indexObj(b,l) = bboxes(b,1);
      end
   end
   
   %% From distance matrix get association matrix
   Ass = GreedyAssociation(score,dist);
   
   
   %% Compute current mapping (between tracks hyp. and annotations).
   % Note in mapping there is: [idAnnotation, idTrackerHyp.] where
   % idTrackerHyop is the index inside idxTracks().
   mapping = [];
   for r=1:length(Ass(:))
      if Ass(r) == 1
         [b l] = ind2sub(size(Ass),r);
         obj = bboxes(b,1);
         tt = idxTracks(l);
         mapping = [mapping; obj tt];
      end
   end
   
   %% Check if the mapping procedure contraditcs previous mapping.
   %% If so replace mapping and count it as an id switch.
   if length(mapping)  > 0 &&  length(premapping) > 0
      for o=1:length(mapping(:,1))
         idx = find(mapping(o,1) == premapping(:,1));
         %% if contraditcs count as ID switch
         if mapping(o,2) ~= premapping(idx,2)
            idswitch = idswitch + 1;
            idswitchTmp = idswitchTmp + 1;
         else
            %% count as TP and evaluate the MOTP.
            truepos = truepos + 1;
            h = find(idxTracks == mapping(o,2));
            idxo= find(indexObj(:,h) == mapping(o,1));
            distances = distances + score(idxo,h);
            trueposTmp = trueposTmp + 1;
         end
         
      end
   elseif length(mapping) > 0
      for o=1:length(mapping(:,1))
         %% count as TP and evaluate the MOTP.
         truepos = truepos + 1;
         h = find(idxTracks == mapping(o,2));
         idxo= find(indexObj(:,h) == mapping(o,1));
         distances = distances + score(idxo,h);
         trueposTmp = trueposTmp + 1;
      end
   elseif length(premapping) > 0
      mapping = premapping;
   end
   
   %% Check false negative (unmapped annotated obj. up to a threshold).
   for r=1:size(Ass,1)
      if sum(Ass(r,:)) == 0
         falseneg = falseneg + 1;
         falsenegTmp = falsenegTmp + 1;
      end
   end
   if isempty(Ass)
      for r=1:size(bboxes,1)
         falseneg = falseneg + 1;
         falsenegTmp = falsenegTmp + 1
      end
   end
   
   %% Check false positive (unmapped tracker hyp. up to a threshold).
   for c=1:size(Ass,2)
      if sum(Ass(:,c)) == 0
         falsepos = falsepos +1;
         falseposTmp = falseposTmp + 1;
      end
   end
   
   %% Get unmapped object and put it in the current mapping.
   unmappedObj = [];
   if ~isempty(mapping)
      unmappedObj = setdiff(currentAllLabel,mapping(:,1));
   end
   for unmap=1:length(unmappedObj)
      if ~isempty(premapping)
         idxunmapped = find(premapping(:,1) == unmappedObj(unmap));
         mapping = [mapping; premapping(idxunmapped,:)];
      end
   end
   
   %% Save current mapping as previous.
   premapping = mapping;
   
   if ( (trueposTmp + falsenegTmp + idswitchTmp) ~= size(bboxes,1))
      disp('***** Watch out sum of annotations is not valid with TP+FN+IDSWITCH *****');
      break;
   end
end

ClearMOT.rateFN = falseneg/gt;
ClearMOT.rateTP = truepos/gt;
ClearMOT.rateFP = falsepos/gt;
ClearMOT.TP = truepos;
ClearMOT.FN = falseneg;
ClearMOT.FP = falsepos;
ClearMOT.IDSW = idswitch;
ClearMOT.MOTP = distances / truepos;
ClearMOT.MOTA = 1. - ( ( falseneg + falsepos + idswitch ) / gt );

if dispON
   disp('------ ::RESULTS:: ---------');
   disp(['rateFP = ', num2str(ClearMOT.rateFP) '  (',num2str(ClearMOT.rateFP*100), '%)']);
   disp(['rateTP = ', num2str(ClearMOT.rateTP) '  (',num2str(ClearMOT.rateTP*100), '%)']);
   disp(['rateFN = ', num2str(ClearMOT.rateFN) '  (',num2str(ClearMOT.rateFN*100), '%)']);
   disp('----------------------------');
   disp(['TP = ', num2str(truepos)]);
   disp(['FN = ', num2str(falseneg)]);
   disp(['FP = ', num2str(falsepos)]);
   disp(['ID switch (MisMatch) = ', num2str(idswitch)]);
   disp('***NOTE***: ID switch should be carefully counted by visual ispection ');
   disp(['Sum of GrountTruth Obj = ', num2str(gt)]);
   disp(['Sum of FN+TP+IDSW = ', num2str(falseneg+truepos+idswitch)]);  
   disp('----------------------------');
   disp(['MOTP = ', num2str(ClearMOT.MOTP)]);
   disp(['MOTA = ', num2str(ClearMOT.MOTA) '  (',num2str(ClearMOT.MOTA*100), '%)']);
   disp('----------------------------');
end

function dist = mydistance(bboxesDetect, target, typeComp )

if(strcmp('VOCscore',typeComp))
   
   
   xtlA = bboxesDetect(1,2);
   ytlA = bboxesDetect(1,3);
   woA = bboxesDetect(1,4)-bboxesDetect(1,2);
   hoA = bboxesDetect(1,5)-bboxesDetect(1,3);
   
   
   xtlT =  target.bbox(1);
   ytlT =  target.bbox(2);
   woT =  target.bbox(3);
   hoT =  target.bbox(4);

   intersection = rectint([ xtlT ytlT woT hoT ],[ xtlA ytlA woA hoA ]);
   union = (woT*hoT) + (woA*hoA) - intersection;
   if(union == 0)
      dist=0;
   else
      dist = intersection/union;
   end
end
return 
