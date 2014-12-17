% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [projected_X,OPTIONS]=project_on_bd(source_X,target_X,tri,K,M,b,varargin)
%Project a map to get a bounded-distortion map.

%Arguments:
% source_X - the vertices's locations in the given mesh (n on 3 matrix)
% target_X - the mapped vertices positions, so that Phi(source_X)=target_X
% (n on 3 matrix).
% tri - the tetrahedra. indices into the vertices matrices (m on 4 matrix
% K - the desired distortion-bound.
%%%%% OPTIONAL ARGUMENTS %%%%
% M,b - the matrix of constraints and the right-hand-side vector of
% constraints, so that it is enforced that M*x=b, where x is the
% "flattened" vector of vertex positions, i.e. if Y is the n-on-3 matrix of
% positions, then x=(Y(1,1),Y(1,2),Y(1,3),Y(2,1),Y(2,2),...,Y(n,2),Y(n,3)).
% more arguments can be assigned via string-value pairs, where optional
% arguments are:
% 'render' ({1} | 0) - draw the mesh and data in each iteration.
% 'verbose' ({1} | 0) - print to the console
% 'isometry' (1 | {0}) - switch to isometric distortion (see paper).

%Output:
%project_X: the vertices's positions in the projected map
%OPTIONS - struct containing more data. Used for other applications, such
%as the viewer
assert(exist('b','var')==exist('M','var'),'Either both M and b are given, or neither');
hasM=exist('M','var')&&~isempty(M);
if hasM
    pos=[];
    posc=[];
else %if no costraints are given, constrain one vertex to prevent translational invariance
    pos=1;
    posc=target_X(1,:);
end
constraints=PosConstraints(pos,posc,size(target_X,2),numel(target_X),[]);

if hasM
    if size(M,1)~=size(b,1)
        error('the constraint matrix and constraint rhs should have same vertical size');
    end
    constraints.M=M;
    constraints.b=b;
end

alg=Alg();
alg.ONLY_ONE_INEQ=1;
faces=prepare_faces(source_X,target_X,tri);
problem=Problem(size(target_X,2),min(size(source_X,2),size(tri,2)-1),source_X,target_X,tri,constraints,alg,faces);
OPTS=Options(problem,alg,K);
for i=1:2:length(varargin)
    if strcmp(varargin(i),'render')
        OPTS.GRAPHICS.RENDER=varargin{i+1};
    end
    if strcmp(varargin(i),'verbose')
        OPTS.GRAPHICS.VERBOSE=varargin{i+1};
    end
    if strcmp(varargin(i),'isometry')
        OPTS.ISOMETRY=varargin{i+1};
    end
end

OPTS.ALG.ITERATIONS=500;
OPTIONS=solve_problem(OPTS,faces);
projected_X=OPTIONS.FINAL_POS;
end
