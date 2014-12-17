% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function inds= cross_section_volume(V,T,x,n)
%given V the vertices of a volume and T the tets, and also x the centroid
%of a plane and n the normal to the plane, return the indices of all vertices 
%falling in the cross section defined as all tetrahedra that are completely 
%above the cutting plane defined by x,n
assert(numel(n)==3);
if size(n,2)~=1
    n=n';
end
assert(size(V,2)==3);
for i=1:3
    V(:,i)=V(:,i)-x(i);
end
above=V*n>0;
allAbove=sum(above(T),2)==4;
inds=find(allAbove);


end

