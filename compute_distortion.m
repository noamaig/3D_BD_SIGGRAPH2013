% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [distortion] = compute_distortion( faces,OPTIONS )
%compute the distortion for each of the given faces.
distortion=zeros(length(faces),1);

if OPTIONS.ISOMETRY %change distortion type
    for i=1:length(faces)
        A=faces{i}.A;
        dist=max(A(1,1),1/abs(A(OPTIONS.PROBLEM.SD,OPTIONS.PROBLEM.SD)));   
        distortion(i)=dist;        
    end
else
    for i=1:length(faces)
        A=faces{i}.A;
        dist=A(1,1)/abs(A(OPTIONS.PROBLEM.SD,OPTIONS.PROBLEM.SD));   
        distortion(i)=dist;        
    end
end



end

