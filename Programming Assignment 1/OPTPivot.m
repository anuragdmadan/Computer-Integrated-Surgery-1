%this function takes in an Optical calibration text file containing 
%coordinates for all optical trackers on the probe in multiple frames, 
%converts them to EM tracker coordinates, and produces a pivot point 
%calibration to get the position of the tip of the probe.
function pt = OPTPivot(dd, optpivot )
fid=fopen(optpivot);
x=fgetl(fid);
%We get the number of trackers and frames from the first line of the text
%file
c=textscan(x, '%d %d %d %s','Delimiter',',');
nd=c{1};
nh=c{2};
nf=c{3};
DD=zeros(3,nd,nf);
DH=zeros(3,nh,nf);
%We get the position of each tracker in all frames from the remainder of 
%the text file
for j=1:nf
    for i=1:nd
        x=fgetl(fid);
        DD(:,i,j)=str2num(x);
    end

    for i=1:nh
        x=fgetl(fid);
        DH(:,i,j)=str2num(x);
    end
end
R1=zeros(3,3,nf);
p1=zeros(3,1,nf);
Fd=zeros(4,4,nf);
%We use the coordinates of of markers on the EM tracker to compute a 
%3D point cloud to 3D point cloud transformation. 
for i=1:nf
    [R1(:,:,i),p1(:,:,i)]=pointSetRegistration(dd,DD(:,:,i),double(nd));   
    Fd(:,:,i)=RP2F(R1(:,:,i),p1(:,:,i));
end
DG=zeros(3,nh,nf);
DG_temp=zeros(4,nh,nf);
%We use the transformation computed previously to transform the optical 
%marker coordinates to EM tracker coordinates. 
for j=1:nf
    for i=1:nh
        DG_temp(:,i,j)=inv(Fd(:,:,j))*[DH(:,i,j);1];
        DG(:,i,j)=DG_temp(1:3,i,j);
    end
end
%We perform a pivot point calibration on the coordinates.
pt=pivotPointCalibration(DG,nh,nf);
