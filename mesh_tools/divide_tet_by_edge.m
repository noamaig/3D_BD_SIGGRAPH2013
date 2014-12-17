function [ two_tets ] = divide_tet_by_edge( tet,edge )
%given a tet and an edge, divide the tet into two by inserting vertex in
%the middle of the edge. Keeps orienation of tets. Return: 2X4 array of
%indices, -1 where new vertex was inserted
%some sanity checks
assert(all(ismember(edge,tet)));
assert(length(edge)==2);
%find the 2 inds of the tet not on the edge
other_two_inds=setdiff(tet,edge);
%create the two tets, putting -1 where the new vertex will be
two_faces=[other_two_inds edge(1);
          other_two_inds edge(2);
    ];
two_tets=zeros(2,4);
for i=1:2
    two_tets(i,:)=tet;
    two_tets(i,~ismember(tet,two_faces(i,:)))=-1;
end
for i=1:2
    assert(length(unique(two_tets(i,:)))==4);
end

end

