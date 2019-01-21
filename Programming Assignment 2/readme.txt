***********************************************************README************************************************
MATLAB was used as the programming language of choice, and no tools or built-in functions outside of the ones
already present in the standard issue were used. 
The following functions were written to solve programming assignment 2, with some functions being taken from 
programming assignment 1 (have been mentioned). 


***************************************************************************************************************************
*****************************FUNCTIONS PREVIOUSLY USED IN PROGRAMMING ASSIGNMENT 1*****************************************
***************************************************************************************************************************

*****************************THE FOLLOWING FUNCTIONS ARE MATHEMATICAL TOOLS DEVELOPED***************************************

RP2F.m 

This function transforms a rotation and translation matrix into a frame transformation. 

Inputs: This function accepts a 3x3 rotation matrix 'R' and a 3x1 translation matrix 'p'.
Output: it produces a frame transformation 'F'.


F2RP.m

This function changes a frame transformation into a rotation and translation matrix. 

Input: This function accepts a 4x4 frame transformation 'F'
Outputs: It produces a 3x3 rotation matrix 'R' and a 3x1 translation matrix 'p'



****************************THE FOLLOWING FUNCTIONS ARE PRODUCE CONCRETE INTERMEDIATE STEPS****************************


pointSetRegistration.m 

This function accepts two 3D point clouds, and performs a 3D point cloud registration on them, producing a rotation 
and a translation matrix. 

Inputs: This function accepts 2 3D point clouds 'a' and 'b', and the number of points in each cloud 'N'
Outputs: It produces a rotation matrix 'R' and translation vector 'p' corresponding to the cloud transformation. 


pivotPointCalibration.m

This function performs a pivot point calibration on a tool with multiple trackers fitted on it, which are moved 
through multiple frames. 

Inputs: This function accepts a 3D point cloud 'a', the number of trackers on the tool 'na', and the number of 
frames the tool is moved through 'nf'.
Output: It produces a single 3D point 'pt' which is the pivot point. 


calibrationDataSet.m

this function takes a distortion calibration set and produces expected values for the position of the markers 
on the calibration body w.r.t. the EM tracker.

Inputs: This function accepts the file paths for the calibration readings for the body and EM tracker w.r.t. 
themselves 'calbody', and readings for the body w.r.t the EM tracker and optical tracker 'calreadings'. 
Outputs: It produces an expected value for Ci 'Ci', and the points for the trackers placed on the EM tracker 'dd', 
which is to be used in other functions.  





***************************************************************************************************************************
********************************NEW FUNCTIONS FOR USE IN  PROGRAMMING ASSIGNMENT 2*****************************************
***************************************************************************************************************************


*****************************THE FOLLOWING FUNCTIONS ARE MATHEMATICAL TOOLS DEVELOPED***************************************

two2threeDim.m

This function converts a 2D matrix to 3D, with the height of the 3D matrix being a factor of the number of rows 
of the 2D matrix. 

Inputs: 2D matrix 'A', number of rows needed on the 3D matrix 'n2', height of 3D matrix 'n3'
Output: 3D matrix 'A_3D'


three2twoDim.m

This function converts a 3D matrix to a 2D matrix, appending the height of the 3D matrix sequentially.

Input: 3D matrix 'A'
Output: 2D matrix 'A_2D'


scale2box.m

This function takes in a set of values q, and scales them to between 0 and 1.

Input: set of values 'q'
Output: scaled values 'x'


scaleUp.m

This function takes in data that has been scaled between 0 and 1, and unscales it

Input: scaled data 'p', a maximum value 'p_max' and a minimum value 'p_min'
Output: unscaled data 'sc'


bernsteinPolynomial.m

This function takes in the order of the polynomial, the value i, and the scaled value u, with 0<u<1, 
and returns the bernstein coefficient c. 

Input: order of the polynomial 'n', value 'i', scaled value 'u'
Output: Bernstein coefficient 'c'


****************************THE FOLLOWING FUNCTIONS ARE PRODUCE CONCRETE INTERMEDIATE STEPS****************************


distortionFgenerator.m

This is an intermediate function used to generate a full F matrix to be used in computing the distortion
coefficient matrix. 

Input: coordinate vector 'u', order of the polynomial 'n'
Output: row matrix F of all combinations of the polynomial coefficients


