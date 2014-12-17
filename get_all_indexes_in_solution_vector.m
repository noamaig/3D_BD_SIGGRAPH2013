% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function inds = get_all_indexes_in_solution_vector(vnums,OPTIONS)
%for the given vertices' indexes, returns all indexes (i.e for all 3
%coordinates in the solution vector) in the solution vector of the
%optimization problem
vnums=(vnums-1)*OPTIONS.PROBLEM.TD;
[a,b]=meshgrid(vnums,1:OPTIONS.PROBLEM.TD);
inds=a+b;
end

