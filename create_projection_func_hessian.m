% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [A] = create_projection_func_hessian(OPTIONS,faces)
%create the hessian of the last-diff functional

NUM_OF_INDEXES_PER_EQUATION=OPTIONS.PROBLEM.INDS_TO_DEFINE_TRANSFORMATION_ELEMENT;
NUM_OF_EQUATIONS_PER_FACE=length(OPTIONS.PROBLEM.LIN_N-OPTIONS.PROBLEM.SD);
NUM_OF_INDEXES=NUM_OF_INDEXES_PER_EQUATION*NUM_OF_EQUATIONS_PER_FACE*length(faces);
X=zeros(NUM_OF_INDEXES,1);
Y=zeros(NUM_OF_INDEXES,1);
V=zeros(NUM_OF_INDEXES,1);
cur_pos=1;
cur_y=1;
[dims,vnums]=meshgrid(1:OPTIONS.PROBLEM.TD,1:OPTIONS.PROBLEM.NODES_IN_PRIMITIVE);
dims=dims(:)';
vnums=vnums(:)';

for face_ind=1:length(faces)
    
    face=faces{face_ind};
    
    
    for i=1:OPTIONS.PROBLEM.TD
        
        for j=1:OPTIONS.PROBLEM.SD
            
            
            inds=(face.inds(vnums)-1)*OPTIONS.PROBLEM.TD+dims;
            coef=(face.tframe(dims,i).*face.left_coef_mat(vnums,j))';
            
            new_pos=cur_pos+length(inds)-1;
            X(cur_pos:new_pos)=inds;
            Y(cur_pos:new_pos)=cur_y;
            V(cur_pos:new_pos)=coef*sqrt(face.volume);
            cur_pos=new_pos+1;
            cur_y=cur_y+1;
            
        end
    end
    
end

A=sparse(Y,X,V);
A=A'*A;

end

