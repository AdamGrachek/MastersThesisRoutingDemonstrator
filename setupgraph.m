function G = setupgraph(G,b,s)
%A = setupgraph(A,inf,1);
if s==1 
    for i=1 : size(G,1)
        for j=1 :size(G,1)
            if G(i,j)==0        %For every value that is input as zero, it is replaced with infinity
                G(i,j)=b;
            end
        end
    end
end
if s==2
    for i=1 : size(G,1)
        for j=1 : size(G,1)
            if G(i,j)==b
                G(i,j)=0;
            end
        end
    end
end