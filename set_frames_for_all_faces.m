% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [ ret,distortion,flip ] = set_frames_for_all_faces(OPTIONS,faces)
%compute the SVD for each tet and reset it
%returns new array of faces with the new svd, the distortion on each face
%and a boolean array of which faces were flipped
flip=zeros(length(faces),1);
ret=cell(length(faces),1);
for i=1:length(faces)
    face=faces{i};
    [had_flip]=set_frames(face);    
    flip(i)=had_flip;
    ret{i}=face;
end
distortion=compute_distortion(faces,OPTIONS);

end

