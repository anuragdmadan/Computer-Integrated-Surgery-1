%This is the master function to control the other functions. We compute the
%tip coordinates first, then use these values and the mesh file details to
%compute the closest point on the mesh to the tip coordinates in each
%frame, and the difference between the two points, and the sample points
%Then, we can write the details to an output file, read details from an 
%existing output file, or perform certain statistical measures on the data. 

%Get file locations. 
bodyA="Problem4-BodyA.txt";
bodyB="Problem4-BodyB.txt";
meshFile="Problem4MeshFile.txt";
sampleReadings="PA4-B-Debug-SampleReadingsTest.txt";
output="PA4-B-Debug-Output.txt";

dk=computeDk(bodyA, bodyB, sampleReadings);
%tic
[sk,diff,ck]=ICP_simple(meshFile, dk);
%toc
%uncomment this function to use the sorting algorithm ICP function. 
%tic
%[sk2,diff2,ck2]=ICP_optimized(meshFile,dk);
%toc

%Reads an existing output file. comment out if a file does not exist. 
[sk_sol,ck_sol,diff_sol]=debugoutput_P4(output);
%sk_sol-ck_sol
%Writes to an output file. Uncomment to create a file. 
%write2file_P4(sk, ck, diff, "PA4-J-output.txt");

%Performs statistical measures based on calculated data from ICP_simple 
%and data provided by an output file. comment out if an output file does 
%not exist. 
[max_diff_s_simple,mean_diff_s_simple, stdev_diff_s_simple, max_diff_c_simple,mean_diff_c_simple, stdev_diff_c_simple, maxdiff_diff_simple, meandiff_diff_simple]=statisticalAnalysis_P4(sk_sol, sk, ck_sol, ck, diff_sol, diff)

%Performs statistical measures based on calculated data from ICP_optimized 
%and data provided by an output file. comment out if an output file does 
%not exist. 
%[max_diff_s_opt,mean_diff_s_opt, stdev_diff_s_opt, max_diff_c_opt,mean_diff_c_opt, stdev_diff_c_opt, maxdiff_diff_opt, meandiff_diff_opt]=statisticalAnalysis_P4(sk_sol, sk2, ck_sol, ck2, diff_sol, diff2)


%Performs statistical measures based on calculated data from ICP_simple 
%and ICP_optimized. comment out if an output file does  not exist. 
%[max_diff_s,mean_diff_s, stdev_diff_s, max_diff_c,mean_diff_c, stdev_diff_c, maxdiff_diff, meandiff_diff]=statisticalAnalysis_P4(sk2, sk, ck2, ck, diff2, diff);


