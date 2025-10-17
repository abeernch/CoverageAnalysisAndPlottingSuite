function mouse_move_callback(fig_handle, event, map_handle, app)
% Optimized Mouse Move Callback
%
% This function should be registered as the WindowButtonMotionFcn of the UIFigure
% e.g.,  app.UIFigure.WindowButtonMotionFcn = @(src, event) mouse_move_callback(src, event, app.MapAxes, app);

% A lot of redundancy removed to optimze usage. New display, no more
% deletion and creation, only updating fields.

% Author: Abeer Chaudhry 
% 250701
persistent throttleUpdate

% Exit if not on the Map tab
if ~strcmp(app.TabGroup.SelectedTab.Title, 'LOS Link')
    return;
end


% Update Throttling to reduce the nimber of updates.

% If the  duration between callback is less than 50ms, there will be no
% update.
if isempty(throttleUpdate)
    throttleUpdate = tic;
end

if toc(throttleUpdate)<0.05
    return
end
throttleUpdate = tic;

    current_point = map_handle.CurrentPoint(1, [1 2]);
    % zoom = map_handle.ZoomLevel;

    if ~isfield(map_handle.UserData, 'titleHandle') || ~isvalid(map_handle.UserData.titleHandle) || ~isvalid(map_handle.UserData.coordTextHandle)
        map_handle.UserData.titleHandle = title(map_handle, '', 'Color', 'y', 'BackgroundColor', 'black');
        map_handle.UserData.coordTextHandle = text(map_handle, ...
            0.9, 0.1, '', ...
            'Units', 'normalized', ...
            'FontSize', 10, ...
            'Color', 'yellow', ...
            'BackgroundColor', 'black', ...
            'Margin', 5, ...
            'VerticalAlignment', 'middle', ...
            'FontWeight','bold', ...
            'EdgeColor','y','LineWidth',1.5);
    end

    % Handle panning if mouse is down
    if isfield(fig_handle.UserData, 'mouse_down') && fig_handle.UserData.mouse_down
        picked = map_handle.UserData.picked_point;
        diff = current_point - picked;
        c = map_handle.MapCenter;
        c(1) = c(1) - diff(1);
        c(2) = c(2) - diff(2);
        map_handle.MapCenter = c;
    end

    zoom = map_handle.ZoomLevel;
    lat=current_point(1);
    lon=current_point(2);
    

    % Update the label text
    map_handle.UserData.coordTextHandle.String = ...
        sprintf('Lat: %.6f\nLon: %.6f\nZoom: %.2f', lat, lon, zoom);
    map_handle.UserData.coordTextHandle.HitTest = 'off';
    map_handle.UserData.coordTextHandle.PickableParts = 'none';
end

