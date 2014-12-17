function [X,tri] = four_tets_from_tet( X,tri,anchors )
    lastNnz=-1;
    while(1)
        c=find_primitives_with_no_DOF(tri,anchors);
        newNnz=nnz(c);
        if newNnz==0
            break;
        end
        assert(newNnz~=lastNnz);
        lastNnz=newNnz;
        [X,tri]=subdivide_tets( X,tri,c );
        
        
    end
end

