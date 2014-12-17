function edges = compute_edges_for_tets( T )
%compute all edges of a tet-mesh. Not very effectively.
edges=[];
for i=1:4
    for j=(i+1):4
        edges=[edges;T(:,i) T(:,j)];
    end
end
edges=sort(edges,2);
edges=unique(edges,'rows');
end

