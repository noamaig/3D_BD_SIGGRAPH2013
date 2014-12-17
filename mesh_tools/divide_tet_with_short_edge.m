function [tets,X] = divide_tet_with_short_edge( tets,X )
%remove any tet with a short edge (non-boundary edge connecting two boundary
%vertices), by splitting the tet into two tets by splitting the short edge
%into two.
for iter=1:100000000
    %set up boundary faces, edges and vertices
    bF=boundary_faces(tets);
    bE=sort(compute_edges(bF))';
    bV=unique(bF);
    temp=zeros(length(X),1);
    temp(bV)=1;
    %bv(i)==1 iff i is boundary
    bV=temp;
    %set ALL edges
    E=sort(compute_edges_for_tets(tets)')';
    %find inner edges
    inE=setdiff(E,bE,'rows');
    %find inner edges with both vertices are boundary (short edge)
    shortE=inE(sum(bV(inE),2)==2,:);
            fprintf('divide tet to 2: found %d short edges\n',size(shortE,1));

    

    if isempty(shortE)
        fprintf('divide tet to 2: finished\n');
        return;
    end
    %remove(i)==1 iff tet i is to bre removed as it was replaced with teh
    %two split tets created out of it
    remove=zeros(size(tets,1),1);
    
    for j=1:size(shortE,1)
        if mod(j,50)==1
            fprintf('finished %d/%d short edges\n',j,size(shortE,1));
        end
        %take first short edge
        e=shortE(j,:);
        %find all tets that have this edge
        removeTets=sum(ismember(tets,e),2)==2;
        %if any of these tets was already divided can't touch it 
        if any(remove(removeTets))
            continue;
        end
        %tets that have the short edge
        eTets=tets(removeTets,:);
        %remove these tets as they will get subdivided
        remove(removeTets)=1;
        %%%now subdivide each of these tets
        %first generate the new vertex and insert it
        v=(X(e(1),:)+X(e(2),:))/2;
        X=[X;v];
        %get index of the newly inserted v
        newInd=length(X);
        assert(~ismember(newInd,tets));
        for i=1:size(eTets,1)
            tet=eTets(i,:);

            [ two_tets ] = divide_tet_by_edge( tet,e );

            %we get -1 where the new vertex comes in, replace it with correct index
            two_tets(two_tets==-1)=newInd;

            tets=[tets;two_tets];
        end
        remove(length(tets))=0;
    end
    tets=tets(remove==0,:);
end

end

