# Computer-Integrated-Surgery-1 Readme

NOTE: Do not use the code uploaded here for the programming assignments for Computer Integrated Surgery. 

The code contains Anurag Madan's implementation of programming assignments 1-4 for the Computer Integrated Surgery 1 class at Johns Hopkins University, taught by Dr. Russell Taylor. 
Link: http://www.cs.jhu.edu/cista/455/455-schedule-2018.html

More detailed readme's are attached in each individual folder. 

Programming Assignment 1: 
This assignment required development of a 3D point set to 3D point set registration algorithm, a pivot point calibration, and frame transformations between different sensor coordinate systems, given sensor readings. 

Programming Assignment 2: 
This assignment required undistorting the electromagnetic tracker data using a Bernstein Polynomial approximation and clean optical tracker data, and calculating probe tip coordinates in CT image coordinates based on this undistorted EM data. 

Link to assignments 1 and 2: http://www.cs.jhu.edu/cista/455/Homework_2018/Programming%20Assignments%201%20and%202/ProgrammingAssignments1and2.pdf


Programming Assignmnent 3: 
 Given a 3D mesh of a bone containing coordinates of triangles, a rigid body screwed into the bone and another rigid body being used as a pointer, this assignment required developing an Iterative Closest Point algorithm to find the closest point on the mesh to the tool tip of the pointer. Assignment 3 did not require the iteration to be done, so the closest point was found assuming the body screwed into the bone was in an identity frame transformation w.r.t. the coordinate frame of the mesh. 
 
 Programming Assignmnet 4:
 This was a continuation of Assignment 3, with an iteration being added. This was the fully implemented Iterative Closest Point algorithm. There were two scripts written, one using a linear search through all triangles to find the closest point, and one using an optimized search through a subset of the triangles, significantly increasing efficiency without causing significant errors. 
 
 Link to assignments 3 and 4:
 http://www.cs.jhu.edu/cista/455/Homework_2018/Programming%20Assignments%203,%204,%20and%205/Programming%203%20and%204%20%20600-445-2018.pdf
 
 
 
