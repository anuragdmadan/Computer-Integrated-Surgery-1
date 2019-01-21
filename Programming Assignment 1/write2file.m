%This function produces an output file with the specified syntax. The first
%line is the number of points for c, the number of frames, and name of the
%file. The second line is the coordinates of the EM tracker point. The
%third line is the coordinates of the optical tracker point. The rest of
%the file is the expected values for c, written frame by frame. 

function write2file(Ci,nc,nf,pem, popt,writeoutput)
fid=fopen(writeoutput,'wt');
fprintf(fid, '%d, %d, %s', nc, nf, writeoutput);
fprintf(fid,'\n');
fprintf(fid, '%f, %f, %f', pem);
fprintf(fid,'\n');
fprintf(fid, '%f, %f, %f', popt);
fprintf(fid,'\n');
for i=1:nf
for j=1:nc
fprintf(fid, '%f, %f, %f', Ci(:,j,i));
fprintf(fid,'\n');
end
end
fclose(fid);