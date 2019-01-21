%This function calculates the closest point in or on a triangle with
%vertices 'p', 'q', 'r', from a point in space 'a'
%a,p,q,r are 3D coordinates
%This function computes the barycentric coordinates for point a, by first
%computing the corresponding area ratios alpha, beta, gamma, and then the
%coordinate c. It also analyzes if the point lies inside the triangle by
%checking the range of each ratio.
function [dist,c] = DistanceCalculator_barycentric(p,q,r,a)
%computing the vectors
u=q-p;
v=r-p;
w=a-p;
%compute the area of the triangle
n=cross(u,v)/2;
%compute the ratio of areas covered by using the barycentric coordinate as
%one vertex
gamma=norm(dot(cross(u,w),n))/(4*norm(n)*norm(n));
beta=norm(dot(cross(w,v),n))/(4*norm(n)*norm(n));
alpha=1-beta-gamma;

%compute the barycentric coordinate
c=alpha*p+beta*q+gamma*r;

%check if the coordinate lies outside the triangle. If it does, identify
%which segment is closest based on the ratio of areas, and project the
%point on the segment. 
if gamma<0 || gamma>1
    c_star=projectionOnSegment(c,p,q);
    c=c_star;
end
if beta<0 || beta>1
    c_star=projectionOnSegment(c,r,p);
    c=c_star;
end
if alpha<0 || alpha>1
    c_star=projectionOnSegment(c,q,r);
    c=c_star;
end

%compute the distance
dist=norm(c-a);


