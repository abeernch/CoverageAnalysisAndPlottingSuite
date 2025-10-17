function d = plot_distance_line(map_handle, ~)
% plot_distance_line
%
% This function draws a line between the current map center and a user-clicked point.
% It computes the distance and bearing between the two points and displays this information as a label.
% The line and label are styled for visibility.
%
% Inputs:
%   map_handle - handle to the geoaxes or axesm object
%   map_type   - logical flag (true if geoaxes, false if axesm)
%
% Output:
%   d - distance in kilometers between the center and clicked point

% Determine coordinates depending on map type
% if ~map_type
%     % axesm-based map: get current point from axes
%     temp = get(map_handle, 'CurrentPoint');
%     clicked_pts = [temp(1,2), temp(1,1)]; % [lat, lon]
%     center = map_handle.UserData.map_center;
% else
    % geoaxes-based map
    if ~isfield(map_handle.UserData, 'map_center')
        % Initialize center if not yet set
        map_handle.UserData.map_center = map_handle.MapCenter;
    end
    clicked_pts = map_handle.CurrentPoint;
    center = map_handle.UserData.map_center;
% end

% Extract coordinates for line endpoints
x = [center(1), clicked_pts(1,1)]; % Latitudes
y = [center(2), clicked_pts(1,2)]; % Longitudes

% Create tx/rx site objects for measurement
tx = txsite;
tx.Latitude = x(1);
tx.Longitude = y(1);

rx = rxsite;
rx.Latitude = x(2);
rx.Longitude = y(2);

% Compute distance in km
d = distance(tx, rx, 'Map', 'Pak_Master_3') / 1000;

% Compute bearing relative to east (MATLAB convention)
azFromEast = angle(tx, rx, 'Map', 'Pak_Master_3'); % deg CCW from east

% Convert bearing to degrees clockwise from north
if azFromEast > 90 && azFromEast <= 180
    multiplier = +1;
    azFromNorth = 270;
    azFromEast = 180 - azFromEast;
else
    multiplier = -1;
    azFromNorth = 90;
end
azFromNorth = azFromNorth + (multiplier * azFromEast);

% Prepare label text
txt = [char(string(azFromNorth)), '^{o},  ', char(string(d)), ' km'];

% Draw line and label
map_handle.UserData.distance_line.line_obj = line(map_handle, x, y, ...
    'LineWidth', 1.5, ...
    'Color', [0.6350, 0.0780, 0.1840]);

map_handle.UserData.distance_line.txt_obj = text(map_handle, rx.Latitude, rx.Longitude, txt, ...
    'FontSize', 8, ...
    'FontWeight', 'bold', ...
    'Color', [1 1 1], ...
    'BackgroundColor', [0.6350, 0.0780, 0.1840], ...
    'EdgeColor', [0 0 0]);

end
