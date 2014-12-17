% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

%An example of how to use the code to project a mapping on the bounded
%distortion space

%load data
load('elephant_stand_5.mat');
%run the projection
[X,OPTIONS]=project_on_bd(X_source,X_target,tri,K,constraint_matrix,constraint_rhs);
