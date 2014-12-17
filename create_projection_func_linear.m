% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [L] = create_projection_func_linear(OPTIONS,faces)
%create the linaer part of the last-diff functional

%see create_ineq_matri for detailed documentation


cur_pos=1;
cur_y=1;
[dims,vnums]=meshgrid(1:OPTIONS.PROBLEM.TD,1:OPTIONS.PROBLEM.NODES_IN_PRIMITIVE);
dims=dims(:)';
vnums=vnums(:)';
L=zeros(OPTIONS.PROBLEM.SOL_LENGTH,1);

for face_ind=1:length(faces)
    
    face=faces{face_ind};
    D=face.target_matrix;
    for i=1:OPTIONS.PROBLEM.SD
        
        
        
        inds=(face.inds(vnums)-1)*OPTIONS.PROBLEM.TD+dims;
        coef=(face.tframe(dims,i).*face.left_coef_mat(vnums,i))';
        
        new_pos=cur_pos+length(inds)-1;

        cur_pos=new_pos+1;
        cur_y=cur_y+1;
        
        L(inds)= L(inds)-coef'*face.volume*D(i,i);
        
        
    end
    
end


end

