function c = find_primitives_with_no_DOF( tris,anchors )
constrained=ismember(tris,anchors);
constrained=sum(constrained,2);
c=constrained==size(tris,2);


end

