% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function GUI_cross_section(OPTIONS,SV,TV,T,distortion,hadflip,anchors_coords,static_anchors)
%Display the cross-section GUI for the mesh. 
surface_tri=boundary_faces(T,hadflip);

realTV=TV;
bDown=0;
mouseX=0;
normal=[1 0 0]';
offset=[0 0 0]';

% centroids=[];
% for ii=1:3
%     coords=SV(:,ii);
%     centroids=[centroids mean(coords(T),2)];
% end
close all
figH=figure('Toolbar','none');
cam=cameratoolbar();
bs=findall(cam,'Type','uitoggletool');
set(bs,'oncallback',@(h,e)unset_all());
htt = uitoggletool('oncallback',@(h,e)enable_plane(),'offcallback',@(h,e)unset_plane(),'cdata',loadIcon('icons/plane.gif'),'TooltipString','control clipping plane');
xButton=uipushtool('ClickedCallback',@(h,e) setNormal([1 0 0]'),'cdata',loadIcon('icons/x-axis.png'),'TooltipString','snap to x');
yButton=uipushtool('ClickedCallback',@(h,e) setNormal([0 1 0]'),'cdata',loadIcon('icons/y-axis.png'),'TooltipString','snap to y');
zButton=uipushtool('ClickedCallback',@(h,e) setNormal([0 0 1]'),'cdata',loadIcon('icons/z-axis.png'),'TooltipString','snap to z');
flipButton=uipushtool('ClickedCallback',@(h,e) flipNormal(),'cdata',loadIcon('icons/flip.png'),'TooltipString','flip normal');
source_or_target= uitoggletool('ClickedCallback',@(h,e) drawPlane(0),'cdata',loadIcon('icons/1.gif'),'TooltipString','cut according to source\target mesh','state','on');
plane_buttons=[xButton yButton zButton flipButton source_or_target];
initial_or_final= uitoggletool('ClickedCallback',@(h,e) drawPlane(0),'cdata',loadIcon('icons/mesh.png'),'TooltipString','show initial mapping or final','state','on');

showbad_button = uitoggletool('ClickedCallback',@(h,e) drawPlane(0),'cdata',loadIcon('icons/triangle_down.gif'),'TooltipString','show only bad');
switch_button = uipushtool('ClickedCallback',@(h,e) switchSourceTarget(),'cdata',loadIcon('icons/switch.png'),'TooltipString','switch between the source\target');


enable_plane();
axis equal;
camtarget('manual');
campos('manual');

camup('manual');
set(gca,'nextplot','replacechildren');
P=[];
draw_mesh(TV,T,distortion,hadflip,[],[],OPTIONS);
set_color_map();
axis equal;
ax=axis;
START_ARC_POINT=[0 0 0 ];
START_POINT=[0 0 0];
    function unset_all()
        unset_plane();
    end
    
    function unset_plane()
        set(htt,'state','off');
        set(plane_buttons,'Enable','off');
        set(gcf,'WindowButtonDownFcn','');
        set(gcf,'WindowButtonUpFcn','');
        set(gcf,'WindowButtonMotionFcn','');
    end
    function switchSourceTarget()
        temp=SV;
        SV=TV;
        TV=temp;
        drawPlane(0);
    end
    function enable_plane()
        set(htt,'state','on');
        cameratoolbar('setmode','nomode')
        set(gcf,'WindowButtonDownFcn',@mdown);
        set(gcf,'WindowButtonUpFcn',@mup);
        set(gcf,'WindowButtonMotionFcn',@mouseMove);
        set(plane_buttons,'Enable','on');
        drawPlane(0);

    end

    function setNormal(newN)
        normal=newN;
        drawPlane(0);
    end
    function flipNormal()
        setNormal(-normal);
    end
    function mdown(h,event)
        HGEOM = get( h, 'Position');
        pos=get(h,'CurrentPoint');
        % transform in sphere coordinates (3,4) = (WIDTH, HEIGHT)
        START_ARC_POINT= point_on_sphere( pos, HGEOM(3), HGEOM(4) );
        START_POINT=point_on_plane(pos);
        if strcmp(get(figH,'SelectionType'),'normal')
            bDown=1;
        else
            bDown=2;
        end
        
        
    end
    function mup(h,~)
        
        bDown=0;
        
        delete(P);
        P=[];
        
    end
    function mouseMove(h,event)
        if bDown==0
            return
            
        elseif bDown==1
            
            %         if ~bDown
            %             return
            %         end
            %         pos=get(h,'CurrentPoint');
            %         offset=lastOffset+(pos(1)-mouseX)/100;
            %         drawPlane();
            % retrieve the current point
            point = get(gcf,'CurrentPoint');
            % retrieve window geometry
            HGEOM = get( h, 'Position');
            % transform in sphere coordinates (3,4) = (WIDTH, HEIGHT)
            point= point_on_sphere( point, HGEOM(3), HGEOM(4) );
            
            % workaround condition (see point_on_sphere)
            if isnan(point)
                return;
            end
            
            %%%%% ARCBALL COMPUTATION %%%%%
            
            % compute angle and rotation axis
            rot_dir = cross( START_ARC_POINT, point );
            rot_dir = rot_dir / norm( rot_dir );
            rot_ang = acos( dot( point, START_ARC_POINT ) );
            
            % convert direction in model coordinate system
            
            
            
            rot_dir = rot_dir / norm( rot_dir ); % renormalize
            % construct matrix
            R_matrix = makehgtform('axisrotate',rot_dir,rot_ang);
            R_matrix=R_matrix(1:3,1:3);
            normal=R_matrix*normal;
            START_ARC_POINT=point;
            
        elseif bDown==2
            point = get(gcf,'CurrentPoint');
            P=point_on_plane(point);
            radius=max(max(SV)-min(SV));
            offset=offset+(P-START_POINT)*radius/30;
            offset=(offset'*normal)*normal;
            START_POINT=P;
            fprintf('center plane: %d %d %d\n',offset);
        end
        drawPlane(0);
    end
    function P = point_on_sphere( P, width, height )
        P(3) = 0;
        
        % determine radius of the sphere
        R = min(width, height)/2;
        
        % TRANSFORM the point in window coordinate into
        % the coordinate of a sphere centered in middle window
        ORIGIN = [width/2, height/2, 0];
        P = P - ORIGIN;
        
        % normalize position to [-1:1] WRT unit sphere
        % centered at the origin of the window
        P = P / R;
        
        % if position is out of sphere, normalize it to
        % unit length
        L = sqrt( P*P' );
        if L > 1
            % P = nan; % workaround to stop evaluation
            % disp('out of sphere');
            
            P = P / L;
            P(3) = 0;
        else
            % add the Z coordinate to the scheme
            P(3) = sqrt( 1 - P(1)^2 - P(2)^2 );
        end
    end
    function P= point_on_plane(P)
        tar=get(gca,'CameraTarget');
        pos=get(gca,'CameraPosition');
        up=get(gca,'CameraUpVector');
        n1=tar-pos;
        n1=n1/norm(n1);
        
        n2=up/norm(up);
        n3=cross(n1,n2);
        n3=n3/norm(n3);
        A=[n3' n2'];
        P=A*P';
    end
    function drawPlane(drawpoints)
        
        showBad= strcmp(get(showbad_button, 'state'),'on');
        figure(figH);
        ax=axis();
        tar=get(gca,'CameraTarget');
        pos=get(gca,'CameraPosition');
        up=get(gca,'CameraUpVector');
        viewang=get(gca,'CameraViewAngle');
        
        n1=tar-pos;
        n1=n1/norm(n1);
        
        n2=up/norm(up);
        n3=cross(n2,n1);
        n3=n3/norm(n3);
        n=n1;-(n3+n2-n1)/3;
        %normal=n/norm(n);
        
        %cla;
        
        %quiver3(tar(1),tar(2),tar(3),n(1),n(2),n(3));
        cla;
        %delete(P);
        if ~isempty(anchors_coords)
        coords=anchors_coords;
        for i=1:3
            coords(:,i)=coords(:,i)-offset(i);
        end
        useAnchors=coords*normal;
        useAnchors=useAnchors>0;
        else
            useAnchors=[];
        end
        if strcmp(get(initial_or_final, 'state'),'on')
            colors=distortion;
            flips=hadflip;
            v=TV;
        else
            colors=OPTIONS.INITIAL_DISTORTION;
            flips=OPTIONS.INITIAL_FLIPS;
            v=OPTIONS.PROBLEM.INITIAL_TARGET_POS;
        end
        %         if get(color_chkbx,'Value')
        %             colors=centroids(:,1);
        %         end
        %ax1=subplot(1,2,1,'replace');
        cax=caxis;
        if ~drawpoints
            if showBad
                inds=colors>OPTIONS.K | flips~=0;
                draw_mesh(v,T(inds,:),colors(inds),flips(inds),[],[],OPTIONS);
                hold on
                trimesh(surface_tri,v(:,1),v(:,2),v(:,3),'FaceColor','none','EdgeAlpha',0.2,'EdgeColor','black');
                hold off
            else
                inds=tetsInCrossSection();
                draw_mesh(v,T(inds,:),colors(inds),flips(inds),anchors_coords(useAnchors,:),static_anchors(useAnchors),OPTIONS);
            end
            %ax2=subplot(1,2,2,'replace');
            %draw_mesh(SV,T(inds,:),colors(inds),hadflip(inds),anchors_coords(useAnchors,:),static_anchors(useAnchors));
            %          hlink = linkprop([ax1 ax2],{'CameraPosition','CameraUpVector'});
            %    key = 'graphics_linkprop';
            %    % Store link object on first subplot axes
            %    setappdata(ax1,key,hlink);
            
            set_color_map();
        else
            scatter3(TV(:,1),TV(:,2),TV(:,3),10,'green','filled');
        end
        caxis(cax);
        %set_color_map();
        
        %camlight;
        %set(figH,'BackFaceLighting','lit')
        if ~drawpoints
            P=draw_clipping_plane(normal,offset,TV);
        end
        set(gca,'CameraTarget',tar);
        set(gca,'CameraPosition',pos);
        set(gca,'CameraViewAngle',viewang);
        set(gca,'CameraUpVector',up);
        
        axis equal;%(ax);
        %axis equal;
    end
    
    function inds=tetsInCrossSection()
        if strcmp(get(source_or_target, 'state'),'on')
            inds= cross_section_volume(SV,T,offset,normal)';
        else
            inds= cross_section_volume(TV,T,offset,normal)';
        end
    end
    function cdata=loadIcon(fname)
        [cdata,map] = imread(fname);
        if ~isempty(map)
            
            
            % Convert white pixels into a transparent background
            map(find(map(:,1)+map(:,2)+map(:,3)==3)) = NaN;
            
            % Convert into 3D RGB-space
            cdata = ind2rgb(cdata,map);
        else
            cdata(:,:,:);
        end
        
    end
   
   
end
