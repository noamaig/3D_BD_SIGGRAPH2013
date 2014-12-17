% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function [A,b] = create_ineq_matrix(faces,OPTIONS)
%create the inequality matrix according to the type of constraints needed



%how many elements on diagonal
diagonal_length=OPTIONS.PROBLEM.SD;
%how many diagonal pairs that need comparing are there in each face
DIAG_PAIRS=factorial(diagonal_length);%all pairs
if OPTIONS.ALG.ONLY_ONE_INEQ%if flag on, only one diagonal pair per face
    DIAG_PAIRS=1;
end
%source dimension
SD=OPTIONS.PROBLEM.SD;
%should use isometry?
ISOMETRY=OPTIONS.ISOMETRY;
%are we imposing BD inequalities on diagonal?
CONSTRAIN_SEARCH_SPACE=1;

if ISOMETRY
    %one equation for a_11, one for a_dd
    EQUATIONS_PER_FACE=2;
    INDEXES_PER_FACE=2*OPTIONS.PROBLEM.INDS_TO_DEFINE_TRANSFORMATION_ELEMENT;
elseif CONSTRAIN_SEARCH_SPACE
    
    EQUATIONS_PER_FACE=DIAG_PAIRS;
    % for each ordered pair, two sets of indexes to define an inequality
    INDEXES_PER_FACE=(DIAG_PAIRS*2)*OPTIONS.PROBLEM.INDS_TO_DEFINE_TRANSFORMATION_ELEMENT;
    
    
    
    
else
    EQUATIONS_PER_FACE=0;
    INDEXES_PER_FACE=0;
end


%We fill 3 arrays of X,Y,V to later create a sparse matrix from. How many
%entries will there be in each of those arrays
INDEXES_LENGTH=INDEXES_PER_FACE*length(faces);
%create the 3 aformentioned arrays, set them to infs for assertion purposes
X=zeros(INDEXES_LENGTH,1)-inf;
Y=zeros(INDEXES_LENGTH,1)-inf;
V=zeros(INDEXES_LENGTH,1)-inf;
%the rhs
b=zeros(EQUATIONS_PER_FACE*length(faces),1);
%how many indices are needed to define a transformation element
INDS_TO_DEFINE_TRANSFORMATION_ELEMENT=OPTIONS.PROBLEM.INDS_TO_DEFINE_TRANSFORMATION_ELEMENT;
%flags (instead of reading from OPTIONS which apparently takes more time)
ONLY_ONE_INEQ=OPTIONS.ALG.ONLY_ONE_INEQ;
%now starts the tricy part of defining the elements as linaer combinatios
%of the solution vector
%for each tet\tri, the solution vector will have d X m elements where
%d is the dimension of the vertices and m is # of the vertices in
%primitive, i.e 4 per tet and 3 per tri. get all combinations
[dims,vnums]=meshgrid(1:OPTIONS.PROBLEM.TD,1:OPTIONS.PROBLEM.NODES_IN_PRIMITIVE);
dims=dims(:)';
vnums=vnums(:)';
%these two below are used to compute the linear comb of vertex coords for
%differential element. Created in advance as they are refilled in each
%iteration
%this will hold indices into solution vector
inds=zeros(diagonal_length,INDS_TO_DEFINE_TRANSFORMATION_ELEMENT);
%this will hold coefficients of sol vector
coef=zeros(diagonal_length,INDS_TO_DEFINE_TRANSFORMATION_ELEMENT);
%warning message so I forget :)
if ISOMETRY
    disp('!!!!!!!!!!! REMEMBER ISOMETRY TURNED ON!!!');
