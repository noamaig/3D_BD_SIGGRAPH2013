function [T,X] = divide_tet_with_short_face( T,X )
%remove all tets with short faces, i.e tets with faces that are not
%boundary faces but their 3 vertices are boundary vertices
for iter=1:100000000
    %set list to mark which tets we remove
    
    remove=zeros(length(T),1);
    
    %set list of boundary faces
    bfaces=sort(boundary_faces(T),2);
    %boundary indices
    binds=unique(bfaces);
    %list of all faces
    faces=[T(:,[1 2 3]);
        T(:,[1 2 4]);
        T(:,[1 3 4]);
        T(:,[2 3 4]);];
    faces=sort(faces,2);
    faces=unique(faces,'rows');
    inner_faces=setdiff(faces,bfaces,'rows');
    
    
    %find short faces
    f_inds=find(sum(ismember(inner_faces,binds),2)==3);
    if mod(iter,10)==1
        fprintf('divide tet to 3: found %d short faces\n',length(f_inds));
    end
    if isempty(f_inds)
        return
    end
    %select a face from list
    face=inner_faces(f_inds(1),:);
    %find all tets that have this face
    tet_ind=find(sum(ismember(T,face),2)==3);
    %mark these tets for removal
    remove(tet_ind)=1;
    %get the actual two tets
    tets=T(tet_ind,:);
    %generate new location
    newX=mean(X(face,:));
    X=[X;newX];
    newInd=length(X);
    for i=1:size(tets,1);
        tet=tets(i,:);
        
        three_tet=divide_tet_by_face(tet,face);
        three_tet(three_tet==-1)=newInd;
        T=[T;three_tet];
    end
    remove(length(T))=0;
    T=T(remove==0,:);
end
end


% function lonely=lonely_vertices(T)
% inds=unique(T);
%
% lonely=find(countmember(inds,T)==1);
% if isempty(lonely)
%     lonely=find(countmember(inds,T)==2);
%
% end

function F=allfaces(T)
assert(size(T,1)==1);
F=T([1 2 3;
    1 2 4;
    1 3 4;
    2 3 4]);
F=sort(F,2);
end


