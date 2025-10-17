function [cities, towns, villages] = get_cities_data(limits, prefs)
% Optimized cities data retrieval

% Initialize outputs
emptyStruct = struct('lats', [], 'lons', [], 'names', []);
cities = emptyStruct;
towns = emptyStruct;
villages = emptyStruct;

% Limits
lat_lims = limits.lat;
lon_lims = limits.lon;
zoom = limits.zoom;
bbx = [lon_lims(1), lat_lims(1); lon_lims(2), lat_lims(2)];

% Base path
baseDir = fullfile(pwd, 'map_data', 'layers', 'places');
files = struct(...
    'large_cities', fullfile(baseDir, 'cities_large_asia', 'cities_large_asia.shp'), ...
    'cities', fullfile(baseDir, 'cities', 'cities.shp'), ...
    'towns', fullfile(baseDir, 'towns', 'towns.shp'), ...
    'villages', fullfile(baseDir, 'villages', 'villages.shp'));

%% Cities
if prefs.cities_check
    if zoom < 6
        file = files.large_cities;
        nameField = 'name';
    else
        file = files.cities;
        nameField = 'name_en';
    end

    [s, a] = shaperead(file, 'BoundingBox', bbx);
    if ~isempty(s)
        pops = arrayfun(@(x) str2double(x.population), a);
        include = (zoom >= 9) | (zoom < 7 & pops > 500000) | ...
            (zoom >= 7 & zoom < 9 & pops > 100000);
        idx = find(include);
        cities.lats = [s(idx).Y];
        cities.lons = [s(idx).X];
        cities.names = {a(idx).(nameField)};
    end
end

%% Towns
if prefs.towns_check && zoom > 10.9
    [s, a] = shaperead(files.towns, 'BoundingBox', bbx);
    if ~isempty(s)
        towns.lats = [s.Y];
        towns.lons = [s.X];
        towns.names = {a.name_en};
    end
end

%% Villages
if prefs.villages_check && zoom > 12.6
    [s, a] = shaperead(files.villages, 'BoundingBox', bbx);
    if ~isempty(s)
        villages.lats = [s.Y];
        villages.lons = [s.X];
        villages.names = {a.name_en};
    end
end
end
