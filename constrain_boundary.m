% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [ anchors,anchor_coords] = constrain_boundary( X,T )
%create constraints for the entire boundary to stay in place
anchors=unique(boundary_faces(T,zeros(length(T),1)));
anchor_coords=X(anchors,:);



end

