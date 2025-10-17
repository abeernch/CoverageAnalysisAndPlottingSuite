% x0=0;
% y0=0;
% x1=2;
% y1=2.5;
% zero_marks=0.*(0:0.2:10);
% x_axis_line=0:0.2:10;
% y_axis_line=0:0.2:10;
% %draw lines x=0 and y=0
% plot(zero_marks,y_axis_line,'--k',x_axis_line,zero_marks,'--k')
% hold on
% plot(x0,y0,'o',x1,y1,'+')
% %plot initial vector
% plot([x0 x1],[y0,y1],'-r')
% 
% % angle of rotation
% theta=10; % 10 deg rotation
% % for theta=5:10:360
%     % rotation matrix
%     r=[cosd(theta) -sind(theta);
%         sind(theta) cosd(theta)];
% 
%     new_pts=r*[x1;y1];
%     x_=new_pts(1)
%     y_=new_pts(2)
%     plot(x_,y_,'*')
%     %plot new vector
%     plot([x0 x_],[y0,y_],'-r')
% % end
% axis equal
% atan2d(y_,x_)-atan2d(y1,x1)

x=10;
y=[1,1]
% y=1;
ind=1
rotx=y;
roty=y;
for i=-1:0.5:10
    x(end+1)=i;
    y(end+1,:)=[i,-i];
    % y(end+1)=i;
    [tempx,tempy]=rotate_xy(i,i,30);
    rotx(end+1,1)=tempx;
    roty(end+1,1)=tempy;
    [tempx,tempy]=rotate_xy(i,-i,30);
    rotx(end,2)=tempx;
    roty(end,2)=tempy;
end
x(1)=[];
y(1,:)=[];
rotx(1,:)=[];
roty(1,:)=[];
plot(x,y,'red')
hold on
plot(x,zeros(1,length(x)),'--k')
sqrt((y(end)-y(1))^2+(x(end)-x(1))^2)
sqrt((roty(end)-roty(1))^2+(rotx(end)-rotx(1))^2)