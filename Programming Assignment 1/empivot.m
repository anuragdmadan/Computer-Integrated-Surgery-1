%this function takes in an EM calibration text file containing coordinates
%for all EM trackers on the probe in multiple frames, and produces a pivot
%point calibration to get the position of the tip of the probe.
function p = EMpivot(empivot)
fid=fopen(empivot);
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
%We call the pivot point calibration function
p=pivotPointCalibration(DG,double(ng),double(nf));  