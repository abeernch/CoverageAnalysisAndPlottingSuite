function plot_airways(f, gx)
% Optimized airways plotting function

% Fetch data
[lats, lons] = fetchOutputs(f);
zoom = gx.ZoomLevel;
prefs = gx.UserData.airways_prefs;

% Utility for safe delete
safeDelete = @(h) (isempty(h) || ~any(isgraphics(h))) || delete(h);

% Delete previous
safeDelete(gx.UserData.airways);

% Plot only if zoom threshold met and data available
% if zoom > minZoom
latData = lats;
lonData = lons;
if ~isempty(latData) && ~isempty(lonData)
    gx.UserData.airways = line(gx, latData, lonData, ...
        'LineStyle',':', 'Color', prefs.color,'Marker','hexagram', 'MarkerSize',3);
    gx.UserData.airways.HitTest = 'off';
    gx.UserData.airways.PickableParts = 'none';
end
end
% end

