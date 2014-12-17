% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function set_left_coef_matrix(face)
%set the coefficient matrix that extracts the differential from the
%vertices
face.scoords=face.sframe'*face.gscoords;
face.left_coef_mat=face.global_left_coef_mat*face.sframe;

end

