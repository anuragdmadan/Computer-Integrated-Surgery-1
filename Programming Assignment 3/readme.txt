***********************************************************README************************************************
MATLAB was used as the programming language of choice, and no tools or built-in functions outside of the ones
already present in the standard issue were used. 
The following functions were written to solve programming assignment 2, with some functions being taken from 
programming assignment 1 (have been mentioned). 


***************************************************************************************************************************
*****************************FUNCTIONS PREVIOUSLY USED IN PROGRAMMING ASSIGNMENTS*****************************************
***************************************************************************************************************************

RP2F.m 

This function transforms a rotation and translation matrix into a frame transformation. 

Inputs: This function accepts a 3x3 rotation matrix 'R' and a 3x1 translation matrix 'p'.
Output: it produces a frame transformation 'F'.


F2RP.m

This function changes a frame transformation into a rotation and translation matrix. 

Input: This function accepts a 4x4 frame transformation 'F'
Outputs: It produces a 3x3 rotation matrix 'R' and a 3x1 translation matrix 'p'


pointSetRegistration.m 

This function accepts two 3D point clouds, and performs a 3D point cloud registration on them, producing a rotation 
and a translation matrix. 

Inputs: This function accepts 2 3D point clouds 'a' and 'b', and the number of points in each cloud 'N'
Outputs: It produces a rotation matrix 'R' and translation vector 'p' corresponding to the cloud transformation. 


two2threeDim.m

This function converts a 2D matrix to 3D, with the height of the 3D matrix being a factor of the number of rows 
of the 2D matrix. 

Inputs: 2D matrix 'A', number of rows needed on the 3D matrix 'n2', height of 3D matrix 'n3'
Output: 3D matrix 'A_3D'


three2twoDim.m

This function converts a 3D matrix to a 2D matrix, appending the height of the 3D matrix sequentially.

Input: 3D matrix 'A'
Output: 2D matrix 'A_2D'


***************************************************************************************************************************
********************************NEW FUNCTIONS FOR USE IN  PROGRAMMING ASSIGNMENT 2*****************************************
***************************************************************************************************************************


computeDk.m

This function calculates the pointer tip coordinates w.r.t a calibration body 'B' in different frames, based on LED 
locations from two calibration bodies 'A' and 'B' in body coordinates and in a tracker coordinate. 

Inputs: The locations of the LEDs on bodies A and B 'bodyA', 'bodyB', The readings taken in tracker coordinates in multiple
frames 'samplereadings'
Outputs: The tip coordinates w.r.t. body B cooresponding to each frame 'dk'


projectionOnSegment.m

This function finds the closest point on a line segment to a given point. 

Inputs: end points of the line segment 'p', 'q', and the point to which the closest point must be computed 'c'
Output: closest point that is on the line segment 'c_star'


DistanceCalculator.m

This function calculates the closest point in or on a triangle to a given point in space. It also calculates the distance
between the two. The triangle is defined by three given points. The function first calculates the closest point on the 
surface defined by the three points, and if the point lies outside the triangle, uses the projectionOnSegment function to 
calculate the point on the closest line segment of the triangle. It then calculates the distance between this point and the 
point in space. 

Inputs: coordinates for the three vertices of the triangle, which also define the full 2D surface containing the triangle 
'p', 'q', 'r', and the point in space to which the closest distance must be found 'a'. 
Outputs: the closest point 'c', distance between the two points 'dist'. 


DistanceCalculator_barycentric.m

This function calculates the closest point in or on a triangle to a given point in space. It also calculates the distance
between the two. The triangle is defined by three given points. The function first computes the area of the projection 
of the point w.r.t. 2 sides as a ratio of the total area of the triangle, which gives 2 ratios. Using these ratios, it 
then computes the barycentric coordinates for the point. If the point lies outside the triangle, uses the projectionOnSegment 
function to calculate the point on the closest line segment of the triangle. It then calculates the distance between this 
point and the point in space. 

