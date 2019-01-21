%this function is used to read any output files if they exist, and return
%the coordinates of the pointer tip w.r.t. body B, the coordinates of 
%the points on the surface closest to the sample points, and the magnitude 
%of the difference between the two, as provided in the given output files.
function [d,c,diff]=debugoutput_P4(output)
fid=fopen(output);
x=fgetl(fid);
%We get the values for number of frames from the first line of the text 
%file. 
c=textscan(x, '%d %s','Delimiter',','); 
nf=c{1};

%we get the values of dk, ck, and the difference between the two 
%from the remainder of the text file.
temp=zeros(7,nf);
for i=1:nf                          
        x=fgetl(fid);
        temp(:,i)=str2num(x);
    
end
d=temp(1:3,:);
c=temp(4:6,:);
diff=temp(7,:);
