function G = exchangenode(G,a,b)
%A=exchangenode(A,1,s);

%Exchange element at column a (i.e. 1) with element at column b (i.e. origin);
buffer=G(:,a);
G(:,a)=G(:,b);
G(:,b)=buffer;

%Exchange element at row a with element at row b;
buffer=G(a,:);
G(a,:)=G(b,:);
G(b,:)=buffer;