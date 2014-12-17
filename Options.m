% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

classdef Options <handle
    %Class that holds internal data relevant to the run
    
    properties
        GRAPHICS={};
        ALG;
        
        
        PROBLEM;        
        BD_SOLVER;
        K;
        INITIAL_FLIPS;
        INITIAL_DISTORTION;

        FINAL_POS=[];
        FINAL_DISTORTION;
        FINAL_FLIPS;
        STATS;
        TOTAL_TIME;
        ISOMETRY=0;
    end
    
    methods
        function OPTIONS=Options(problem,alg,K)
            OPTIONS.GRAPHICS.VERBOSE=1;
            OPTIONS.GRAPHICS.DRAW_MESH=1;
            OPTIONS.GRAPHICS.DIST_TO_INITIAL=0;
            OPTIONS.GRAPHICS.DIST_TO_BD=0;
            OPTIONS.GRAPHICS.RENDER=1;
            OPTIONS.PROBLEM=problem;
            OPTIONS.ALG=alg;
            OPTIONS.K=K;
            OPTIONS.BD_SOLVER=ClosestBDSolver(OPTIONS.K);
        end
        
    end
end
