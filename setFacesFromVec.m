% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function ret=setFacesFromVec(OPTIONS,faces,SOL)
%set the faces' differentials from the SOL which is the solution to the
%optimization problem.
pos=SOL(1:OPTIONS.PROBLEM.N*OPTIONS.PROBLEM.TD);%trim anything that is not positional

if isempty(OPTIONS.ALG.pos_to_affine_mat)
    OPTIONS.ALG.pos_to_affine_mat=create_matrix_of_position_to_affine(OPTIONS,faces,1);
end

vars=OPTIONS.ALG.pos_to_affine_mat*pos;
ret=cell(size(faces));
for face_ind=1:length(faces)
    face=faces{face_ind};
    ind=(face_ind-1)*OPTIONS.PROBLEM.AFF_N;
    face.A=reshape(vars(ind+1:ind+OPTIONS.PROBLEM.LIN_N),OPTIONS.PROBLEM.TD,OPTIONS.PROBLEM.SD);
    face.delta=vars(ind+OPTIONS.PROBLEM.LIN_N+1:ind+OPTIONS.PROBLEM.AFF_N);
    face.B=face.tframe'*face.A*face.sframe;

    face.gtcoords=pos(get_all_indexes_in_solution_vector(face.inds,OPTIONS));
    face.tframe=eye(OPTIONS.PROBLEM.TD,OPTIONS.PROBLEM.TD);
    face.sframe=eye(OPTIONS.PROBLEM.SD,OPTIONS.PROBLEM.SD);
    ret{face_ind}=face;
end




end
