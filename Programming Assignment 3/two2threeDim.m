%This function converts a 2D matrix to 3D, with the height of the 3D matrix
%being a factor of the number of rows of the 2D matrix. 

function A_3D = two2threeDim(A,n2,n3)

n1=size(A,1);
A_3D=zeros(n1,n2,n3);

for i=1:n3
    A_3D(:,:,i)=A(:,n2*(i-1)+1:n2*(i));
end
