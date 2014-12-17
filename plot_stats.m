% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function plot_stats( stats,OPTIONS)
%plot the stats
lqf=log([stats.target_function]+1);



ldst=log(max([stats.max_distortion]-OPTIONS.K,0)+1);




    %plot(xs,lqf,'b',xs,flips,'g',xs,ldst,'r',xs,flags,'black',length(quad_func),mlqf,'b*',length(quad_func),mldst,'r*');
    Y=[lqf' [stats.flips]' ldst' [stats.flag]' ];
    
    L={'log quad func','#flips','log max dist','flag'};
    



if OPTIONS.GRAPHICS.DIST_TO_BD
    Y=[Y [stats.dist_to_bd]'/OPTIONS.PROBLEM.MESH_VOLUME];
    L=[L,'dist to BD'];
end

if OPTIONS.GRAPHICS.DIST_TO_INITIAL
    Y=[Y [stats.dist_to_initial]'/OPTIONS.PROBLEM.MESH_VOLUME];
    L=[L,'dist to initial'];
end
Y=[stats.dist_to_last_map]';
L={'dist to last'};


plot(1:length(Y)-1,Y(2:end));
legend(L);

end

