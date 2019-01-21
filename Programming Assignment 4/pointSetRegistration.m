%This function accepts two 3D point clouds, and performs a point cloud
%registration on them, producing a rotation and a translation matrix. 

function [R,p] = pointSetRegistration(a,b,N)
a_bar=zeros(3,1); 
b_bar=zeros(3,1);
%The following for loop produces the average of the point clouds. 
for i=1:N
    a_bar=a_bar+a(:,i);
    b_bar=b_bar+b(:,i);
end
a_bar=a_bar/N;
b_bar=b_bar/N;

a_r=zeros(3,N);
b_r=zeros(3,N);
%The following for loop produces the difference between each point and the
%average
for i=1:N
    a_r(:,i)=a(:,i)-a_bar;
    b_r(:,i)=b(:,i)-b_bar;
end

M=zeros(3,3);
%We compute the sum of all differences as a matrix. 
for i=1:N
    M=M+a_r*transpose(b_r);
end
%We solve for R and p in terms of the sum matrix M.
R=(transpose(M)*M)^(-0.5)*transpose(M); 
p=b_bar-R*a_bar;