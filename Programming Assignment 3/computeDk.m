%This function calculates the pointer tip coordinates w.r.t a calibration
%body 'B' in different frames, based on LED locations from two calibration
%bodies 'A' and 'B' in body coordinates and in a tracker coordinate. 

function dk = computeDk(bodyA, bodyB, sampleReadings)
fid=fopen(bodyA);
x=fgetl(fid);
%Get the number of trackers.
c=textscan(x, '%d %s','Delimiter',',');   
na=c{1};
DA=zeros(3,na);
%The following for loops get the data into arrays
    
for i=1:na
    x=fgetl(fid);
    DA(:,i)=str2num(x);
end

x=fgetl(fid);
Pa=str2num(x);
fclose(fid);

fid=fopen(bodyB);
x=fgetl(fid);
%Get the number of trackers.
c=textscan(x, '%d %s','Delimiter',',');   
nb=c{1};
DB=zeros(3,na);
%The following for loops get the data into arrays
for i=1:nb
    x=fgetl(fid);
    DB(:,i)=str2num(x);
end
x=fgetl(fid);
Pb=str2num(x);
fclose(fid);


fid=fopen(sampleReadings);
x=fgetl(fid);
%Get the number of trackers and frames.
c=textscan(x, '%d %d %s','Delimiter',',');   
ns=c{1};
nf=c{2};
nd = ns-na-nb;

da=zeros(3,na,nf);
db=zeros(3,nb,nf);
dummy=zeros(3,nd,nf);
%The following for loops get the data into arrays
%We get the location of the LEDs on body A and body B w.r.t. tracker
%coordinates. 
for j=1:nf                                       
    
    for i=1:na
        x=fgetl(fid);
        da(:,i,j)=str2num(x);
    end

    for i=1:nb
        x=fgetl(fid);
        db(:,i,j)=str2num(x);
    end
    
    for i=1:nd
        x=fgetl(fid);
        dummy(:,i,j)=str2num(x);
    end
end

fclose(fid);
R_A=zeros(3,3,nf);
R_B=zeros(3,3,nf);
P_A=zeros(3,1,nf);
P_B=zeros(3,1,nf);
F_A=zeros(4,4,nf);
F_B=zeros(4,4,nf);
dk=zeros(3,1,nf);

%Given the coordinates of LEDs in body coordinates and tracker coordinates,
%we can do a point cloud registration algorithm to get a transformation
%function between the two coordinate systems. From here, we can compute the
%tip coordinates w.r.t. Body B, based on the transformation functions and
%the tip coodinates w.r.t. Body A. 
for i=1:nf
    [R_A(:,:,i),P_A(:,:,i)]=pointSetRegistration(DA,da(:,:,i),double(na));
    [R_B(:,:,i),P_B(:,:,i)]=pointSetRegistration(DB,db(:,:,i),double(nb));
    F_A(:,:,i)=RP2F(R_A(:,:,i),P_A(:,:,i));
    F_B(:,:,i)=RP2F(R_B(:,:,i),P_B(:,:,i));
%Compute tip coordinates. 
    temp=(inv(F_B(:,:,i))*F_A(:,:,i))*[transpose(Pa) ; 1];
    dk(:,:,i)=round(temp(1:3,:),2);
end

