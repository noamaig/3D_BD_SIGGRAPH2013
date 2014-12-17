% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/


function [newX,OPTIONS,flag]=improve_mesh(X,tri,K,constrainBoundary)
%Improve a given mesh so all tets have bounded aspect ratio
%Arguments: 
% X - the n on 3 matrix of veritces
% tri - the m on 4 matrix of tetrahedra
% K - the aspect-ratio bound
% constrainBoundary (optional): if equal 1, will constrain the boundary
% to stay in place. Usually raises the feasible K.

%Output:
% newX - new positions of the vertices
% OPTIONS - struct with additional data, used internally (e.g. in the
% viewer).
% flag - convergence flag. 1 iff converged to a bounded aspect-ratio mesh.

fprintf('improving mesh...\n');
fprintf('setting up\n');
alg=Alg();
alg.ONLY_ONE_INEQ=1;
if exist('constrainBoundary','var')&&constrainBoundary
    [anchors,anchor_coords]=constrain_boundary(X,tri);
else
    anchors=1;
    anchor_coords=X(1,:);
end

%set up equilateral tri
eq_tri=[
    0 1 1/sqrt(2) ;
    -1 0 -1/sqrt(2);
    1 0 -1/sqrt(2);
    0 -1 1/sqrt(2)];

faces=cell(length(tri),1);

for i=1:length(tri);
    inds=tri(i,:);
    %source coordinates in 3d
    sv=eq_tri';
    %target coordinates
    tv=X(inds,:)';
    
    
    %find mapping to target to give as initial guess
    A=find_affine_trans_between_source_and_target_face(sv,tv);
    %strip the uninteresting delta to get just the linear part
    A=A(:,1:end-1);
    %now get thr frames for this trans
    [U,E,V,~] = closest_rotation(A);
    
    %this is just to handle bad subdivision that inverts orientation
    if E(3,3)<0
        sv=eq_tri([2 1 3 4],:)';
        A=find_affine_trans_between_source_and_target_face(sv,tv);
        %strip the uninteresting delta to get just the linear part
        A=A(:,1:end-1);
        %now get thr frames for this trans
        [U,E,V,~] = closest_rotation(A);
    end
    assert(E(3,3)>0);
    %insert the face
    faces{i}=Tet(sv,3,3,inds,U,V,diag(E));
end

constraints=PosConstraints(anchors,anchor_coords,3,length(X)*3,X);
problem=Problem(3,3,X,X,tri,constraints,alg,faces);


OPTS=Options(problem,alg, K);% 3.1862);
fprintf('running\n');
[OPTIONS,flag]=solve_problem(OPTS,faces);
if flag~=1
    warning('Improvement failed');
end
newX=OPTIONS.FINAL_POS;
end
