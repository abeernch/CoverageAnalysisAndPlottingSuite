function mouse_button_release_callback(fig_handle,event,map_handle)

% This callback is triggered when the mouse button is released after a drag or click.
% It is mainly responsible for:
%
%   - Completing panning operations when the left button was pressed and moved.
%   - Checking whether the mouse was moved significantly during the drag.
%     If so, it triggers the loading and plotting of roads, cities, and boundaries
%     in the newly visible map area by calling:
%         create_roads_service()
%         create_cities_service()
%         create_boundaries_service()
%
% This ensures the background data layers are refreshed after the user pans the map.
%
% It also resets the "mouse down" tracking flag in `fig_handle.UserData`.
% Avoid interaction with the geoaxes if other panels are being clicked,
% dragged etc.
if ~isequal(fig_handle.CurrentObject,map_handle)
    return
end

% respond to left button single press only
if strcmp(fig_handle.SelectionType,'normal')
    fig_handle.UserData.mouse_down=false;
    prev_lat_lim = map_handle.UserData.prev_lat_lim;
    prev_lon_lim = map_handle.UserData.prev_lon_lim;
    current_lat_lim = map_handle.LatitudeAxis.Limits;
    current_lon_lim = map_handle.LongitudeAxis.Limits;

    % Compute how much the map view has changed
    lat_shift = abs(mean(current_lat_lim) - mean(prev_lat_lim));
    lon_shift = abs(mean(current_lon_lim) - mean(prev_lon_lim));

    % Define thresholds (adjust as needed for sensitivity)
    base_lat_thresh = 0.05;  % ~1 km for small zoom levels
    base_lon_thresh = 0.02;

    % Sensitivity factor (lower at higher zooms)
    % zoom_sensitivity = 2^(map_handle.ZoomLevel - 1);  % exponential scaling

    % Adjust thresholds inversely with zoom
    lat_thresh = base_lat_thresh * map_handle.ZoomLevel;
    lon_thresh = base_lon_thresh * map_handle.ZoomLevel;

    if lat_shift > lat_thresh || lon_shift > lon_thresh
        clear_roads_n_cities(map_handle);
        create_roads_service(map_handle);
        create_cities_service(map_handle);
        create_boundaries_service(map_handle);
        create_airways_service(map_handle);

        % Update the previous limits
        map_handle.UserData.prev_lat_lim = current_lat_lim;
        map_handle.UserData.prev_lon_lim = current_lon_lim;
    end
end
end
