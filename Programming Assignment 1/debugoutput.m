%this function is used to read any output files if they exist, and return
%the position of the dimple w.r.t. the EM tracker, the optical tracker, and
%the expected values of the position of markers on the calibration object.
%It accepts the file name for the output file as its input.
function [pem,popt,c]=debugoutput(output)
fid=fopen(output);
x=fgetl(fid);
%We get the values for number of markers and number of frames from the 
%first line of the text file. 
c=textscan(x, '%d %d %s','Delimiter',','); 
nc=c{1};
nf=c{2};
pem=zeros(3,1);
popt=zeros(3,1);
%We get the values of the EM tracker point and optical tracker point from
% the second and third lines of the text file.
x=fgetl(fid);                       
pem=str2num(x);
pem=transpose(pem);
x=fgetl(fid);
popt=str2num(x);
popt=transpose(popt);

%we get the values of c_expected from the remainder of the text file.
c=zeros(3,nc,nf);
for i=1:nf                          
    for j=1:nc
        x=fgetl(fid);
        c(:,j,i)=str2num(x);
    end
end