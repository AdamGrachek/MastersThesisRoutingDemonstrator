clearvars

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -----------------------------User Input----------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mode = 2;       %1 for pedestrian (walking) 2 for micromobility (scooters, bikes, etc.), 3 for wheelchairs and trolleys
origin = 141;    %randi(length(dist),1);
dest = 1;      %randi(length(dist),1);
paveRate = 0;
elevRate = 0;
airRate =0;
TTRate=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------Load Data--------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loading data matrices from Excel
[dist, pave, elev, air, ped, WC, coordLat, coordLon, travelTime] = LoadData(mode);

% Calling PM2.5 and PM10 Air Pollution from the database
[myWay10, myWay25, VC10, VC25] = databasecall;

% Formulating air pollution categorization on relevant links
[air] = airPollution(air, myWay10, myWay25, VC10, VC25);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------Parameter Setup---------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Normalize Parameters
dist(dist==0)=NaN;  %eliminates the effect of null values
pave(pave==0)=NaN;
elev(elev==0)=NaN;
ped(ped==0)=NaN;
WC(WC==0)=NaN;
travelTime(travelTime==0)=NaN;

%Removes inaccessible wheelchair links from normalization process (Relevant only when mode = 3)
elev(travelTime==Inf)=100000;
dist(travelTime==Inf)=100000;
travelTime(travelTime==Inf)=100000; 

% Normalization according to max-min normalization
distNorm = (dist - min(min(dist)))/(max(max(dist))-min(min(dist)));
paveNorm = (pave - min(min(pave)))/(max(max(pave))-min(min(pave)));
elevNorm = (elev - min(min(elev)))/(max(max(elev))-min(min(elev)));
airNorm = (air - min(min(air)))/(max(max(air))-min(min(air)));
pedNorm = (ped - min(min(ped)))/(max(max(ped))-min(min(ped)));
WCNorm = (WC - min(min(WC)))/(max(max(WC))-min(min(WC)));
TTNorm = (travelTime - min(min(travelTime)))/(max(max(travelTime))-min(min(travelTime)));

% Ensures values normalized to zero are still valid in shortest path algorithm
distNorm(distNorm==0)=0.00001; 
paveNorm(paveNorm==0)=0.00001;
elevNorm(elevNorm==0)=0.00001;
airNorm(airNorm==0)=0.00001;
pedNorm(pedNorm==0)=0.00001;
WCNorm(WCNorm==0)=0.00001;
TTNorm(TTNorm==0)=0.00001;

% Returns null cells back to zero for use in algorihm
distNorm(isnan(distNorm))=0;        
paveNorm(isnan(paveNorm))=0;
elevNorm(isnan(elevNorm))=0;
airNorm(isnan(airNorm))=0;
pedNorm(isnan(pedNorm))=0;
WCNorm(isnan(WCNorm))=0;
TTNorm(isnan(TTNorm))=0;
dist(isnan(dist))=0;


%Cancels out the effect of the parameters if their priority is zero
if elevRate == 0
    elevNorm(1:length(dist),1:length(dist))=0;
    elevRate=1;
end
if paveRate == 0
    paveNorm(1:length(dist),1:length(dist))=0;
    pedNorm(1:length(dist),1:length(dist))=0;
    WCNorm(1:length(dist),1:length(dist))=0;
    paveRate=1;
end
if airRate == 0
    airNorm(1:length(dist),1:length(dist))=0;
    airRate=1;
end
if TTRate == 0
    TTNorm(1:length(dist),1:length(dist))=0;
    TTRate=1;
end

% Mode 1 is pedestrian (walking), Mode 2 is micromobility, 3 is wheelchair
% and other decreased speed pedestrians

if mode == 1
    parameters=pedNorm*paveRate+elevNorm*elevRate+airNorm*airRate;
elseif mode == 2
    parameters=paveNorm*paveRate+elevNorm*elevRate+airNorm*airRate;
elseif mode == 3
    parameters=WCNorm*paveRate+elevNorm*elevRate+airNorm*airRate;
end


%if priority is zero for all three parameters, then the parameter variable
%is set to 1 to become a normal shortest path.
if parameters(1:length(dist),1:length(dist)) == 0
    parameters(1:length(dist),1:length(dist)) = 1;
end

mat = (parameters).*distNorm+TTNorm*TTRate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------Route Calculation------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calculate the cost and route for the desired origin and destination
% [cost route] = function(map, origin, destination)
[cost, route] = dijkstra(dist,origin,dest);     %Shortest path distance
[costMod, routeMod] = dijkstra(mat,origin,dest);        %Shortest path w/ mods

%Calculates cost of shortest path with the same weights as modified path
cost=0;
for q = length(route)-1:-1:1
    cost=cost+mat(route(q+1),route(q));
end


% Obtain coords of shortest path distance
for j=1:length(route)
    RouteLat(j) = str2double(coordLat(route(j)));
    RouteLon(j) = str2double(coordLon(route(j)));
end

%Obtain coords of shortest path w/ mods
for j=1:length(routeMod)
    ModLat(j) = str2double(coordLat(routeMod(j)));
    ModLon(j) = str2double(coordLon(routeMod(j)));
end

% Obtain Travel Time for Modified Path
TTMod = 0;
for j=length(routeMod):-1:2
    TTMod = TTMod + travelTime(routeMod(j),routeMod(j-1));      %sums travel times of each link [seconds]
end
TTMod = TTMod/60; %Convert to minutes

% Obtain Travel Time for Shortest Path
TT = 0;
for j=length(route):-1:2
    TT = TT + travelTime(route(j),route(j-1));                  %sums travel times of each link [seconds]
end
TT = TT/60; %Convert to minutes

fprintf('The travel time for the modified path is %.2f minutes', TTMod);
fprintf('The travel time for the shortest path is %.2f minutes', TT);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------Mapping-----------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



name = 'openstreetmap';
url = 'https://a.tile.openstreetmap.org/${z}/${x}/${y}.png';
copyright = char(uint8(169));
attribution = copyright + "OpenStreetMap contributors.";
addCustomBasemap(name,url,'Attribution',attribution)


%Map Settings
zoomLevel = 15;
latcenter = 58.589886;
loncenter = 16.181981;
player = geoplayer(latcenter,loncenter,zoomLevel);

% Display the Route
player.Basemap = 'openstreetmap';
plotRoute(player,RouteLat,RouteLon,'Color','b','LineWidth',2);
plotRoute(player,ModLat,ModLon,'Color','r','LineWidth',1);


%https://se.mathworks.com/matlabcentral/fileexchange/36140-dijkstra-algorithm
%Cite As
%Dimas Aryo (2021). Dijkstra Algorithm (https://www.mathworks.com/matlabcentral/fileexchange/36140-dijkstra-algorithm), MATLAB Central File Exchange. Retrieved March 16, 2021.



