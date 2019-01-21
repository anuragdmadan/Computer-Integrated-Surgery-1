%This function generates the EM Pivot coordinate after undistorting the raw
%EM Pivot data. 

function p = undistortedEMPivot(calbody, calreadings, empivot)

%Open the EM Pivot text file
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
%Get the sensor values and ground truth for the undistortion funcion
[Ci,DC]=calibrationDataSet(calbody, calreadings);

%undistort the EM pivot values.
DG_und=undistortion(DG,Ci,DC);
%perform a pivot calibration on the undistorted EM pivot values. 
[~,~,pt]=pivotPointCalibration(DG_und,ng,nf);
p=pt(4:6,1);