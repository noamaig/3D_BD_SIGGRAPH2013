% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

% load a mesh. We will only use X_source (the original vertices' 
% location) and tri.
load('elephant_stand_5.mat');

%improve the mesh's tets to have maximal aspect-ratio distortion of 5
[newX,OPTIONS,flag]=improve_mesh(X_source,tri,5);
fprintf('Improved the maximal aspect ratio from %f to %f\n',max(OPTIONS.INITIAL_DISTORTION),max(OPTIONS.FINAL_DISTORTION));
