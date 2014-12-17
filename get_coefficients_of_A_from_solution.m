% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [inds,coef] = get_coefficients_of_A_from_solution(OPTIONS,face,i,j)

%return the coefficients and indices into the solution vector, so that 
% sol(inds)'*coef=A(i,j) where A is the differential of the given face
persistent dims;
persistent vnums;
persistent dim_size;
new_size=[OPTIONS.PROBLEM.TD OPTIONS.PROBLEM.SD];
if isempty(dims) || any(dim_size~=new_size)
    [dims,vnums]=meshgrid(1:OPTIONS.PROBLEM.TD,1:OPTIONS.PROBLEM.NODES_IN_PRIMITIVE);
    dims=dims(:)';
    vnums=vnums(:)';
    dim_size=new_size;
end
inds=(face.inds(vnums)-1)*OPTIONS.PROBLEM.TD+dims;
coef=(face.tframe(dims,i).*face.left_coef_mat(vnums,j))';

end

