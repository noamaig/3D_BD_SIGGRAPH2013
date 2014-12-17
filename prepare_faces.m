% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [ faces ] = prepare_faces( SV,TV,tri )
%given the source positions m X 3 SV, target positions m x 3 TV and the n x 4 list of
%indices for each tet "tri", create the faces
SD=size(tri,2)-1;
TD=size(TV,2);
notFullDim=size(SV,2)~=size(TV,2);
faces=cell(length(tri),1);
for i=1:length(tri);
    inds=tri(i,:);
    %source coordinates in 3d
    sv=SV(inds,:)';
    %target coordinates
    tv=TV(inds,:)';
    if notFullDim
        E=find_2d_embedding(sv);
        sv=E*sv;
    end
    %find mapping to target to give as initial guess
    A=find_affine_trans_between_source_and_target_face(sv,tv);
    %strip the uninteresting delta to get just the linear part
    A=A(:,1:end-1);
    %now get thr frames for this trans
    [U,E,V,~] = closest_rotation(A);
    
    %insert the face
    faces{i}=Tet(sv,SD,TD,inds,U,V,diag(E));
end
end

