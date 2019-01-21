%This function takes in a sensor distorted value, a ground truth value, and
%generates a distortion coefficient matrix to be used in undistorting other
%data. 

function coeff = distortionCoefficient(q, p)
%q is 3xN, N data points, each point has 3 coordinates. 
%p is 3XN, N data points, which are the ground truth. 

N=size(q,2);
F=zeros(N,216);
u=zeros(3,N);
v=zeros(3,N);
%We scale the data points to [0,1]
for i=1:3
    u(i,:)=scale2box(q(i,:));
    v(i,:)=scale2box(p(i,:));
end
%Generate the distortion F matrix
for i=1:N
    F(i,:)=distortionFgenerator(u(:,i),5);
end
%Solve for the coefficient matrix using least squares solution. F x coeff =
%v
coeff=lsqminnorm(F,transpose(v));
