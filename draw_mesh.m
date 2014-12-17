% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function draw_mesh( XX,tri,distortion,hadflip,anchor_coords,static_anchors ,OPTIONS)
%draw the mesh with distortion and flips highlighted and anchors marked
if OPTIONS.PROBLEM.TD==OPTIONS.PROBLEM.SD&& OPTIONS.PROBLEM.SD==3
    [tris,inds]=boundary_faces(tri,hadflip);
else
    tris=tri;
    inds=1:length(distortion);
end
c=distortion(inds,:);

if ~isempty(tri)
    if OPTIONS.PROBLEM.TD==3
        FV={};
        FV.faces=tris;
        FV.vertices=XX;
        %VN=patchnormals(FV);
        trimesh(tris(hadflip(inds)==0,:),XX(:,1), XX(:,2), XX(:,3),'EdgeColor','k','FaceColor','flat','FaceVertexCData',c(hadflip(inds)==0),'CDataMapping','scaled','FaceLighting','flat','BackFaceLighting','lit');%,'VertexNormals',VN);
        hold on
        trimesh(tris(hadflip(inds)==1,:),XX(:,1), XX(:,2), XX(:,3),'EdgeColor','k','FaceColor','yellow');
    else
    end
end
if ~isempty(anchor_coords)
    scatter3(anchor_coords(static_anchors,1),anchor_coords(static_anchors,2),anchor_coords(static_anchors,3),50,'blue','filled');
    scatter3(anchor_coords(~static_anchors,1),anchor_coords(~static_anchors,2),anchor_coords(~static_anchors,3),50,'green','filled');
end
hold off;
end

