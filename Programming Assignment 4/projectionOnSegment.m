%This function finds the closest point on a line segment with two
%coordinates 'p' and 'q', from a point 'c'

function c_star = projectionOnSegment(c,p,q)

l=dot(c-p,q-p)/dot(q-p,q-p);

l_star=max(0,min(l,1));
c_star=p+l_star*(q-p);