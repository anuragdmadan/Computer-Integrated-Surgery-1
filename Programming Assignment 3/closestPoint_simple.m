%This function finds the closest point on a given surface mesh, using a
%simple iterative closest point algorithm. For this assignment, the number
%of iterations is kept to 1, and the registration transformation is kept to
%identity.
%This function takes in the mesh coordinate details, and the position of
%the tip w.r.t. Body B as its input, and provides the coordinates of the
%closest point on the surface mesh, and the distance between the two
%points. 

function [d,c]=closestPoint_simple(meshFile, dk)

fid=fopen(meshFile);
x=fgetl(fid);
%Get the number of  frames.
n_vert = str2num(x);

DV=zeros(3,n_vert);
%The following for loops get the data of coordinates in the mesh into arrays
                                    
for i=1:n_vert
    x=fgetl(fid);
    DV(:,i)=round(str2num(x),2);
end
x=fgetl(fid);

%Get the number of triangles in the mesh
n_tr=str2num(x);
index=zeros(3,n_tr);
opp=zeros(3,n_tr);

%Get the index of each vertex in each triangle, and the indexes of the
%vertices opposite a vertex in a given triangle. 
for i=1:n_tr
    x=fgetl(fid);
    temp=str2num(x);
    index(:,i)=temp(1:3);
    opp(:,i)=temp(4:6);
end
fclose(fid);

%For this problem, we assume the registration matrix to be identity, and
%the number of iterations to be 1. So, the sample points are equal to the
%tip coordinates. 
sk=dk;

%Create an array to store the coordinates of each vertex in each triangle.
storage_triangle=zeros(3,3,n_tr);
for i=1:n_tr
    
    storage_triangle(:,1,i)=DV(:,index(1,i)+1);
    storage_triangle(:,2,i)=DV(:,index(2,i)+1);
    storage_triangle(:,3,i)=DV(:,index(3,i)+1);
    
end

c=zeros(3,1,size(sk,3));
d=zeros(1,size(sk,3));

%For each frame, we find the closest point and distance on each triangle to 
%the given tip coordinate, and take the minimum of these distances. The
%point corresponding to this distance is the closest point in the entire
%mesh to the given tip coordinate. 

for j=1:size(sk,3)
%Get an initial distance and point, by using triangle 1. 
    [d(:,j),c(:,:,j)]=DistanceCalculator_barycentric(storage_triangle(:,1,1),storage_triangle(:,2,1),storage_triangle(:,3,1),sk(:,:,j));
    for i=1:n_tr
%if triangle 'i' has a point with a smaller distance, we use triangle 'i'
%instead. 
        if DistanceCalculator_barycentric(storage_triangle(:,1,i),storage_triangle(:,2,i),storage_triangle(:,3,i),sk(:,:,j)) < d(:,j)
            [d(:,j),c(:,:,j)]=DistanceCalculator_barycentric(storage_triangle(:,1,i),storage_triangle(:,2,i),storage_triangle(:,3,i),sk(:,:,j));
        end
    end
end
