%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(c) Copyright 2013 - MICC - Media Integration and Communication Center,
%University of Florence.
%Iacopo Masi and Giusppe Lisanti <masi,lisanti> @dsi.unifi.it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Generate ground-truth data

gt{1} = [ 1.0000  118.8866   81.3198  147.1134  166.0000; 2.0000  151.9684   48.8103  176.0316  121.0000; 3.0000  255.9703   60.8219  282.0297  139.0000];

gt{2} = [ 1.0000  117.2922   78.7535  145.7078  164.0000; 2.0000  151.3673   44.7039  175.6327  117.5000; 3.0000  253.8299   60.4792  280.1701  139.5000];

gt{3} = [ 1.0000  115.6979   76.1871  144.3021  162.0000; 2.0000  150.7662   40.5974  175.2338  114.0000; 3.0000  251.6894   60.1365  278.3106  140.0000];

%Generate tracking data

result(1).trackerData.idxTracks = [1, 2, 3];
result(1).trackerData.target(1).bbox = [118.8866   81.3198   28.2267   84.6802];
result(1).trackerData.target(2).bbox = [151.9684   48.8103   24.0632   72.1897];
result(1).trackerData.target(3).bbox = [255.9703   60.8219   26.0594   78.1781];

result(2).trackerData.idxTracks = [1, 2, 3];
result(2).trackerData.target(1).bbox = [117.2922   78.7535   28.4155   85.2465];
result(2).trackerData.target(2).bbox = [151.3673   44.7039   24.2654   72.7961];
result(2).trackerData.target(3).bbox = [253.8299   60.4792   26.3403   79.0208];

result(3).trackerData.idxTracks = [1, 2, 3];
result(3).trackerData.target(1).bbox = [115.6979   76.1871   28.6043   85.8129];
result(3).trackerData.target(2).bbox = [150.7662   40.5974   24.4675   73.4026];
result(3).trackerData.target(3).bbox = [251.6894   60.1365   26.6212   79.8635];
