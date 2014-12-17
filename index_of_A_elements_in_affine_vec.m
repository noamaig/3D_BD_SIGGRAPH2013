% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function ind= index_of_A_elements_in_affine_vec(face_ind,i,j,adddelta,OPTIONS)
%given an entry in one of the faces' affine matrix returns the index of it
%in the flattened vector of affine map entries
if adddelta
    msize=OPTIONS.PROBLEM.AFF_N;
else
    msize=OPTIONS.PROBLEM.LIN_N;
end
ind=(face_ind-1)*msize+(j-1)*OPTIONS.PROBLEM.TD+i;
end

