function [R,p] = quatSetRotation(a,b,N)
a_bar=zeros(3,1); 
b_bar=zeros(3,1);
for i=1:N
    a_bar=a_bar+a(:,i);
    b_bar=b_bar+b(:,i);
end
a_bar=a_bar/N;
b_bar=b_bar/N;

a_r=zeros(3,N);
b_r=zeros(3,N);
for i=1:N
    a_r(:,i)=a(:,i)-a_bar;
    b_r(:,i)=b(:,i)-b_bar;
end

M=zeros(3,3);
for i=1:N
    M=M+a_r*transpose(b_r);
end
delta=[M(2,3)-M(3,2);M(3,1)-M(1,3);M(1,2)-M(2,1)];
G=[trace(M) transpose(delta);delta M+transpose(M)-trace(M)*eye(3)];
[q,D]=eigs(G,1);
R=quat2rotm(transpose(q));
p=b_bar-R*a_bar;

