function [newX,newTri]=subdivide_tets( X,tri,c )
%given a 3 X4 array of 4 3d vertices that make up a tet, divide it 
%via a centroid to 4 tets, return the centroid and the 4 tets, with indexes
%going 1-5, where 1-4 are the indexes to X and 5 represents the new vertx
%get indexes where constrained
to_subdivide=find(c);
%the tris we'll keep in th end. we will definitly remove the ones that we
%subdivide, so mark them as not keep
remove=c~=0;

% newTriLength=length(keep)+length(to_subdivide)*6; %
newTri=tri;
newX=X;
alreadySubdivided=zeros(size(c));
for iii=1:length(to_subdivide)
    tri_ind=to_subdivide(iii);
    if alreadySubdivided(tri_ind)
        continue
    end
    inds=tri(tri_ind,:);
    %find tris that share 3 vertices with this tri (i.e face)
    nbrs=find(sum(ismember(tri,inds),2)==size(tri,2)-1);
    %try to find a neighbour tet that is not fully constrained
    inside=find(c(nbrs)==0&alreadySubdivided(nbrs)==0);
    %if failed, should take an arbitrary tet
    if isempty(inside)
        inside=find(alreadySubdivided(nbrs)==0);%select the 1st neighbour that isnt subdivided already
    end
    if length(inside)>1
        inside=inside(1);
    end
    if isempty(inside)
        remove(tri_ind)=0;
        continue
    end
    assert(~isempty(inside));
    %selected the nbr ind out of all nbr inds
    nbr=nbrs(inside);
    %we split the nbr, can drop the tri
    remove(nbr)=1;
    %and we subdivided this one
    alreadySubdivided(nbr)=1;
    alreadySubdivided(tri_ind)=1;
    %find the common face
    [~,f_nbr,f_tri] = intersect(tri(nbr,:),inds) ;
    %revert them to descending order since intersect gives them in another
    %order
    f_nbr=tri(nbr,sort(f_nbr));
    f_tri=tri(tri_ind,sort(f_tri));
    %find centroid of th face
    x=mean(X(f_nbr,:));
    %add the new vertex
    newX=[newX;x];
    %get its index
    ind=length(newX);
    %subdivide nbr
    new_nbr_inds=subdivide_tri(newX,tri(nbr,:),f_nbr,ind);
    
    %subdivide tri
    new_tri_inds=subdivide_tri(newX,tri(tri_ind,:),f_tri,ind);
    %add to tri list
    newTri=[newTri;new_nbr_inds;new_tri_inds];
    %set all of them to 0 so not removed.
    remove(length(newTri))=0;
    
end
newTri=newTri(remove==0,:);
%assert(nnz(find_primitives_with_no_DOF(newTri,anchors))==0);
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