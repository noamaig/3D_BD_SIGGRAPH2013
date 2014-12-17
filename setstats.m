% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function stats=setstats(stats,iter,dist_to_initial,dist_to_last,dist_to_last_map,flag,SOL_VAL,rigid_dist,flipcount,max_dist,td)
%set the statistics vector for the current iteration of the alg
iter=iter+1;
stats(iter).dist_to_initial=dist_to_initial;
stats(iter).dist_to_last=dist_to_last;
stats(iter).dist_to_last_map=dist_to_last_map;
stats(iter).flag=flag;
stats(iter).target_function=SOL_VAL;

stats(iter).rigid_dist=rigid_dist;

stats(iter).flips=flipcount;
stats(iter).max_distortion=max_dist;

stats(iter).runtime=td;
end
