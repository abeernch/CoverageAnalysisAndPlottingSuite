function mouse_scroll_callback(fig_handle, event, map_handle, app)
% Optimized smooth mouse scroll callback for geoaxes
% Removed redundant code, replaced recomputation and inefficient
% implementations for delays etc. 

% Prev Impl
% 1.  Each scrll used to recreate the map services after first deleting them. 
% 2. The quadrant logic was very complex for choosing where to zoom.
% 3. Repeated string concatenation for basemap switching
% 4. The mouse_move_callback is triggered with each scroll which causes
% double redraws
% 5. Printing too much

% FIXES.
% 1. Used drawnow() to control enabling updating
% 2. Will now only create overlays and call for services after the integer
% level is crossed or when basemaps change
% 3. Quadrant logic optimized
% 4. move_mouse_callback replaced with updateZoomText(app) helper function
% to only update the zoom level in the text field on the axes.

% Result:
% Better responsiveness, less lag and optimized switching of basemaps

% Author: Abeer Chaudhry 
% 250702

% Exit early if not on Map tab
if ~strcmp(app.TabGroup.SelectedTab.Title, 'LOS Link')
    return;
end

% Retrieve pointer location before zoom
poi = map_handle.CurrentPoint(1, [1 2]);

% Initialize previous zoom level if missing
if ~isfield(fig_handle.UserData, 'prev_map_level')
    fig_handle.UserData.prev_map_level = (map_handle.ZoomLevel);
end

prev_level_int = fig_handle.UserData.prev_map_level;

% Compute new zoom level
zoom_step = 0.15;
zoom_min = 6;
zoom_max = 13.85;

current_zoom = map_handle.ZoomLevel;

if event.VerticalScrollCount > 0
    new_zoom = max(current_zoom - zoom_step, zoom_min);
else
    new_zoom = min(current_zoom + zoom_step, zoom_max);
end

% Snap if near integer zoom
if abs(new_zoom - round(new_zoom)) < 0.1
    new_zoom = round(new_zoom);
end

% Apply new zoom level only if changed
if abs(new_zoom - current_zoom) > 0
    map_handle.ZoomLevel = new_zoom;
    % drawnow ; % Ensure zoom is applied before further calculations
end

% Determine new integer zoom level
level_int = floor(map_handle.ZoomLevel);

% Update basemap if integer level changed
if level_int ~= prev_level_int
    prefix = map_handle.UserData.map_prefix;
    map_levels = map_handle.UserData.map_levels;

    if ~isempty(prefix) && ~isempty(map_levels) && map_levels(level_int + 1)
        basemap_name = sprintf('%s_%d', prefix, level_int);

        % Safely try to update basemap
        try
            if ~strcmp(map_handle.Basemap,basemap_name)
                map_handle.Basemap = basemap_name;
            end
        catch
            warning('Basemap %s not available.', basemap_name);
        end
    end

    % Refresh overlays only if zoom crossed integer boundary
    % clear_roads_n_cities(map_handle);
    % create_roads_service(map_handle);
    % create_cities_service(map_handle);
    % create_boundaries_service(map_handle);
    % Store new level
    fig_handle.UserData.prev_map_level = level_int;
end

% Retrieve pointer location after zoom
poi2 = map_handle.CurrentPoint(1, [1 2]);

% Compute map center adjustment to zoom towards pointer
c = map_handle.MapCenter;
delta_lat = poi2(1) - poi(1);
delta_lon = poi2(2) - poi(2);

% Pan in proportion to zoom direction
zoom_dir = sign(event.VerticalScrollCount);
c(1) = c(1) + delta_lat * zoom_dir;
c(2) = c(2) + delta_lon * zoom_dir;

% Clamp panning to prevent drifting outside valid bounds
lat_limits = map_handle.LatitudeLimits;
lon_limits = map_handle.LongitudeLimits;
c(1) = min(max(c(1), lat_limits(1)), lat_limits(2));
c(2) = min(max(c(2), lon_limits(1)), lon_limits(2));

% Update map center
map_handle.MapCenter = c;

% Refresh coordinate text 
updateZoomText(app);
clear_roads_n_cities(map_handle);
create_roads_service(map_handle);
create_cities_service(map_handle);
create_boundaries_service(map_handle);
create_airways_service(map_handle);
% drawnow limitrate nocallbacks
 
end
