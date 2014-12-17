function [ three_tets ] = divide_tet_by_face(tet,face )
%given a tet and a face, create 3 tets by dividing the tet by adding a
%vertex in the center of the face. the output containts -1 where the new
%vertex is present.

%face is 3 inds of face we divide, otherind is the ind that is not in the face we divide
otherind=setdiff(tet,face);
%find the position in tet of the vertex that is not in the face
indplace=find(tet==otherind);
%make sure the face has correct ordering 
face=tet([indplace+1:4 1:indplace-1]);
%divide by each time selecting one of the 3 faces that do not change after
%division, and add the new vertex as 4th vertex to create 3 tets
curface=[ face([1 2])  otherind];
t1=tet;
t1(~ismember(t1,curface))=-1;
curface=[ face([2 3])  otherind];
t2=tet;
t2(~ismember(t2,curface))=-1;
curface=[ face([3 1])  otherind];
t3=tet;
t3(~ismember(t3,curface))=-1;
three_tets=[  t1;t2;t3];
end

