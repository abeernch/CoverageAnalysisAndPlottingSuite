function plot_boundaries(f, map_handle)
% Optimized boundary plotting

% Fetch data
[country_data, prov_data, districts_data] = fetchOutputs(f);
prefs = map_handle.UserData.boundaries_prefs;
zoom = map_handle.ZoomLevel;
% safeDelete = @(h) (isempty(h) || ~any(isgraphics(h))) || delete(h);

% Districts
safeDelete(map_handle.UserData.boundaries.districts);
if ~isempty(districts_data.lats)
    map_handle.UserData.boundaries.districts = line(map_handle, ...
        districts_data.lats, districts_data.lons, ...
        'LineStyle',':','Color',prefs.districts_color, ...
        'LineWidth',1);
end

% Provinces
safeDelete(map_handle.UserData.boundaries.provinces);
if ~isempty(prov_data.lats)
    map_handle.UserData.boundaries.provinces = line(map_handle, ...
        prov_data.lats, prov_data.lons, ...
        'LineStyle','--','Color',prefs.provinces_color, ...
        'LineWidth',1.5);
end

% Country
safeDelete(map_handle.UserData.boundaries.country);
if ~isempty(country_data.lats)
    map_handle.UserData.boundaries.country = line(map_handle, ...
        country_data.lats, country_data.lons, ...
        'LineStyle','-','Color',prefs.country_color, ...
        'LineWidth',zoom/4);
end
end

function safeDelete(h)
    if ~isempty(h) && any(isgraphics(h))
        delete(h);
    end
end
