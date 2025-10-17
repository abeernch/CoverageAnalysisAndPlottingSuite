function get_fresnal_plot(plot_handle,fresnal_count,tx,rx)
dist=distance(tx,rx,'euclidean');%abs(rx-tx); % distance goes from tx-->rx
f=1e9; % 1ghz
lamda=3e8/f;
cla(plot_handle,'reset');
hold(plot_handle,"on");
% fig=figure;
% cross check following on https://www.omnicalculator.com/physics/fresnel-zone
for n=1:fresnal_count
    x_pts=0;
    y_pts=[1 1];
    step_size=0.5;
    for step=0:step_size:dist-step_size
        d1=step;
        d2=abs(dist-step);
        r_n_step=sqrt((n.*lamda.*d1.*d2)/(d1+d2));
        % plot(step,[-r_n_step r_n_step],'or',step,0,'og');
        x_pts(end+1)=step;
        y_pts(end+1,:)=[r_n_step,-r_n_step];
        % fprintf("x:%.4f, y:%.4f\n",step,r_n_step);
        % hold on;
    end
    x_pts(1)=[];
    y_pts(1,:)=[];
    % plot(x_pts,y_pts,'--r');
    % hold on
    % define the x- and y-data for the original line we would like to rotate
    x =x_pts;
    y1 = y_pts(:,1)';
    y2 = y_pts(:,2)';
    % create a matrix of these points, which will be useful in future calculations
    v = [x;y1];
    v2 = [x;y2];
    % choose a point which will be the center of rotation
    x_center = x(1);
    y_center = 0;%y1(1);
    y_center2=0;
    % create a matrix which will be used later in calculations
    center = repmat([x_center; y_center], 1, length(x));
    % define a 60 degree counter-clockwise rotation matrix
    [~,el]=angle(tx,rx);
    theta = deg2rad(el);
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    % do the rotation...
    s = v - center;     % shift points in the plane so that the center of rotation is at the origin
    s2 = v2 - center;     % shift points in the plane so that the center of rotation is at the origin
    so = R*s;           % apply the rotation about the origin
    so2 = R*s2;           % apply the rotation about the origin
    vo = so + center;   % shift again so the origin goes back to the desired center of rotation
    vo2 = so2 + center;   % shift again so the origin goes back to the desired center of rotation
    % this can be done in one line as:
    % vo = R*(v - center) + center
    % pick out the vectors of rotated x- and y-data
    x_rotated = vo(1,:);
    y_rotated = vo(2,:);
    y_rotated2 = vo2(2,:);
    % make a plot
    plot(plot_handle,x./1000, y_pts./1000, 'k-', x_rotated./1000, [y_rotated./1000; y_rotated2./1000], 'r-', x_center./1000, y_center./1000, 'bo');
end
axis(plot_handle,"equal");
hold(plot_handle,"off");
end
