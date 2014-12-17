% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [OPTIONS,flag]=solve_problem(OPTS,faces)
%Input:
% OPTS - OPTIONS struct 
% faces - all the tets in a cell array 
%ouput: OPTIONS struct holding the data for the projected map
sid=tic;



OPTIONS=OPTS;


%find the anchors that have not moved
if isempty(OPTIONS.PROBLEM.CONSTRAINTS.ANCHORS)
    static_anchors=[];
else
    adiff=OPTIONS.PROBLEM.INITIAL_TARGET_POS(OPTIONS.PROBLEM.CONSTRAINTS.ANCHORS,:)-OPTIONS.PROBLEM.CONSTRAINTS.ANCHOR_COORDS;
    adist=sum(adiff.^2,2);
    static_anchors=adist<1e-10;
end

K=OPTIONS.K;

stats={};

M=OPTIONS.PROBLEM.CONSTRAINTS.M;
b=OPTIONS.PROBLEM.CONSTRAINTS.b;


LAST_SOL=[];

hadflip=zeros(length(faces),1);
for i=1:length(faces)
    sv=faces{i}.sv;
    
    
    hadflip(i)=sv(end)<0;
    
end
distortion=compute_distortion(faces,OPTIONS);
OPTIONS.INITIAL_DISTORTION=distortion;
OPTIONS.INITIAL_FLIPS=hadflip;
stats=setstats(stats,0,0,0,0,0,0,0,sum(hadflip),max(distortion),0);
if OPTIONS.GRAPHICS.DIST_TO_INITIAL
    stats.dist_to_initial=0;
end
if OPTIONS.GRAPHICS.DIST_TO_BD
    d=0;
    for face_ind=1:length(faces)
        face=faces{face_ind};
        dd=diag(faces{i}.A);
        %assert(max(max(faces{i}.A-diag(d)))<1e-10);
        dd=OPTIONS.BD_SOLVER.findClosestDiag(dd');
        d=d+sum(sum((face.A-diag(dd)).^2))*face.volume;
    end
    stats.dist_to_bd=d;
end

FINAL_POS=OPTIONS.PROBLEM.INITIAL_TARGET_POS;
OPTIONS.FINAL_POS=FINAL_POS;
for iter=1:OPTIONS.ALG.ITERATIONS
    for i=1:length(faces)
        faces{i}.target_matrix=faces{i}.A;
    end
    tid=tic;
    dist_to_last=0;
    if 1||iter>1
        [SOL,SOL_VAL,flag]=minimize_functional(OPTIONS,faces,M,b);
        if isempty(SOL)
            warning('optimization failed and retuned an empty solution!');
            return;
        end
        XX=get_positions_from_solution(SOL,OPTIONS);
        
        
        
        faces=setFacesFromVec(OPTIONS,faces,SOL);
        
        dist_to_last_map=0;
        if iter>1
            for i=1:length(faces)
                dist_to_last_map=dist_to_last_map+norm(faces{i}.A-faces{i}.last_global_A)^2*faces{i}.volume;
                faces{i}.last_global_A=faces{i}.A;
            end
        else
            dist_to_last_map=0;
        end
        dist_to_last_map=sqrt(dist_to_last_map)/OPTIONS.PROBLEM.MESH_VOLUME;
        if iter>2
            dist_to_last=norm(SOL-LAST_SOL);
        end
        LAST_SOL=SOL;
        
    else
        flag=0;
        SOL_VAL=0;
    end
    dist_to_initial=0;
    if OPTIONS.GRAPHICS.DIST_TO_INITIAL
        d=0;
        for face_ind=1:length(faces)
            face=faces{face_ind};
            d=d+sum(sum((face.tframe*face.A*face.sframe'-faces{face_ind}.initial_A).^2))*face.volume;
        end
        
        dist_to_initial=d;
    end
    [faces,distortion,hadflip]=set_frames_for_all_faces(OPTIONS,faces);
    
    if OPTIONS.GRAPHICS.DIST_TO_BD
        d=0;
        
        for face_ind=1:length(faces)
            face=faces{face_ind};
            
            d=d+sum(sum((face.A-face.closest_BD).^2))*face.volume;
        end
        stats(iter+1).dist_to_bd=d;
    end
    
    rigid_dist=0;
    
    
    td=toc(tid);
    
    
    stats=setstats(stats,iter,dist_to_initial,dist_to_last,dist_to_last_map,flag,SOL_VAL,rigid_dist,sum(hadflip),max(distortion),td);
    OPTIONS.STATS=stats;
    
    FINAL_POS=XX;
    OPTIONS.FINAL_POS=FINAL_POS;
    OPTIONS.FINAL_DISTORTION=distortion;
    OPTIONS.FINAL_FLIPS=hadflip;
        draw_everything(OPTIONS,iter);

    if OPTIONS.ISOMETRY&&iter>2
        found=0;
        for faceind=1:length(faces)
            sv=faces{faceind}.sv;
            if sv(1)>OPTIONS.K+1e-6 || sv(OPTIONS.PROBLEM.SD)<1/OPTIONS.K-1e-6 && stats(end).flips(end)==0
                found=1;
            end
        end
        if ~found
            if OPTIONS.GRAPHICS.VERBOSE
                fprintf('+++++ stopped: reached bounded isometry +++++++\n');
            end
            break;
        end
    end
    
    if max(distortion)<OPTIONS.K  && stats(end).flips(end)==0
        if OPTIONS.GRAPHICS.VERBOSE
            fprintf('******** stopped: reached bounded-distortion *********\n');
        end
        break;
    end
    
    
    
    
end
if iter==OPTIONS.ALG.ITERATIONS
    error('didnt converge');
end
s=toc(sid);
OPTIONS.TOTAL_TIME=s;
for face_ind=1:length(faces)
    
    face=faces{face_ind};
    set_frames(face);
    
    if OPTIONS.PROBLEM.SD==OPTIONS.PROBLEM.TD
        if det(face.A)<0
            warning('face (%d) is flipped\n',face_ind);
        end
    end
    a=svd(face.A);
    
    if a(1)/a(end)>OPTIONS.K+1e-4
        warning('face (%d) is not bounded\n',face_ind);
    end
    
end
end
