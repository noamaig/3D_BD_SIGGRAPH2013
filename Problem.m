% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

classdef Problem <handle
    %class representing the problem at hand.
    properties
        %K;
        TD;%target dim
        SD;%source dim
        
        %PRE CALCULATED VARIABLES
        LIN_N;%ELEMENTS IN LINEAR PART OF MAP ON FACE
        AFF_N;%ELEMENTS IN LINEAR + translation PART OF MAP ON FACE
        NODES_IN_PRIMITIVE; %HOW MANY VERTICES in A FACE\TET
        %INITIAL_GUESS; %INITIAL GUESS OF FRAMES
        INDS_TO_DEFINE_TRANSFORMATION_ELEMENT; %HOW MANY pos. VARIABLES TO DEFINE ONE TRANFORMATION ELEMENT
        
        
        
        N; %  # OF VERTICES
        SOURCE_POS; %INITIAL POSITION OF VERTICES (THE SOURCE MESH)
        INITIAL_TARGET_POS; %INITIAL TARGET POSITION
        SOL_LENGTH; %LENGTH OF SOLUTION
        TRI; %the triangulation\tetrahedration of the mesh
        CONSTRAINTS={};
        MESH_VOLUME;
        INITIAL_GLOBAL_A={};
        
        FACES=[];
    end
    
    methods
        function PROBLEM=Problem(TD,SD,initialSourcePos,initialTargetPos,tri,constraints,ALG,faces)
            vol=0;
            for i=1:length(faces)
                vol=vol+faces{i}.volume;
                PROBLEM.INITIAL_GLOBAL_A{i}=faces{i}.tframe*faces{i}.A*faces{i}.sframe';
            end
            %PROBLEM.K=K;
            PROBLEM.TD=TD;%target dim
            PROBLEM.SD=SD;%source dim
            PROBLEM.LIN_N=PROBLEM.SD*PROBLEM.TD;
            PROBLEM.AFF_N=PROBLEM.LIN_N+PROBLEM.TD;
            PROBLEM.NODES_IN_PRIMITIVE=PROBLEM.SD+1;
            %PROBLEM.INITIAL_GUESS=initialGuessFrames;
            PROBLEM.INDS_TO_DEFINE_TRANSFORMATION_ELEMENT=PROBLEM.TD*PROBLEM.NODES_IN_PRIMITIVE;
            PROBLEM.INITIAL_TARGET_POS=initialTargetPos;
            
            
            PROBLEM.N=size(initialSourcePos,1);
            PROBLEM.SOURCE_POS=initialSourcePos;
            PROBLEM.SOL_LENGTH=PROBLEM.N*PROBLEM.TD;
           
            PROBLEM.TRI=tri;
            %             PROBLEM.CONSTRAINTS.ANCHORS=anchors; %indexes of vertices that are anchored
            %             PROBLEM.CONSTRAINTS.ANCHOR_COORDS=anchor_coords; %the coordinates to move the vertices to
            %PROBLEM.CONSTRAINTS=PosConstraints(anchors,anchor_coords,TD,PROBLEM.SOL_LENGTH,initialSourcePos);
            PROBLEM.CONSTRAINTS=constraints;
            PROBLEM.MESH_VOLUME=vol;
            PROBLEM.FACES=faces;
        end
    end
    
end

