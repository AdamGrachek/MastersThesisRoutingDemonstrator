function [air] = airPollution(air, myWay10, myWay25, VC10, VC25)

%Obtain Average Values over the course of a time period collected
avgMW10 = mean(myWay10)
avgMW25 = mean(myWay25)
avgVC10 = mean(VC10)
avgVC25 = mean(VC25)

% Utilize Max values when air pollution levels are low in order to show
% the utility of this routing parameter
% avgMW10 = max(myWay10)
% avgMW25 = max(myWay25)
% avgVC10 = max(VC10)
% avgVC25 = max(VC25)
coeff = 0.5;



% Variable intialization 
air25 = air;
air10 = air;
cat25 = air;
cat10 = air;

% Assign PM Values to Relevant Links
air10(23,35)=air10(23,35)*avgMW10; air10(35,23)=air10(23,35);            %link 23 to 35 MAIN LINK
air25(23,35)=air25(23,35)*avgMW25; air25(35,23)=air25(23,35);            %link 23 to 35 MAIN LINK

air10(35,36)=air10(35,36)*avgMW10*coeff; air10(36,35)=air10(35,36);      %link 35 to 36 SIDE LINK
air25(35,36)=air25(35,36)*avgMW25*coeff; air25(36,35)=air25(35,36);      %link 35 to 36 SIDE LINK

air10(34,35)=air10(34,35)*avgMW10*coeff; air10(35,34)=air10(34,35);      %link 34 to 35 SIDE LINK
air25(34,35)=air25(34,35)*avgMW25*coeff; air25(35,34)=air25(34,35);      %link 34 to 35 SIDE LINK

air10(35,46)=air10(35,46)*avgMW10; air10(46,35)=air10(35,46);           %link 35 to 46 MAIN LINK
air25(35,46)=air25(35,46)*avgMW25; air25(46,35)=air25(35,46);           %link 35 to 46 MAIN LINK

air10(46,47)=air10(46,47)*avgMW10*coeff; air10(47,46)=air10(46,47);     %link 46 to 47 SIDE LINK
air25(46,47)=air25(46,47)*avgMW25*coeff; air25(47,46)=air25(46,47);     %link 46 to 47 SIDE LINK

air10(45,46)=air10(45,46)*avgMW10*coeff; air10(46,45)=air10(45,46);     %link 45 to 46 SIDE LINK
air25(45,46)=air25(45,46)*avgMW25*coeff; air25(46,45)=air25(45,46);     %link 45 to 46 SIDE LINK

air10(46,65)=air10(46,65)*avgMW10; air10(65,46)=air10(46,65);           %link 46 to 65 MAIN LINK
air25(46,65)=air25(46,65)*avgMW25; air25(65,46)=air25(46,65);           %link 46 to 65 MAIN LINK

air10(65,66)=air10(65,66)*avgMW10*coeff; air10(66,65)=air10(65,66);     %link 65 to 66 SIDE LINK
air25(65,66)=air25(65,66)*avgMW25*coeff; air25(66,65)=air25(65,66);     %link 65 to 66 SIDE LINK

air10(65,64)=air10(65,64)*avgMW10*coeff; air10(64,65)=air10(65,64);     %link 65 to 64 SIDE LINK
air25(65,64)=air25(65,64)*avgMW25*coeff; air25(64,65)=air25(65,64);     %link 65 to 64 SIDE LINK

air10(65,79)=air10(65,79)*avgMW10*coeff; air10(79,65)=air10(65,79);     %link 65 to 79 SIDE LINK
air25(65,79)=air25(65,79)*avgMW25*coeff; air25(79,65)=air25(65,79);     %link 65 to 79 SIDE LINK

air10(65,98)=air10(65,98)*avgMW10*coeff; air10(98,65)=air10(65,98);     %link 65 to 98 SIDE LINK
air25(65,98)=air25(65,98)*avgMW25*coeff; air25(98,65)=air25(65,98);     %link 65 to 98 SIDE LINK
%%% 
air10(65,78)=air10(65,78)*avgVC10; air10(78,65)=air10(65,78);           %link 65 to 78 MAIN LINK
air25(65,78)=air25(65,78)*avgVC25; air25(78,65)=air25(65,78);           %link 65 to 78 MAIN LINK

air10(77,78)=air10(77,78)*avgVC10; air10(78,77)=air10(77,78);           %link 77 to 78 MAIN LINK
air25(77,78)=air25(77,78)*avgVC25; air10(78,77)=air10(77,78);           %link 77 to 78 MAIN LINK

air10(96,78)=air10(96,78)*avgVC10*coeff; air10(78,96)=air10(96,78);     %link 96 to 78 SIDE LINK
air25(96,78)=air25(96,78)*avgVC25*coeff; air25(78,96)=air25(96,78);     %link 96 to 78 SIDE LINK

% Pollution Level Categorization

% PM2.5
cat25(air25<=10)=0;                     %Categorization "GOOD" for PM25         (0-10 microg/m^3)
cat25(air25>10 & air25<=20)=1;          %Categorization "FAIR" for PM25         (10-20 microg/m^3)
cat25(air25>20 & air25<=25)=2;          %Categorization "MODERATE" for PM25     (20-25 microg/m^3)
cat25(air25>25 & air25<=50)=3;          %Categorization "POOR" for PM25         (25-50 microg/m^3)
cat25(air25>50 & air25<=75)=4;          %Categorization "VERY POOR" for PM25    (50-75 microg/m^3)
cat25(air25>75 & air25<=800)=5;         %Categorization "VERY POOR" for PM25    (75-800 microg/m^3)

%PM10
cat10(air10<=20)=0;                     %Categorization "GOOD" for PM10         (0-20 microg/m^3)
cat10(air10>20 & air10<=40)=1;          %Categorization "FAIR" for PM10         (20-40 microg/m^3)
cat10(air10>40 & air10<=50)=2;          %Categorization "MODERATE" for PM10     (40-50 microg/m^3)
cat10(air10>50 & air10<=100)=3;         %Categorization "POOR" for PM10         (50-100 microg/m^3)
cat10(air10>100 & air10<=150)=4;        %Categorization "VERY POOR" for PM10    (100-150 microg/m^3)
cat10(air10>150 & air10<=1200)=5;       %Categorization "VERY POOR" for PM10    (150-1200 microg/m^3)

catFinal = max(cat25,cat10); %Takes the larger air quality categorization as the final categorization assignment
air = catFinal;              %Assigns the final air quality categorization to the final air pollution parameter

end

