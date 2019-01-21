%This function finds the closest point on a given surface mesh, using a
%sorted iterative closest point algorithm. The number of iterations is
%dependent on the distance between the sample point and the point on the
%mesh, with an upper limit on the iteration being defined.
%This function takes in the mesh coordinate details, and the position of
%the tip w.r.t. Body B as its input, and provides the coordinates of the
%closest point on the surface mesh, and the distance between the two
%points. 

function [sk,d,c]=ICP_optimized(meshFile, dk)
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


%Create an array to store the coordinates of each vertex in each triangle.
storage_triangle=zeros(3,3,n_tr);
%The boundbox does the same thing as storage_triangle, except it also
%separates the data according to the octant
boundbox=zeros(8,3,3,n_tr);
centroid=zeros(3,1,n_tr);
count=zeros(8,1);
for i=1:n_tr
    
    storage_triangle(:,1,i)=DV(:,index(1,i)+1);
    storage_triangle(:,2,i)=DV(:,index(2,i)+1);
    storage_triangle(:,3,i)=DV(:,index(3,i)+1);
%computing the centroid of the triangles. This is used to determine the
%octant.
    centroid(:,:,i)=(storage_triangle(:,1,i)+storage_triangle(:,2,i)+storage_triangle(:,3,i))/3;
%this is a sequence to uniquely determine the octant based on the signs of
%the x,y,z coordinates. It follows the same concept as binary to decimal
%conversion. the x coordinate sign has a weight 1, y has weight 2 and z has
%weight 4. The if-else cases convert the negative cases to their
%corresponding positives. So, let the coordinates be [-1,3,-6]. 
%x=1*(-1)+2*(1)+4*(-1) = -3. But we want to treat the -1 as a 0, as it is
%in binary conversion. So, -3 becomes 2. And so on. 
    x=sign(centroid(1,:,i))+2*sign(centroid(2,:,i))+4*sign(centroid(3,:,i));
    if x==-1
        x=3;
    elseif x==-3
        x=2;
    elseif x==-5
        x=1;
    elseif x==-7
        x=0;
    end
    x=x+1;
%count keeps track of the number of elements in each octant. 
    count(x,1)=count(x,1)+1;
    boundbox(x,:,1,count(x,1))=DV(:,index(1,i)+1);
    boundbox(x,:,2,count(x,1))=DV(:,index(2,i)+1);
    boundbox(x,:,3,count(x,1))=DV(:,index(3,i)+1);
end

%initialize F_reg to identity
rreg=eye(3);
preg=[0;0;0];
sk=zeros(size(dk));

c=zeros(3,1,size(sk,3));
d=zeros(1,size(sk,3));
 for i=1:size(dk,3)
    sk(:,:,i)=rreg*dk(:,:,i)+preg;
end

sk_2D=three2twoDim(sk);
c_2D=three2twoDim(c);
n=zeros(1,size(sk_2D,2));
%compute the initial distance between the tip coordinates and the mesh
%point. This will be pretty high. 
for i=1:size(sk_2D,2)
    n(:,i)=norm(sk_2D(:,i)-c_2D(:,i));
end
%initialize a counter to keep track of the number of iterations.
counter=0;

%start the iterations. Here, we continue iterations while the distance
%between the tip coordinates and the mesh point is greater than a fixed
%number, and the number of iterations is less than a set value. 

while(max(n)>0.5 && counter < 10)
    counter=counter+1;
   %compute the sample points based on F_reg and the tip coordinates. 
    for i=1:size(dk,3)
        sk(:,:,i)=rreg*dk(:,:,i)+preg;
    end
    sk_2D=three2twoDim(sk);
    c_2D=three2twoDim(c);
    %compute the distance between the tip coordinates and the mesh
    %point
    for i=1:size(sk_2D,2)
        n(:,i)=norm(sk_2D(:,i)-c_2D(:,i));
    end
    
%For each frame, we find the closest point and distance on each triangle to 
%the given tip coordinate, and take the minimum of these distances. The
%point corresponding to this distance is the closest point in the entire
%mesh to the given tip coordinate. 

    for j=1:size(sk,3)
    %find the octant for the tip coordinate
        x=sign(sk(1,:,j))+2*sign(sk(2,:,j))+4*sign(sk(3,:,j));
        if x==-1
            x=3;
        elseif x==-3
            x=2;
        elseif x==-5
            x=1;
        elseif x==-7
            x=0;
        end
        x=x+1;
%We do the same thing as the simple ICP algorithm, but instead of using the
%entire file, we just search the required octant. 
         [d(:,j),c(:,:,j)]=DistanceCalculator_barycentric(boundbox(x,:,1,1)',boundbox(x,:,2,1)',boundbox(x,:,3,1)',sk(:,:,j));

        for i=1:count(x,:)
            if DistanceCalculator_barycentric(boundbox(x,:,1,i)',boundbox(x,:,2,i)',boundbox(x,:,3,i)',sk(:,:,j)) < d(:,j)
             [d(:,j),c(:,:,j)]=DistanceCalculator_barycentric(boundbox(x,:,1,i)',boundbox(x,:,2,i)',boundbox(x,:,3,i)',sk(:,:,j));

            end
        end
    end
     c_2D=three2twoDim(c);
    dk_2D=three2twoDim(dk);
    %based on the closest point computed, we recompute F_reg
    %transformation using a point cloud algorithm. 
   [rreg,preg]=pointSetRegistration(dk_2D,c_2D,size(dk_2D,2));
end
