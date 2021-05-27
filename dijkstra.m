% Function created by Dimas Aryo 
% https://se.mathworks.com/matlabcentral/fileexchange/36140-dijkstra-algorithm
% Cited As:
% Dimas Aryo (2021). Dijkstra Algorithm (https://www.mathworks.com/matlabcentral/fileexchange/36140-dijkstra-algorithm), 
% MATLAB Central File Exchange. Retrieved March 16, 2021.

%---------------------------------------------------
% Dijkstra Algorithm
% author : Dimas Aryo
% email : mr.dimasaryo@gmail.com
%
% usage
% [cost rute] = dijkstra(Graph, source, destination)
% 
% example
% G = [0 3 9 0 0 0 0;
%      0 0 0 7 1 0 0;
%      0 2 0 7 0 0 0;
%      0 0 0 0 0 2 8;
%      0 0 4 5 0 9 0;
%      0 0 0 0 0 0 4;
%      0 0 0 0 0 0 0;
%      ];
% [e L] = dijkstra(G,1,7)
%---------------------------------------------------
function [e L] = dijkstra(A,s,d)

if s==d         %if origin = destination
    e=0;        %cost = 0   
    L=[s];      %route list is only the origin node 
else

A = setupgraph(A,inf,1); %map =  map with zeros replaced with infinity

if d==1         %if desintation is node 1
    d=s;        %destination node = origin node
end
A=exchangenode(A,1,s);

lengthA=size(A,1);  %size of map (row wise) that is 141
W=zeros(lengthA);   %Create a 141 size vector of zeros 
for i=2 : lengthA   %For i=2 to 141
    W(1,i)=i;       %vector w in row 1, each col = 1, 2, ... 141
    W(2,i)=A(1,i);  %vector w in row 2, each col = map value (1,1), (1,2), ...(1,141) all the way across first row of map
end

for i=1 : lengthA   %for i = 1 to 141
    D(i,1)=A(1,i);  %vector D in col 1, each row = map value (1,1), (1,2),...(1,141) all the way across the first row of map
    D(i,2)=i;       %vector D in col 2, each row = 1,2,...141
end

D2=D(2:length(D),:);    %New vector D2 is equal to D(2:141, for all cols of D)
L=2;                    %counter variable set to 2
while L<=(size(W,1)-1)  %while L is less/equal to size 140
    L=L+1;              %add L=L+1
    D2=sortrows(D2,1);  %sorts D2 rows in ascending order based on the elements in the first column.
    k=D2(1,2);          %k = D2(first row, second col)
    W(L,1)=k;           %W(counter,first col) = k
    D2(1,:)=[];         %Sets all cols in row 1 = nothing
    for i=1 : size(D2,1)                            %for i = 1: length of D2 in first col (i.e. 141)
        if D(D2(i,2),1)>(D(k,1)+A(k,D2(i,2)))       % if the value of one link is less than that of the current link
            D(D2(i,2),1) = D(k,1)+A(k,D2(i,2));     %This is link is added to the list D2 
            D2(i,1) = D(D2(i,2),1);                 %The position is changed for D2 to the lesser node
        end
    end
    
    for i=2 : length(A)
        W(L,i)=D(i,1);
    end
end
if d==s
    L=[1];
else
    L=[d];
end
e=W(size(W,1),d);
L = listdijkstra(L,W,s,d);
end