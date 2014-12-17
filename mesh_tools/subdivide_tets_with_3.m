function [newX,newTri]=subdivide_tets_with_3( X,tet )
while(1)
    [newX,newTri]=subdivide_tets_with_3_one_iter( X,tet );
    if length(newTri)==length(tet)
        break
    end
    X=newX;
    tet=newTri;
    
end

end
function [newX,newTri]=subdivide_tets_with_3_one_iter( X,tet )
%given a 3 X4 array of 4 3d vertices that make up a tet, divide it
%via a centroid to 4 tets, return the centroid and the 4 tets, with indexes
%going 1-5, where 1-4 are the indexes to X and 5 represents the new vertx
%get indexes where constrained
b_faces=boundary_faces(tet);
inds=unique(b_faces);
b=zeros(length(X),1);
b(inds)=1;
c=sum(b(tet),2)>=3;
to_subdivide=find(c);
%the tris we'll keep in th end. we will definitly remove the ones that we
%subdivide, so mark them as not keep
remove=zeros(size(c));

% newTriLength=length(keep)+length(to_subdivide)*6; %
newTri=tet;
newX=X;
for iii=1:length(to_subdivide)
    tet_ind=to_subdivide(iii);
    if remove(tet_ind)
        continue;
    end
    inds=tet(tet_ind,:);
    %find the boundary indices
    boundary_inds=inds(b(inds)~=0);
    %if there are 4 boundary inds (it is compeletely on boundary)
    if length(boundary_inds)==4 %TODO CORRECT THIS!!!
        %find all boundary faces indexes of this tet
        b_faces_in_tet=find(all(ismember(b_faces,boundary_inds),2));
        tet_b_faces=b_faces(b_faces_in_tet,:);
        %select the 3 inds that occur the least in the bdry faces of the
        %tet
        inds_occurence=countmember(boundary_inds,tet_b_faces);
        [~,order]=sort(inds_occurence);
        boundary_inds=boundary_inds(order(1:3));
       assert(max(sum(ismember(tet_b_faces,boundary_inds),2))<3);
%         boundary_inds=boundary_inds(inds_occurence==2);
       
        
    end
    %find the tet that shares the 3 boundary vertices with this face
    nbr=find(sum(ismember(tet,boundary_inds),2)==size(tet,2)-1);
    nbr=setdiff(nbr,tet_ind);
    %if there is no such, either nbr divide or current has face on bdry
    if isempty(nbr) || remove(nbr)
        continue;
    end
    %now we can mark it to remove
    remove(tet_ind)=1;
    %we split the nbr, can drop the tri
    remove(nbr)=1;
    
    %find the common face
    [~,f_nbr,f_tri] = intersect(tet(nbr,:),inds) ;
    %revert them to descending order since intersect gives them in another
    %order
    f_nbr=tet(nbr,sort(f_nbr));
    f_tri=tet(tet_ind,sort(f_tri));
    %find centroid of th face
    x=mean(X(f_nbr,:));
    %add the new vertex
    newX=[newX;x];
    %get its index
    ind=length(newX);
    %subdivide nbr
    new_nbr_inds=subdivide_tri(newX,tet(nbr,:),f_nbr,ind);
    
    %subdivide tri
    new_tri_inds=subdivide_tri(newX,tet(tet_ind,:),f_tri,ind);
    %add to tri list
    newTri=[newTri;new_nbr_inds;new_tri_inds];
    %set all of them to 0 so not removed.
    remove(length(newTri))=0;
    
end
newTri=newTri(remove==0,:);

end
function inds=subdivide_tri(X,tetinds,faceinds,newInd)
topInd=setdiff(tetinds,faceinds);
assert(length(topInd)==1);
inds=[];
for i=1:length(faceinds)
    i2=i+1;
    if i2>length(faceinds)
        i2=i2-length(faceinds);
    end
    curInds=[topInd faceinds(i) ,faceinds(i2) ,newInd];
    
    if det([X(curInds,:) ones(length(curInds),1)])<0
        curInds=curInds([1 3 2 4]);
    end
    inds=[inds;curInds];
end
end