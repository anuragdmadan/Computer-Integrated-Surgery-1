%this function takes a distortion calibration set and produces expected
%values for the position of the markers on the calibration body w.r.t. the
%EM tracker. It accepts the file locations for the calibration readings
%file and the calibration body file, and produces c_expected.
function [Ci,DC] = calibrationDataSet(calbody, calreadings)
%fid=fopen("pa2-debug-c-calreadings.txt");
fid=fopen(calreadings);
x=fgetl(fid);
%Get the number of trackers and frames.
c=textscan(x, '%d %d %d %d %s','Delimiter',',');   
nd=c{1};
na=c{2};
nc=c{3};
nf=c{4};
DD=zeros(3,nd,nf);
DA=zeros(3,na,nf);
DC=zeros(3,nc,nf);

%The following for loops get the data into arrays
for j=1:nf                                       
    for i=1:nd
        x=fgetl(fid);
        DD(:,i,j)=str2num(x);                       
    end

    for i=1:na
        x=fgetl(fid);
        DA(:,i,j)=str2num(x);
    end

    for i=1:nc
        x=fgetl(fid);
        DC(:,i,j)=str2num(x);
    end
end
fclose(fid);

fid=fopen(calbody);
%fid=fopen("pa2-debug-c-calbody.txt");%
x=fgetl(fid);
dd=zeros(3,nd);
da=zeros(3,na);
dc=zeros(3,nc);
%The following for loops get the data into arrays.
for i=1:nd                                        
    x=fgetl(fid);
    dd(:,i)=str2num(x);
end

for i=1:na
    x=fgetl(fid);
    da(:,i)=str2num(x);
end

for i=1:nc
    x=fgetl(fid);
    dc(:,i)=str2num(x);
end
fclose(fid);

p1=zeros(3,1,nf);
R1=zeros(3,3,nf);
Fd=zeros(4,4,nf);
p2=zeros(3,1,nf);
R2=zeros(3,3,nf);
Fa=zeros(4,4,nf);
F_temp=zeros(4,4,nf);
R=zeros(3,3,nf);
p=zeros(3,1,nf);

%We produce a 3D point cloud to 3D point cloud registration for the 
%readings of the optical tracker on the calibration object, and the 
%readings of the optical tracker on the EM tracker 
for i=1:nf
    [R1(:,:,i),p1(:,:,i)]=pointSetRegistration(dd,DD(:,:,i),double(nd));    
    Fd(:,:,i)=RP2F(R1(:,:,i),p1(:,:,i));
    [R2(:,:,i),p2(:,:,i)]=pointSetRegistration(da,DA(:,:,i),double(na));    
    Fa(:,:,i)=RP2F(R2(:,:,i),p2(:,:,i));
    F_temp(:,:,i)=inv(Fd(:,:,i))*Fa(:,:,i);        
    [R(:,:,i),p(:,:,i)]=F2RP(F_temp(:,:,i));
    
end

Ci=zeros(3,nc,nf);
%based on the transformations computed above, we calculate the expected

for i=1:nf
    for j=1:nc
        Ci(:,j,i)=R(:,:,i)*dc(:,j)+p(:,:,i);                    
    end
end
