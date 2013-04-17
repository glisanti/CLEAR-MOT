%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function implements a greedy association between two sets given a 
% score matrix. The method match two paris selecting the max and if the 
% score is higher than a given threshold.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) Copyright 2013 - MICC - Media Integration and Communication Center,
% University of Florence. 
% Iacopo Masi and Giuseppe Lisanti  <masi,lisanti> @dsi.unifi.it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%GREEDYASSOCIATION   association function
%   ASSIGNMENTMATRIX = GREEDYASSOCIATION(SCOREMATRIX,THRESHOLD) given a 
%   score matrix and a threshold returns the association matrix.
%   
%   - INPUT:
%   SCOREMATRIX is matrix where each item contains the score of a given
%   pair. The matri dimension is TxA where T is the number of Tracks and A
%   is the number of annotations.
%   THRESHOLD the threshold used to say that a pair matches.
%   - OUTPUT:
%   ASSIGNMENTMATRIX is the binary matrix of assignmenti. If a element is
%   one the method has made the assignment.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function AssignmentMatrix = GreedyAssociation(ScoreMatrix, threshold)

T = size(ScoreMatrix,1);
D = size(ScoreMatrix,2);
AssignmentMatrix = zeros(T,D);
[currentScore idxMax] = max(ScoreMatrix(:));

while(currentScore ~= 0)
  
    [tmax,dmax] = ind2sub(size(ScoreMatrix),idxMax);
    
    ScoreMatrix(tmax,dmax) = 0;
  
    if currentScore > threshold
        ScoreMatrix(tmax,:) = 0;
        ScoreMatrix(:,dmax) = 0;
        AssignmentMatrix(tmax,dmax) = 1;
    end
    
    [currentScore idxMax] = max(ScoreMatrix(:));
        
 
end
