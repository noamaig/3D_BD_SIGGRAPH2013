function angles = compute_dihaderal_for_mesh( V,T )
%input - V nX3 array of vertices, T mX4 array of tets 
%output - m*6 array of the dihedral angles
angles=zeros(length(T)*6,1)+inf;
for i=1:length(T)
    ind=(i-1)*6;
    angles(ind+1:ind+6)=compute_dihedral_of_tet(V(T(i,:),:));
end
assert(~any(isinf(angles)));
end

