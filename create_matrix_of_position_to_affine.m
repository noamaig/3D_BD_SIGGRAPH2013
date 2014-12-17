% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function A = create_matrix_of_position_to_affine(OPTIONS,faces,adddelta)
% returns a matrix that transforms the solution vector of positional
% variables into the the entries of the affine map (the offset delta
% excluded or not, depending on "adddelta")

%(A delta)*(S;1)=T 2X3
%(S;1)'(A'; delta)=T' 3X2
%(A'; delta)=inv((S;1)')*T'
%T'=(x1 y1;x2 y2;x3 y3)

%A=S*T

%A_ji = S_{i*} * T_{*j}
%A_ij = S_{j*} * T_{*i}

%arrays to create the sparse matrix from
X=[];
Y=[];
V=[];
%width of each differnetial we return
mwidth=OPTIONS.PROBLEM.SD;
if adddelta %if we return the delta also
    mwidth=mwidth+1;
end
for face_ind=1:length(faces)
    face=faces{face_ind};
    %the linear trans of differential to coordinates: M*A=V
    M=[face.gscoords;ones(1,size(face.gscoords,2))]';
    %need the inverse mapping A=V/M where V is solution vector
    M=inv(M);
    %iterate on each dimensions, and on each column of the matrix
    for i=1:OPTIONS.PROBLEM.TD
        for j=1:mwidth
            %indices in the solution vector relevant to this differnetial
            %for 1 coordinate (i.e out of 3d) (all these are responsible
            %for row i of the diff, namely A(i,j))
            xinds=get_index_in_solution_vector(face.inds,i,OPTIONS.PROBLEM.TD);
            %this iteration is responsible for A(i,j), so get its index and
            %that will be the row index in teh resulting matrix
            yinds=index_of_A_elements_in_affine_vec(face_ind,i,j,adddelta,OPTIONS)*ones(size(xinds)); 
            vals=M(j,:);
            X=[X xinds];
            Y=[Y yinds];
            V=[V vals];
            
        end
    end
end
A=sparse(Y,X,V);
end


