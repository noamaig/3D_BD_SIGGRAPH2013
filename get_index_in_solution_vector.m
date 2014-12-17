% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function n = get_index_in_solution_vector(vnum,dnum,TD)
%get the index of the dnum coordinate of the vnum vertex in the solution 
%vector of the optimization problem. TD is the target dimension of the
%problem.
n=(vnum-1)*TD+dnum;
end

