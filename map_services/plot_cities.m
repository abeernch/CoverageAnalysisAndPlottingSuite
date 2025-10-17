function plot_cities(f, map_handle)

% Optimized city plotting

% Fetch data
[cities_data, towns_data, villages_data] = fetchOutputs(f);
prefs = map_handle.UserData.places_prefs;
zoom = map_handle.ZoomLevel;

% Safe delete utility
safeDelete = @(h) (isempty(h) || ~any(isgraphics(h))) || delete(h);

% Clear previous graphics
safeDelete(map_handle.UserData.cities);
safeDelete(map_handle.UserData.towns.txt);
safeDelete(map_handle.UserData.towns.pts);
safeDelete(map_handle.UserData.villages.txt);
safeDelete(map_handle.UserData.villages.pts);

% Plot cities
if ~isempty(cities_data.lats)
    map_handle.UserData.cities = text(map_handle, ...
        cities_data.lats, cities_data.lons, cities_data.names, ...
        'Color', prefs.cities_color, 'FontSize', round(zoom+2));
    set(map_handle.UserData.cities,'HitTest','off')
    set(map_handle.UserData.cities,'PickableParts','none')
end

% Plot towns (only if no villages)
if ~isempty(towns_data.lats) && isempty(villages_data.lats)
    map_handle.UserData.towns.txt = text(map_handle, ...
        towns_data.lats, towns_data.lons, towns_data.names, ...
        'Color', prefs.towns_color, 'FontSize', round(zoom-1), ...
        'HorizontalAlignment','left', 'VerticalAlignment','top');
    map_handle.UserData.towns.pts = geoplot(map_handle, ...
        towns_data.lats, towns_data.lons, ...
        'Marker','o','LineStyle','none', ...
        'MarkerFaceColor',prefs.towns_color);
    set(map_handle.UserData.towns.txt,'HitTest','off')
    set(map_handle.UserData.towns.txt,'PickableParts','none')
    map_handle.UserData.towns.pts.HitTest = 'off';
    map_handle.UserData.towns.pts.PickableParts = 'none';
end

% Plot villages
if ~isempty(villages_data.lats)
    map_handle.UserData.villages.txt = text(map_handle, ...
        villages_data.lats, villages_data.lons, villages_data.names, ...
        'Color', prefs.villages_color, 'FontSize', zoom-3, ...
        'HorizontalAlignment','left', 'VerticalAlignment','top');
    map_handle.UserData.villages.pts = geoplot(map_handle, ...
        villages_data.lats, villages_data.lons, ...
        'Marker','o','LineStyle','none', ...
        'MarkerFaceColor',prefs.villages_color);
    set(map_handle.UserData.villages.txt,'HitTest','off')
    set(map_handle.UserData.villages.txt,'PickableParts','none')
    map_handle.UserData.villages.pts.HitTest = 'off';
    map_handle.UserData.villages.pts.PickableParts = 'none';
end
end
