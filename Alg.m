% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

classdef Alg < handle
    %All flags related to the algorithm and internal data
    
    properties
        ITERATIONS=10000; %iterations till finish
        ONLY_ONE_INEQ=0; %only A_11/A_33 and vice versa
        pos_to_affine_mat=[]; %matrix that yields the affine trans. from pos. vars. is set later on in the run 
        HESSIAN=[];%will hold the target function's hessian
    end
    
    methods
        function ALG=Alg()
            
            
            
            
            
        end
    end
    
end

