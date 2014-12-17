% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

classdef PosConstraints<handle
    
    %matrix representing the positional constraints.
    properties
        M;%matrix
        b;%rhs
        ANCHORS=[];
        ANCHOR_COORDS=[];
        STATIC_ANCHORS;
    end
    
    methods
        function obj= PosConstraints(anchors,anchor_coords,td,sol_length,POS)
            obj.ANCHORS=anchors;
            obj.ANCHOR_COORDS=anchor_coords;
            [obj.M,obj.b] = create_positional_constraints( anchors,anchor_coords,td,sol_length);
            if isempty(anchors)
                static_anchors=[];
            else
                adiff=POS(anchors,:)-anchor_coords;
                adist=sum(adiff.^2,2);
                static_anchors=adist<1e-10;
            end
            obj.STATIC_ANCHORS=static_anchors;
        end
    end
    
end

