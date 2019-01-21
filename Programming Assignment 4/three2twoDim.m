%This function converts a 3D matrix to a 2D matrix, appending the height of
%the 3D matrix sequentially. 
%example - A(:,:,1) = [1 2;3 4],A(:,:,2) = [5 6;7 8]. 
%A_2D = [1 2;3 4;5 6;7 8];

function A_2D = three2twoDim(A)
n1=size(A,1);
n2=size(A,2);
n3=size(A,3);

A_2D=zeros(n1,n2*n3);
for i=1:n3
    A_2D(:,n2*(i-1)+1:n2*(i))=A(:,:,i);
end