Inputs: coordinates for the three vertices of the triangle, which also define the full 2D surface containing the triangle 
'p', 'q', 'r', and the point in space to which the closest distance must be found 'a'. 
Outputs: the closest point 'c', distance between the two points 'dist'. 


closestPoint_simple.m

This function finds the closest point on a given surface mesh, using a simple iterative closest point algorithm. 
For this assignment, the number of iterations is kept to 1, and the registration transformation is kept to identity.
It finds the closest point for the tip coordinates 'dk' in every frame, and also computes the distance between the two
points found. 

Inputs: location of the mesh file 'meshfile', the tip coordinates in every frame 'dk'
Outputs: the closest point on the surface mesh to the tip coordinates in every frame 'c', the distance between the two
coordinates 'd'. 


closestPoint_sorted.m

This function finds the closest point on a given surface mesh, using a sorting algorithm to speed up the search. The 
centroids for the mesh triangles is computed, and based on these centroids, the triangles are sorted into octants. 
Then, only the octant in which the tip coordinate falls is used in the search. This is seen to significantly improve 
runtime. For this assignment, the number of iterations is kept to 1, and the registration transformation is kept to identity.
It finds the closest point for the tip coordinates 'dk' in every frame, and also computes the distance between the two
points found. 

Inputs: location of the mesh file 'meshfile', the tip coordinates in every frame 'dk'
Outputs: the closest point on the surface mesh to the tip coordinates in every frame 'c', the distance between the two
coordinates 'd'.


debugoutput_P3.m

this function is used to read any output files if they exist, and return the coordinates of the pointer tip w.r.t. body B,
the coordinates of the points on the surface closest to the sample points, and the magnitude of the difference between the 
two, as provided in the given output files.

Input: This function accepts the file path for the output file 'output' if it exists. 
Outputs: It produces the coordinates for the pointer tip w.r.t. body B 'dk', the coordinates on the surface mesh 'ck', 
and the distance between the two 'diff'.


write2file_P3.m

This function produces an output file with the specified syntax. The first line is the number of frames, and name of the 
file. The rest of the file is the coordinates of the pointer tip w.r.t. body B, the coordinates of the points on the 
surface closest to the sample points, and the magnitude of the difference between the two. 

Inputs: this function accepts the tip coordinates 'dk', the surface mesh coordinates 'ck', the distance 'diff', and 
the name of the output file which is to be created 'output' 
Outputs: NULL


statisticalAnalysis_P3.m

This is a function that produces a stastical analysis of the data generated by my code compared to the solution 
output files.

Inputs: this function accepts the tip coordinate w.r.t. body B given in the solution output file 'c_sol' and generated 
by my code 'dk, dk_sol', the surface mesh coordinates given in the solution output file 'pem_sol' and generated by 
my code 'ck, ck_sol', and the distance between the two given in the output file 'vi_sol' and generated by my
code 'diff, diff_sol'
Outputs: It produces the magnitude of the maximum difference observed between the tip coordinates, and between the 
surface mesh coordinates 'max_diff_d', 'max_diff_c', the mean difference observed 'mean_diff_d', 'mean_diff_c' and the 
standard deviation 'stdev_diff_d', 'stdev_diff_c'. It also produces maximum and mean difference in the distance observed 
generated by the solution and my code.


MasterFunction.m

This is the master function to control all other functions. It calls the computeDk function to produce the tip 
coordinates w.r.t. body B, then it calls the closest point function to read the surface mesh file, and sends an 
argument of the tip coordinates computed, to find or compute the closest point to the tip coordinates that is present
on the surface mesh. It then calls the debugoutput_P3 function to read any output files that may be present. 
Then, it calls the write2file_P3 function to write any outputs you may have generated in the specified format.
Finally, it calls the statisticalAnalysis_P3 function to perform any analysis on the results you may have. 
Comment the function out if there is no output file that has been read.

Input: NULL
Output: NULL
