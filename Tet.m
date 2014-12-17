% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

classdef Tet<handle
    %Class for the basic primitive (tri\tet)
    
    properties
        
        inds;
        sframe;
        tframe;
        scoords;
        tcoords;
        gscoords;
        gtcoords;
        A;
        target_matrix=[];
        delta;
        sv;
        left_coef_mat=[];
        global_left_coef_mat=[];
        initial_A=[];
        last_global_A=[];
        B=[];
        volume=-inf;
        closest_BD;
        normal=[];
        normal_vote=[];
centroid;
    end
    
    methods
        function obj = Tet(coords,SD,TD,inds,tframe,sframe,sv)
            
            obj.A=diag(sv);
            
            if TD~=SD
                obj.A=[obj.A;0 0];
            end
            obj.target_matrix=obj.A;
            obj.last_global_A=tframe*obj.A*sframe';
            obj.scoords=zeros(SD,size(inds,2));
            obj.tcoords=zeros(TD,size(inds,2));
            
            obj.tframe=tframe;
            obj.sframe=sframe;
            obj.initial_A=tframe*obj.A*sframe';
            obj.delta=zeros(TD,1);
            obj.sv=sv;
            

                obj.gscoords=coords;
                

            
            obj.volume=primitive_volume(obj.gscoords,SD);
            obj.gtcoords=zeros(TD,length(inds));
            
            
            obj.inds=inds;
            
            
            
            
            assert(min(size(obj.gscoords))==SD);
            A=[obj.gscoords;ones(1,size(obj.gscoords,2))];
            A=inv(A);
            A=A(:,1:end-1);
            obj.global_left_coef_mat=A;
            set_left_coef_matrix(obj);
            
        end
    end
    
end

