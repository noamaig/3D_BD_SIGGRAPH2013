function theta = compute_dihedral_of_tet( V )
%compute the 6 dihedral angles of a tet

%these are the indices of the faces:
% 1     2     3
% 1     3     4
% 1     4     2
% 2     4     3
%compute for each face [f1 f2 f3] the vectors f3-f1 and f3-f2
e1=[V(3,:)-V(1,:);
    V(4,:)-V(1,:);
    V(2,:)-V(1,:);
    V(3,:)-V(2,:);];
e2=[V(3,:)-V(2,:);
    V(4,:)-V(3,:);
    V(2,:)-V(4,:);
    V(3,:)-V(4,:);];
%now compute from these the normal
N=cross(e2,e1);
%comptue centroid
c=mean(V);
%tet might have had reverse orientation, if so all normals are inverted so 
%just check one and invert all according to it. check face's normal is
%opposite to the 4th vertex, i.e the one not in the face
if dot(N(1,:),V(4,:)-c)>0
    N=-N;
end
%to be on the safe side make sure all normals have correct direction 
assert(dot(N(1,:),V(4,:)-c)<0);
assert(dot(N(2,:),V(2,:)-c)<0);
assert(dot(N(3,:),V(3,:)-c)<0);
assert(dot(N(4,:),V(1,:)-c)<0);
%normalize the normals to unit length
nNorm = sqrt(sum(N.^2, 2));
D=diag(1./nNorm);
N=D*N;
%indices of all pairs of faces:
pairs=[1 2;1 3;1 4;2 3; 2 4; 3 4];
theta = acos(dot(N(pairs(:,1),:),-N(pairs(:,2),:), 2));
assert(all(theta>0));
end