distortionCoefficient.m

This function produces a distortion coefficient matrix w.r.t. a coordinate frame which can be used to 
undistort other data in the same coordinate frame. 

Input: sensor distorted value 'q', ground truth value 'p'
Output: coefficient matrix 'coeff'


undistortion.m

This function is used to undistort any given data provided a ground truth value for that frame exists. 
It uses the ground truth value to generate a distortion coefficient, uses the distorted data provided to 
generate an 'F' matrix, and computes and descales the undistorted data.

Input: distorted data 'G', sensor distorted value 'q', ground truth value 'p' (the latter 2 are used to
generate the distortion coefficient matrix).
Output: Undistorted data 'G_und'


F_registration.m

This function generates a frame transformation between the EM tracker frame and the CT frame. It uses an
intermediate local frame of the pointer itself to perform a pivot calibration, and uses point set registration
to transform this to EM tracker frame. It then computes a transformation between the EM tracker and CT frame.

Input: multiple file names 
Output: frame transformation between the EM tracker and CT frame 'Freg'


tip_CTImage.m

This function computes the tip coordinates w.r.t. the CT frame. It generates a frame transformation between
the EM tracker frame and the CT frame, and based on the transformation, generates tip coordinates. 

Input: multiple file names
Output: tip coordinates w.r.t. CT frame 'vi_final'


undistortedEMPivot.m

this function takes in an EM calibration text file containing coordinates for all EM trackers on the probe in 
multiple frames, calls several functions to perform a distortion correction of the data, and produces a pivot 
point calibration to get the position of the tip of the probe.

Input: This function accepts the file path 'empivot' for the EM calibration text file.
Output: It produces a pivot point 'p' for the EM tracker. 


debugoutput_P2.m

this function is used to read any output files if they exist, and return the position of the dimple w.r.t. the 
EM tracker, and the expected values of the position of markers on the calibration object, and the tip
coordinates in the CT frame.

Input: This function accepts the file paths for the output file 'output1', 'output2', if they exist. 
Outputs: It produces the coordinates for the pivot point w.r.t. EM tracker 'pem', the expected c values 'c',
and the tup coordinates in the CT frame 'vi' 


write2file_P2.m

This function produces 2 output files with the specified syntax. for the first output, the first line is the 
number of points for c, the number of frames, and name of the file. The second line is the coordinates of the 
EM tracker point. The rest of the file is the expected values for c, written frame by frame. For the second
output, the first line is the number of points and frames. The rest of the file is the coordinates of each of 
those points.

Inputs: this function accepts the expected c values 'Ci', the number of EM markers on the calibration body 'nc', 
the number of frames 'nf', the coordinates of the pivot point w.r.t. EM Tracker 'pem', the tip coordinates 'vi'
and the file names for the output files. 
Outputs: NULL


statisticalAnalysis_P2.m

This is a function that produces a stastical analysis of the data generated by my code compared to the solution 
output files.

Inputs: this function accepts the expected c values given in the solution output file 'c_sol' and generated by
my code 'ci', the pivot point for the EM tracker given in the solution output file 'pem_sol' and generated by 
my code 'pem', and the tip coordinates in the CT frame given in the output file 'vi_sol' and generated by my
code 'vi'
Outputs: It produces the magnitude of the maximum difference observed 'max_diff_c', the mean difference observed
'mean_diff_c', and the standard deviation 'stdev_diff_c' between the two expected values. It also produces the 
magnitude of the difference between the pivot point for EM tracker generated by the solution and my code, and the 
maximum and mean of the norms of the difference between the coordinates generated by the solution and my code. 


Master_function_P2.m

This is the master function to control all other functions. It calls the calibrationDataSet function to produce
the expected c values based on point cloud registration, then it calls the undistortedEMPivot function read the 
EM pivot file, correct the read data points for distortion using the expected value generated in step 1, and 
then do a standard pivot point calibration on the corrected data. It then calls the Tip_CTImage function to 
read the EM Navigation file, and generate the tip coordinates w.r.t. the CT frame. then, it calls  
the write2file function to write any outputs you may have generated in the specified format. . Finally, it calls
 the statisticalAnalysis function to perform any analysis on the results you may have. 
Comment the function out if there is no output file that has been read.

Input: NULL
Output: NULL
