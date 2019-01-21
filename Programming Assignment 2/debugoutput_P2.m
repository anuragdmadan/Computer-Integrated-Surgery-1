%this function is used to read any output files if they exist, and return
%the position of the dimple w.r.t. the EM tracker, the optical tracker, and
%the expected values of the position of markers on the calibration object.
%It accepts the file name for the output file as its input.
function [pem,c_sol,vi_sol]=debugoutput_P2(output1,output2)
fid=fopen(output1);
x=fgetl(fid);
%We get the values for number of markers and number of frames from the 
%first line of the text file. 
c=textscan(x, '%d %d %s','Delimiter',','); 
nc=c{1};
nf=c{2};
pem=zeros(3,1);
popt=zeros(3,1);
%We get the values of the EM tracker point the second line of the text file.
x=fgetl(fid);                       
pem=str2num(x);
pem=transpose(pem);
x=fgetl(fid);
popt=str2num(x);
popt=transpose(popt);

%we get the values of c_expected from the remainder of the text file.
c_sol=zeros(3,nc,nf);
for i=1:nf                          
    for j=1:nc
        x=fgetl(fid);
        c_sol(:,j,i)=str2num(x);
    end
end


fid=fopen(output2);
x=fgetl(fid);
%We get the values for number of points from the 
%first line of the text file. 
c=textscan(x, '%d %s','Delimiter',','); 
nb=c{1};
vi_sol=zeros(3,nb);
%we get the coordinates of the tip in each point from the rest of the text
%file
for i=1:nb
    x=fgetl(fid);
   vi_sol(:,i)=str2num(x);
end