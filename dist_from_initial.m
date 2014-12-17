% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [d,v,m] = dist_from_initial( OPTIONS )
%given a OPTIONS struct, return 
%d - the distance of the final map to the initial map
%v - total mesh volume
%m - maximal distance over all differentials i.e same as d but for l inf norm

init_f=faces_from_pos(OPTIONS,OPTIONS.PROBLEM.INITIAL_TARGET_POS);
A1={};
for i=1:length(init_f)
    A1{i}=init_f{i}.tframe*init_f{i}.A*init_f{i}.sframe';
end
final_f=faces_from_pos(OPTIONS,OPTIONS.FINAL_POS);
d=0;
v=0;
m=0;
for i=1:length(init_f)
    theNorm=norm(A1{i}-final_f{i}.tframe*final_f{i}.A*final_f{i}.sframe','fro')^2;;
    m=max(m,theNorm);
    d=d+abs(init_f{i}.volume)*theNorm;
    v=v+abs(init_f{i}.volume);
end
d=d/v;
d=sqrt(d);
end
function f=faces_from_pos(OPTIONS,pos)
f=OPTIONS.PROBLEM.FACES;
a=zeros(length(pos)*OPTIONS.PROBLEM.TD,1);
for i=1:OPTIONS.PROBLEM.TD
    a(i:OPTIONS.PROBLEM.TD:end)=pos(:,i);
end
f=setFacesFromVec(f,a);
end
