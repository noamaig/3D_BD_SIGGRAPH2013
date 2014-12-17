% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function draw_everything(OPTIONS,iter)
%all graphics operations
if ~OPTIONS.GRAPHICS.RENDER
    return
end
MESH_FIG=100;
GRAPH_FIG=101;
if iter==1
    if ishandle(MESH_FIG)
        close(MESH_FIG);    
    end
    if ishandle(GRAPH_FIG)
        close(GRAPH_FIG);
    end
end
hadflip=OPTIONS.FINAL_FLIPS;
distortion=OPTIONS.FINAL_DISTORTION;
XX=OPTIONS.FINAL_POS;

stats=OPTIONS.STATS;

titleText=sprintf('iter #%d\nmax dist: %10.5g\nquad func: %d\nflip count: %d\ndist to last: %d\n',iter,stats(end).max_distortion,stats(end).target_function,stats(end).flips,stats(end).dist_to_last_map);

if OPTIONS.GRAPHICS.DRAW_MESH
    
    
    
    figure(MESH_FIG);
    
    if OPTIONS.PROBLEM.TD==2
        
        clf
        patch('Faces',OPTIONS.PROBLEM.TRI(hadflip==0,:),'Vertices',XX,'FaceColor','flat',...
            'FaceVertexCData',distortion(hadflip==0),...
            'CDataMapping','scaled');%
        
        
        hold on
        patch('Faces',OPTIONS.PROBLEM.TRI(hadflip==1,:),'Vertices',XX,'FaceColor','yellow');%
        if ~isempty(OPTIONS.PROBLEM.CONSTRAINTS.ANCHOR_COORDS)
            scatter(OPTIONS.PROBLEM.CONSTRAINTS.ANCHOR_COORDS(:,1),OPTIONS.PROBLEM.CONSTRAINTS.ANCHOR_COORDS(:,2),50,'MarkerEdgeColor','black','MarkerFaceColor','g','LineWidth',1);
        end
        hold off;
        set_color_map();
        axis off
    else
        draw_mesh(XX,OPTIONS.PROBLEM.TRI,distortion,hadflip,OPTIONS.PROBLEM.CONSTRAINTS.ANCHOR_COORDS,[],OPTIONS);
        set_color_map();
    end
    
    
    
end

axis equal;%(ax);





% subplot(1,2,2);
figure(GRAPH_FIG);

plot_stats(stats,OPTIONS);
title(titleText);

% if OPTIONS.PROBLEM.TD==OPTIONS.PROBLEM.SD&&OPTIONS.PROBLEM.SD==3&&mod(iter,OPTIONS.GRAPHICS.CROSSCUT_FREQ)==0
%     animate_cross_section;
% end
if OPTIONS.GRAPHICS.VERBOSE
    fprintf(['#### ' titleText]);
end
end

