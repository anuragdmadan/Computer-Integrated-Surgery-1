%This function performs a pivot point calibration. It accepts a point cloud
%a, the number of elements in a, and the number of frames, and returns a
%pivot point pt. We use the first frame of readings to compute the midpoint
%and translation in this case. 

function [R,p,pt]=pivotPointCalibration(a, na, nf)

Go=zeros(3,1);
%we get the midpoint for the observed points. 
for i=1:na
    Go(:,:)=Go(:,:)+a(:,i,1);             
end
Go=Go/double(na);

dg=zeros(3,na);
%We translate the points in the first frame relative to the mid point.
for i=1:na
    dg(:,i)=a(:,i,1)-Go(:,:);                   
end

R=zeros(3,3,nf);
p=zeros(3,1,nf);
%Based on the translation and the actual point cloud provided, we perform 
%a 3D point cloud to 3D point cloud transformation.
for i=1:nf
    [R(:,:,i),p(:,:,i)]=pointSetRegistration(dg(:,:),a(:,:,i),double(na));  
end

R_total=zeros(3*nf,6);
P_total=zeros(3*nf,1);
%To solve for the pivot point, we setup a least squares problem 
%[R|-I][p_pivot;P_tip]=-p
for i=1:nf
    R_total(3*i-2:3*i,:)=[R(:,:,i) , -eye(3,3)];                    
    P_total(3*i-2:3*i,:)=-p(:,:,i);
end
p_pivot=lsqminnorm(R_total,P_total);                                

pt=p_pivot;