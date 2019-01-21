%This function produces an output file with the specified syntax. The first
%line is the number of frames, and name of the file. The rest of the file
%is the coordinates of the pointer tip w.r.t. body B, the coordinates of 
%the points on the surface closest to the sample points, and the magnitude 
%of the difference between the two. 

function write2file_P4(dk, ck, diff, writeoutput)
fid=fopen(writeoutput,'wt');
nf=size(dk,3);
fprintf(fid, '%d, %s', nf, writeoutput);
fprintf(fid,'\n');
for i=1:nf
fprintf(fid, '%f, %f, %f %f, %f, %f %f', dk(:,:,i), ck(:,:,i), diff(:,i));
fprintf(fid,'\n');
end
fclose(fid);