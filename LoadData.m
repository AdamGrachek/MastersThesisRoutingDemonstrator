function [dist, pave, elev, air, ped, WC, coordLat, coordLon, travelTime] = LoadData(mode)
%Loads the data parameter maps from excel

% Distances
dist = readmatrix('RoutingWeights.xlsx','Sheet','Distances','Range','B2:EL142');
dist(isnan(dist))=0;

% Coordinates of Nodes
coords = readtable('RoutingWeights.xlsx','Sheet','Coordinates','Range','B1:B142');
coords=(table2array(coords))';
% coords = (table2array(Coordinates))';       %Coordinates of Nodes

%Elevation Categorized
elev = readmatrix('RoutingWeights.xlsx','Sheet','ElevationCategorized','Range','B2:EL142');
elev(isnan(elev))=0;

%Air Quality
air = readmatrix('RoutingWeights.xlsx','Sheet','Air','Range','B2:EL142');

%Cyclist Pavement Quality
pave = readmatrix('RoutingWeights.xlsx','Sheet','PavementQuality','Range','B2:EL142');
pave(isnan(pave))=0;

%Ped Pavement Quality
ped = readmatrix('RoutingWeights.xlsx','Sheet','PedQuality','Range','B2:EL142');
ped(isnan(ped))=0;

%Wheelchair/Trolley Pavement Quality
WC = readmatrix('RoutingWeights.xlsx','Sheet','WCPaveQuality','Range','B2:EL142');
WC(isnan(WC))=0;

%----------------------- Travel Time Calculations -------------------------%

% Link Congestion Coefficients 
TTCong = readmatrix('RoutingWeights.xlsx','Sheet','TTCong','Range','B2:EL142');
TTCong(isnan(TTCong))=0;

% Travel Time Elevation Coefficients
TTElevCoeff = readmatrix('RoutingWeights.xlsx','Sheet','TTElevCoeff','Range','B2:EL142');
TTElevCoeff(isnan(TTElevCoeff))=0;

% Travel Time Cycle Quality Coefficients
TTCycleCoeff = readmatrix('RoutingWeights.xlsx','Sheet','TTCyclePQCoeff','Range','B2:EL142');
TTCycleCoeff(isnan(TTCycleCoeff))=0;

% Travel Time Wheelchair Coefficients
TTWCCoeff = readmatrix('RoutingWeights.xlsx','Sheet','TTWCPQCoeff','Range','B2:EL142');
TTWCCoeff(isnan(TTWCCoeff))=0;


if mode == 1        %pedestrian
    speed = 1.5*TTCong.*TTElevCoeff;                    % m/s
    
elseif mode == 2    %micromobility
    speed =  5.5*TTCong.*TTElevCoeff.*TTCycleCoeff;     % m/s
    
elseif mode == 3    %Wheelchair, carriage, elderly pedestrians
    speed = 1.2*TTCong.*TTElevCoeff.*TTWCCoeff;         % m/s
    
end

travelTime = dist./speed;     % seconds <====  m / (m/s)

%Split Coordinates into Lat and Long
for i = 1:length(coords)
    newCoords(:,i) = split(coords(i),', ');
end 
coordLat = newCoords(1,:);
coordLon = newCoords(2,:);

end

