function mouse_button_press_callback(fig_handle, event, map_handle)

% This callback is triggered when the mouse button is pressed on the map axes.
% It performs different actions depending on which mouse button is clicked:
%
%   - Left Button (single click):
%       Starts tracking for panning. Initializes movement tracking variables.
%       Also checks if a distance line is currently drawn and deletes it if present.
%
%   - Left Button (double click):
%       Creates a line from the current map center to the clicked point,
%       and displays the distance and bearing.
%
%   - Right Button:
%       Updates the map center to the clicked location and places a marker.
%
% This function uses fields inside `fig_handle.UserData` and `map_handle.UserData`
% to store state (e.g., picked points, move offsets, distance line handles).


% Avoid interaction with the geoaxes if other panels are being clicked,
% dragged etc.
if ~isequal(fig_handle.CurrentObject,map_handle)
    return
end

sel = fig_handle.SelectionType;
map_type = isprop(map_handle,'Basemap');

% Ensure fields exist
if ~isfield(map_handle.UserData, 'map_marker')
    map_handle.UserData.map_marker = [];
end
if ~isfield(map_handle.UserData, 'distance_line')
    map_handle.UserData.distance_line = [];
end

hold(map_handle, "on");

switch sel
    case 'alt' % right click
        if any(isgraphics(map_handle.UserData.map_marker))
            delete(map_handle.UserData.map_marker);
        end
        % if ~map_type
        %     pts = get(map_handle,'CurrentPoint');
        %     map_handle.UserData.map_center = [pts(1,2), pts(1,1)];
        %     map_handle.UserData.map_marker = plot(map_handle, pts(1,1), pts(1,2), ...
        %         'Marker','+','MarkerSize',7,'Color','blue');
        % end
    case 'normal' % left click
        fig_handle.UserData.mouse_down = true;
        fig_handle.UserData.mouse_move_count = 0; % flag used to indicate start of movement
        picked_point = map_handle.CurrentPoint(1,[1 2]);
        c = map_handle.MapCenter;
        map_handle.UserData.move_offset = (c - picked_point) / map_handle.ZoomLevel;
        map_handle.UserData.picked_point = picked_point;
        if any(isfield(map_handle.UserData,'distance_line')) && ~isempty(map_handle.UserData.distance_line)% If a line is plotted
            delete(map_handle.UserData.distance_line.line_obj);
            delete(map_handle.UserData.distance_line.txt_obj);
        end
        map_handle.UserData.prev_lat_lim = map_handle.LatitudeAxis.Limits;
        map_handle.UserData.prev_lon_lim = map_handle.LongitudeAxis.Limits;

    case 'open' % Double click
        if any(isfield(map_handle.UserData,'distance_line')) && ~isempty(map_handle.UserData.distance_line)
            delete(map_handle.UserData.distance_line.line_obj);
            delete(map_handle.UserData.distance_line.txt_obj);
        end
        plot_distance_line(map_handle, map_type);
end
end