end
K=OPTIONS.K;
%now starting to build matrix
%iterate over all faces
for face_ind=1:length(faces)
    face=faces{face_ind};
    %comput current position into the arrays X,Y,V
    cur_pos=(face_ind-1)*INDEXES_PER_FACE+1;
    %compute the current y in the matrix i.e at which equation are we
    cur_y=(face_ind-1)*EQUATIONS_PER_FACE+1;
    %if we do isometry
    if ISOMETRY
        %first fill up the elements inorder to define a diagonal element
        for i=1:diagonal_length
            %these are the indices in the solution vec: remember dims and
            %vnums were created by meshgrid; we create all posible
            %combinations of any of the vertices of the primitive with any
            %of the d dimensions. So we first compute the appropriate
            %indices for each such pair:
            inds1=(face.inds(vnums)-1)*OPTIONS.PROBLEM.TD+dims;
            %and then the right linear coeffcients
            coef1=(face.tframe(dims,i).*face.left_coef_mat(vnums,i))';
            %and we fill up the indices+coefficients of that entry
            %TODO noam this is not needed in case we only use a_11 a_33
            inds(i,:)=inds1;
            coef(i,:)=coef1;
        end
        %now we have defined in inds\coef the linear comb of diagonal
        %elements we can finally create equations:
        
        %first equation - A_11<K
        %get the position in the X,Y,V vecs of the last element we will
        %insert
        new_pos=cur_pos+INDS_TO_DEFINE_TRANSFORMATION_ELEMENT-1;
        %get indices\coef of A_11
        X(cur_pos:new_pos)=inds(1,:);
        V(cur_pos:new_pos)=coef(1,:);
        Y(cur_pos:new_pos)=cur_y;
        %set rhs
        b(cur_y)=K;
        %advance the place we
        cur_pos=new_pos+1;
        cur_y=cur_y+1;
        
        %now same procedure for the lower bound:
        %A_33>1/K ---> -A_33<-1/K
        
        new_pos=cur_pos+INDS_TO_DEFINE_TRANSFORMATION_ELEMENT-1;
        X(cur_pos:new_pos)=inds(SD,:);
        Y(cur_pos:new_pos)=cur_y;
        V(cur_pos:new_pos)=-coef(SD,:);
        b(cur_y)=-1/K;
       
    elseif CONSTRAIN_SEARCH_SPACE%bounded aspect ratio distortion
        %same code as the ISOMETRY case - look there for documentation
        for i=1:diagonal_length
            inds1=(face.inds(vnums)-1)*OPTIONS.PROBLEM.TD+dims;
            coef1=(face.tframe(dims,i).*face.left_coef_mat(vnums,i))';
            inds(i,:)=inds1;
            coef(i,:)=coef1;
        end
        
        
        for i=1:diagonal_length
            
            if ONLY_ONE_INEQ && i~=1
                continue
            end
            for j=1:(diagonal_length-1)
                
                k=i+j;
                if k>diagonal_length
                    k=k-diagonal_length;
                end
                %                 not needed because k=j+i
                %                 if i==k
                %                     continue;
                %                 end
                if ONLY_ONE_INEQ && k~=OPTIONS.PROBLEM.SD%||(i==3 && k==1))
                    continue
                end
                new_pos=cur_pos+INDS_TO_DEFINE_TRANSFORMATION_ELEMENT-1;
                X(cur_pos:new_pos)=inds(i,:);
                Y(cur_pos:new_pos)=cur_y;
                V(cur_pos:new_pos)=coef(i,:);
                cur_pos=new_pos+1;
                %A(cur_y,inds(i,:))=coef(i,:);
                
                %A(cur_y,inds(k,:))=A(cur_y,inds(k,:))-K*coef(k,:);
                new_pos=cur_pos+INDS_TO_DEFINE_TRANSFORMATION_ELEMENT-1;
                X(cur_pos:new_pos)=inds(k,:);
                Y(cur_pos:new_pos)=cur_y;
                V(cur_pos:new_pos)=-K*coef(k,:);
                cur_pos=new_pos+1;
                
                b(cur_y)=0;
                cur_y=cur_y+1;
            end
            
        end
    end
end


assert(length(X)==INDEXES_LENGTH);
A=sparse(Y,X,V);
end

