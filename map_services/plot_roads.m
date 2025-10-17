function plot_roads(f, gx)
% Optimized road plotting function

% Fetch data
[lats, lons] = fetchOutputs(f);
zoom = gx.ZoomLevel;
prefs = gx.UserData.roads_prefs;

% Utility for safe delete
safeDelete = @(h) (isempty(h) || ~any(isgraphics(h))) || delete(h);

% Define road types and thresholds
road_types = {
    'motorway', -Inf, prefs.motorways_color;
    'primary', 7, prefs.primary_color;
    'secondary', 10.5, prefs.secondary_color;
    'tertiary', 11.7, prefs.tertiary_color;
};

% Iterate over each road type
for i = 1:size(road_types,1)
    name = road_types{i,1};
    minZoom = road_types{i,2};
    color = road_types{i,3};

    % Delete previous
    safeDelete(gx.UserData.roads.(name));

    % Plot only if zoom threshold met and data available
    if zoom > minZoom
        latData = lats.(name);
        lonData = lons.(name);
        if ~isempty(latData) && ~isempty(lonData)
            gx.UserData.roads.(name) = line(gx, latData, lonData, ...
                'LineStyle',':', 'Color', color);
            gx.UserData.roads.(name).HitTest = 'off';
            gx.UserData.roads.(name).PickableParts = 'none';
        end
    end
end
end
