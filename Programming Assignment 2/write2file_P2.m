%This function produces an output file with the specified syntax. The first
%line is the number of points for c, the number of frames, and name of the
%file. The second line is the coordinates of the EM tracker point.The rest of
%the file is the expected values for c, written frame by frame. 
%for the second output, the first line is the number of points and frames. 
%the rest of the file is the coordinates of each of those points. 


%PLEASE NOTE: OUTPUT FILE 1 DOES NOT CONTAIN THE OPTICAL PIVOT VALUE, SINCE
%THAT WAS NEVER ASKED. THE SYNTAX OF THE FILE IS THEREFORE AS FOLLOWS:
%LINE 1: Nc, Nframes, FILE_NAME
%LINE 2: P_EM_x P_EM_y P_EM_z (EM PIVOT VALUES)
%LINE 3 ONWARD: Ci_x Ci_y Ci_z
%IT IS THE SAME AS REMOVING THE LINE CONTAINING OPTICAL PIVOT FROM THE
%GIVEN OUTPUT FILE. 


function write2file_P2(pem, Ci, v, nc, writeoutput1, writeoutput2)

%we generate output file output1. This contains the EM pivot values, as
%well as the C_expected values. 
n2=size(Ci,3);
n1=size(Ci,2);
fid=fopen(writeoutput1,'wt');
fprintf(fid, '%d, %d, %s', n1, n2, writeoutput1);
fprintf(fid,'\n');
fprintf(fid, '%f, %f, %f', pem);
fprintf(fid,'\n');
for i=1:n2
    for j=1:n1
        fprintf(fid, '%f, %f, %f', Ci(:,j,i));
        fprintf(fid,'\n');
    end
end
fclose(fid);

%we generate output file output1. this contains the tip coordinates w.r.t.
%the CT frame.
fid=fopen(writeoutput2,'wt');
fprintf(fid, '%d, %s', nc, writeoutput2);
fprintf(fid,'\n');
for i=1:nc
    fprintf(fid, '%f, %f, %f', v(:,i));
    fprintf(fid,'\n');
end
fclose(fid);