%This function generates the tip coordinates w.r.t. the CT frame. 
function vi_final = tip_CTImage(empivot, emnav, emfid, ctfid, calbody, calreadings)

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
%undistort the EM pivot values
dg_und=undistortion(dg,Ci,DC);

%Generate a local frame d, which is placed on the pivot itself.
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

%Generate a transformation between the CT and EM coordinate systems Fr
[Fr,p_tip]=F_Registration(empivot, emfid, ctfid, calbody, calreadings);

%open the EM-navigation text file
fid=fopen(emnav);
x=fgetl(fid);
%We get the number of points and frames from the first line of the text
%file
c=textscan(x, '%d %d %s','Delimiter',',');  
ng=c{1};
nf=c{2};

G=zeros(3,ng,nf);
%We get the position of each tracker in all frames from the remainder of 
%the text file
for j=1:nf                                  
    for i=1:ng
        x=fgetl(fid);
        G(:,i,j)=str2num(x);
    end
end
fclose(fid);

%undistort the navigation data
G_und=undistortion(G,Ci,DC);

%Get the transformation between the EM tracker and the local frame
for i=1:nf
[R2(:,:,i),p2(:,:,i)]=pointSetRegistration(d,G_und(:,:,i),double(nf));
end

%compute the coordinates of the tip w.r.t. the EM tracker
fi=zeros(3,1,nf);
for i=1:nf
    fi(:,:,i)=R2(:,:,i)*p_tip+p2(:,:,i);
end

%using the frame transformation between the CT and EM coordinates, compute
%the coordinates of the tip w.r.t. CT frame
vi=zeros(4,nf);
for i=1:nf
    vi(:,i)=inv(Fr)*[fi(:,:,i);1];
end
vi_final=vi(1:3,:);
