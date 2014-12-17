% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [SOL,SOL_VAL,flag] = minimize_functional(OPTIONS,faces,M,b)
%Solve the projection problem for the given parameters
%Input: OPTIONS, the OPTIONS struct
%faces: The cell-array holding all tets
% M,b- THe matrix & RHS of constraints on the positions s.t the solution 
%     must satisfy M*x==b

%If first iteration, create the hessian, if not no need
if isempty(OPTIONS.ALG.HESSIAN)
    OPTIONS.ALG.HESSIAN=create_projection_func_hessian(OPTIONS,faces);
end
QUAD_F=OPTIONS.ALG.HESSIAN;
%generate the linear part of the functional, this changes every iteration 
%due to the differentials we are projection changing
LIN_F=create_projection_func_linear(OPTIONS,faces);
%setup the inequality matrix, changes every iteration
[B,bound]=create_ineq_matrix(faces,OPTIONS);

opts = optimset('Algorithm','interior-point-convex','TolFun',1e-14,'TolX',1e-14,'TolCon',1e-14);%,'Diagnostics','on');
%if ~OPTIONS.GRAPHICS.VERBOSE
    
    opts=optimset(opts,'Display','off');
%end

[SOL,SOL_VAL,flag] = quadprog(QUAD_F,LIN_F,B,bound,M,b,[],[],[],opts);


if flag~=1
    fprintf('!!!!! quadprog failed! flag:%i\n',flag);
end

end

