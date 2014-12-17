% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

function P=draw_clipping_plane( n,x,V )
%draw a  rectangle with normal n with center at point x and that with area
%that is proportional to the point clode V
if size(x,1)>1
    x=x';
end
maxDiff=0;
for i=1:3
    maxDiff=max(maxDiff,max(V(:,i))-min(V(:,i)));
end
n=n/norm(n);
n1=get(gca,'CameraTarget')-get(gca,'CameraPosition');
n1=n1'/norm(n1);
if norm(n1-n)<1e-4
    n1=[0 1 0];
end
X=zeros(4,3);
X(1,:)=cross(n1,n);
X(1,:)=X(1,:)/norm(X(1,:));
X(2,:)=cross(X(1,:),n);
X(2,:)=X(2,:)/norm(X(2,:));
X(3:4,:)=-X(1:2,:);
X=X*maxDiff;

for i=1:4
    X(i,:)=X(i,:)+x;
end
P=patch(X(:,1),X(:,2),X(:,3),'black','FaceAlpha',0.05);
end
