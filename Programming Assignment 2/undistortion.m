function G_und = undistortion(G,C_truth,C_distorted)
%This function takes in a distorted matrix G, and the truth and sensor
%values, and produses a distortion corrected matrix G_und
%G is a 3D distorted matrix.
%C_truth is the true value, C_distorted is the distorted value. this is to
%generate coefficient matrix. 

ng=size(G,2);
nf=size(G,3);
%convert the values to 2D, as all the values need to be used to generate
%the coefficient matrix. 
C=three2twoDim(C_truth);
D=three2twoDim(C_distorted);
%Generate the coefficient matrix coeff. 
coeff=distortionCoefficient(D,C);
N=ng*nf;

data=zeros(3,N);
%Convert the distorted 3D matrix to 2D, so it can be undistorted using the
%coefficient matrix generated. 
G_2D = zeros(3,N);
G_2D=three2twoDim(G);
u=zeros(3,N);
F=zeros(N,216);
%Scale the matrix down between 0 and 1
for i=1:3
    u(i,:)=scale2box(G_2D(i,:));
end
%Generate an F matrix corresponding to the new data of the distorted matrix
%G_2D
for i=1:N
    F(i,:)=distortionFgenerator(u(:,i),5);
end
%Compute the undistorted matrix data.  data = F x coeff
data(:,:) = transpose(F*(coeff));


G_max=zeros(3,1);
G_min=zeros(3,1);

for i=1:3
    G_max(i,1)=max(G_2D(i,:));
    G_min(i,1)=min(G_2D(i,:));
end
%Unscale the data up, as the data currently is also between 0 and 1.
G_und2D=zeros(3,N);
for i=1:3
    G_und2D(i,:)=scaleUp(data(i,:),G_max(i,1),G_min(i,1));
end
%convert the 2D undistorted matrix generated back to 3D
G_und=two2threeDim(G_und2D,ng,nf);