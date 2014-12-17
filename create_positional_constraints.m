% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [M,b] = create_positional_constraints( anchors,anchor_coords,td,sol_length)
%create M,b so that M*sol==b iff positional constraints are satisified
%anchors - indices of vertices to constraints
%anchor_coords - the coordinates of the constrained vertices
%td - the target dim
%sol_length - length of solution vector

%if no anchors do nothing
if isempty(anchors)
    M=[];
    b=[];
    return;
end

M=sparse(length(anchors)*td,sol_length);
b=zeros(size(M,1),1);
for i=1:length(anchors)
    
    for j=1:td
        eq_num=(i-1)*td+j;
        M(eq_num,get_index_in_solution_vector(anchors(i),j,td))=1;
        b(eq_num)=anchor_coords(i,j);
    end
    
end

end

