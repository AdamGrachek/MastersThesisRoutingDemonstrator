% Function created by Dimas Aryo 
% https://se.mathworks.com/matlabcentral/fileexchange/36140-dijkstra-algorithm
% Cited As:
% Dimas Aryo (2021). Dijkstra Algorithm (https://www.mathworks.com/matlabcentral/fileexchange/36140-dijkstra-algorithm), 
% MATLAB Central File Exchange. Retrieved March 16, 2021.

%---------------------------------------------------
function L = listdijkstra(L,W,s,d)

index=size(W,1);
while index>0
    if W(2,d)==W(size(W,1),d)
        L=[L s];
        index=0;
    else
        index2=size(W,1);
        while index2>0
            if W(index2,d)<W(index2-1,d)
                L=[L W(index2,1)];
                L=listdijkstra(L,W,s,W(index2,1));
                index2=0;
            else
                index2=index2-1;
            end
            index=0;
        end
    end
end