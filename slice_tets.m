% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function ntets = slice_tets(V,tets,normal,center)
%return all tets that are completely on one side of the plane with the
%given normal and passing through the given cetner. 
normal=normal/norm(normal);
if size(normal,1)==1
    normal=normal';
end
offset=center*normal;
res=V*normal-offset;
res=res>0;
goodside=res(tets);
goodside=sum(goodside,2);
ntets=tets(goodside>0,:);


end

