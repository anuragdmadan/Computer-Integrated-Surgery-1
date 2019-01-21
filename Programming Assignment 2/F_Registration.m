%This function generates a frame transformation between the EM coordinates
%frame and the CT coordinate frame. 

function [Freg,p_tip] = F_Registration(empivot, emfid, ctfid, calbody, calreadings)

%Get the sensor values and ground truth for the undistortion funcion
[Ci,DC]=calibrationDataSet(calbody, calreadings);

%Open the EM Pivot text file
fid=fopen(empivot);
x=fgetl(fid);
%We get the number of trackers and frames from the first line of the text
%file
c=textscan(x, '%d %d %s','Delimiter',',');  
ng=c{1};
nf=c{2};

dg=zeros(3,ng,nf);
%We get the position of each tracker in all frames from the remainder of 
%the text file
for j=1:nf                                  
    for i=1:ng
        x=fgetl(fid);
        dg(:,i,j)=str2num(x);
    end
end
fclose(fid);

%Undistort the EM Pivot values
dg_und=undistortion(dg,Ci,DC);

%%Generate a local frame d, which is placed on the pivot itself.
Go=zeros(3,1);
%we get the midpoint for the observed points. 
for i=1:ng
    Go(:,:)=Go(:,:)+dg_und(:,i,1);             
end
Go=Go/double(ng);

d=zeros(3,ng);
%We translate the points in the first frame relative to the mid point.
for i=1:ng
    d(:,i)=dg_und(:,i,1)-Go(:,:);                   
end


%Open the EM-fiducials data file
fid=fopen(emfid);
x=fgetl(fid);
%We get the number of trackers and frames from the first line of the text
%file
c=textscan(x, '%d %d %s','Delimiter',',');  
ng=c{1};
nf=c{2};

DG=zeros(3,ng,nf);
%We get the position of each tracker in all frames from the remainder of 
%the text file
for j=1:nf                                  
    for i=1:ng
        x=fgetl(fid);
        DG(:,i,j)=str2num(x);
    end
end
fclose(fid);

%undistort the EM-fiducials values
DG_und=undistortion(DG,Ci,DC);

%Compute the position of the pivot tip
[~,~,p_tip_full]=pivotPointCalibration(dg_und,double(ng),double(nf));
p_tip=p_tip_full(1:3,1);

R=zeros(3,3,nf);
p=zeros(3,1,nf);
%Get the transformation between the EM tracker and the local frame
for i=1:nf
[R(:,:,i),p(:,:,i)]=pointSetRegistration(d,DG_und(:,:,i),double(nf));
end

%compute the coordinates of the tip w.r.t. the EM tracker
fi=zeros(3,nf);
for i=1:nf
    fi(:,i)=R(:,:,i)*p_tip+p(:,:,i);
end

%Open the CT-fiducials text file
fid=fopen(ctfid);
x=fgetl(fid);
bi=zeros(3,nf);

%we get the position of each fiducial from the rest of the data file
for i=1:nf
    x=fgetl(fid);
    bi(:,i)=str2num(x);
end
fclose(fid);

%compute the transformation between the tip in CT coordinates and EM
%coordinates. 
[Rreg,preg]=pointSetRegistration(bi,fi,double(nf));
%Store the rotation and translation values in Fr
Freg=RP2F(Rreg,preg);




