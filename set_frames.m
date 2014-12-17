% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [flip]=set_frames(face)
%set the frames for the given face
%returns true iff face is flipped
A=face.tframe*face.A*face.sframe';
[U,E,V,flip]=closest_rotation(A);
if ~isempty(face.normal_vote)
    dir=face.normal_vote*U(:,3);
    assert(isscalar(dir));
    if dir<0
        U(:,2:3)=-U(:,2:3);
        E(2,2)=-E(2,2);
        flip=1;
    end
end
face.sv=diag(E);
sf=V;
tf=U;
face.sframe=sf;
face.tframe=tf;
face.A=E;
set_left_coef_matrix(face);

end

