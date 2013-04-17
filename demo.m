%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) Copyright 2013 - MICC - Media Integration and Communication Center,
% University of Florence. 
% Iacopo Masi and Giuseppe Lisanti  <masi,lisanti> @dsi.unifi.it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
% groundtruth and results are examples. Ricreate these two structures if
% you wanto to use it in your own multi-target tracker.

generateData

VOCscore = 0.5;
dispON  = true;
ClearMOT = evaluateMOT(gt,result,VOCscore,dispON);
