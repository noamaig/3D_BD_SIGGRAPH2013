% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

classdef ClosestBDSolver<handle
    %class to project 3X3 diagonal matrix on BD space
    
    properties
        edge_vectors;
        plane_vertices;
        face_normals;
        face_boundary_normals;
        base1;
        base2;
        ax;
        K;
        angs;
    end
    
    methods
        function obj=ClosestBDSolver(K)
            %K - the distoriton bound
            obj.K=K;
            %main axis of cone
            obj.ax=[1 1 1];
            obj.ax=obj.ax/norm(obj.ax);
            %edges of cone
            e=[K K 1;
                K 1 1;
                K 1 K;
                1 1 K;
                1 K K;
                1 K 1;
                ];
            %normals of faces of cone
            f=[1 0 -K;
                1 -K 0;
                0 -K 1;
                -K 0 1;
                -K 1 0;
                0 1 -K;
                ];
            %normalize edges and faces
            for i=1:6
                e(i,:)=e(i,:)/norm(e(i,:));
                f(i,:)=f(i,:)/norm(f(i,:));
            end
            obj.edge_vectors=e;
            obj.face_normals=f;% face i is between edge i and i+1
            obj.face_boundary_normals={};
            %for each edge, the two normals of the planes cutting the edge, 
            %needed to compute the closest point in case it is on edge
            for i=1:6
                n1=cross(f(i,:),e(i,:));
                j=i+1;
                if j>6
                    j=1;
                end
                n2=cross(f(i,:),e(j,:));
                obj.face_boundary_normals{i}=[n1; n2];
            end
            %now we compute in e 6 points that are the projection of the edges
            %on the plane which is perpendicular to (1,1,1) and passes from
            %the origin
            
            for i=1:6
                e(i,:)=e(i,:)/(e(i,:)*obj.ax'); % set to same plane
                e(i,:)=e(i,:)-obj.ax*(e(i,:)*obj.ax'); %shift to zero
                e(i,:)=e(i,:)/norm(e(i,:));
            end
            obj.plane_vertices=e;
            %compute two vectors to span the plane
            obj.base1=e(1,:); %used as the base to calculate angle on the plane
            obj.base2=cross(e(1,:),obj.ax); %find perpendicular to first base on the plane
            %compute angles between the edges, so we can decide to which
            %face\edge of the cone does the given d belongs
            y=obj.plane_vertices*obj.base2';
            x=obj.plane_vertices*obj.base1';
            obj.angs=atan2(y,x);
            obj.angs=obj.angs+2*pi;
            obj.angs=mod(obj.angs,2*pi);
            
            
        end
        function newd=findClosestDiag(obj,d)
            %if d is already BD
            if all(obj.face_normals*d'<0)
                newd=d;
                return;
            end
            orgD=d;
            %shift d to plane (x,y,z)*(1,1,1)=0
            d=d-obj.ax*(d*obj.ax');
            %compute angle of the point on the plane
            ang=atan2(d*obj.base2',d*obj.base1');
            %make sure positive
            ang=ang+2*pi;
            ang=mod(ang,2*pi);
            %take difference between edge angles to cur angle
            a=obj.angs-ang;
            %find the angle after which the difference flips sign
            i1=find(a<=0,1,'last');
            %then we want the angle after it
            i2=i1+1;
            %because we are mod(6)
            if i2==7
                i2=1;
            end
            %choose closest face
            theF=obj.face_normals(i1,:);
            %project diagonal onto face's plane
            newd=orgD-theF*(theF*orgD');
            %now the trickiest part - need to see if lands on face or
            %outside face
            e1=obj.edge_vectors(i1,:);
            e2=obj.edge_vectors(i2,:);
            n1=obj.face_boundary_normals{i1}(1,:);
            n2=obj.face_boundary_normals{i1}(2,:);
            %if left to the first edge project on edge
            if orgD*n1'<0
                newd=e1*(e1*orgD');
            %if right to the second edge project on edge
            elseif orgD*n2'>0
                newd=e2*(e2*orgD');
            end
            %else inside face - keep original projection
        end
    end
    
end

