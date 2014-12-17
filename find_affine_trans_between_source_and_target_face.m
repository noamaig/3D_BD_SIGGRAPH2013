% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function A= find_affine_trans_between_source_and_target_face(sv,tv)
%finds the transformation matrix A s.t A*[sv;ones]=tv
M=[sv; ones(1,size(sv,2))];

% we want: A*M=tv;
% transpose: M'*A'=tv';
% So:   A'=M'\tv'
A=(M'\tv')';

end

