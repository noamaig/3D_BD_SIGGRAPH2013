% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [ b_face,b_inds ] = compute_boundary( tet )
%given a tet list computes the boundary faces, with new indices. 
%the mapping of the new indexes to the old list of indexes is given via
%b_inds - b_face(k,:)==v ~~ tet(k,:)==b_inds(v)
if size(tet,2)==4
    b_face=boundary_faces(tet);
elseif size(tet,2)==3
    b_face=tet;
else
    error('wrong dimension');
end
b_inds=unique(b_face);

new_s_face=zeros(size(b_face));
for i=1:length(b_inds)
    new_s_face(b_face==b_inds(i))=i;
end
b_face=new_s_face;
end

