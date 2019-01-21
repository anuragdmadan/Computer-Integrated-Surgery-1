%This is the master function to control all other functions. 
%More information about this is given in the readme file. 
function Master_function_P2()
empivot = "pa2-debug-c-empivot.txt";
emfid = "pa2-debug-c-em-fiducialss.txt";
ctfid = "pa2-debug-c-ct-fiducials.txt";
emnav = "pa2-debug-c-EM-nav.txt";
calbody = "pa2-debug-c-calbody.txt";
calreadings = "pa2-debug-c-calreadings.txt";
output1 = "pa2-debug-c-output1.txt";
output2 = "pa2-debug-c-output2.txt";

[Ci,DC] = calibrationDataSet(calbody,calreadings);
p = undistortedEMPivot(calbody, calreadings, empivot);
vi = tip_CTImage(empivot, emnav, emfid, ctfid, calbody, calreadings);
nf=size(vi,2);
%uncomment the next line to create output files
%write2file_P2(p,Ci,vi,nf,"pa2-j-output1.txt","pa2-j-output2.txt");
[pem_sol, c_sol, vi_sol]=debugoutput_P2(output1,output2);
[max_diff_c,mean_diff_c, stdev_diff_c, diff_pem_mag, max_diff_v, mean_diff_v] = statisticalAnalysis_P2(c_sol, Ci, pem_sol, p, vi_sol, vi);

scaleUp