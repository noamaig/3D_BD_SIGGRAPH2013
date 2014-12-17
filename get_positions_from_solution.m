% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function ret = get_positions_from_solution(SOL,OPTIONS)
%return the N X 3 positions from the given solution vector
N=OPTIONS.PROBLEM.N;
ret=reshape(SOL(1:N*OPTIONS.PROBLEM.TD),OPTIONS.PROBLEM.TD,N)';

end

