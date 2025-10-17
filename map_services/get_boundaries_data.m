function [country, provinces, districts] = get_boundaries_data(limits, prefs)
% Optimized boundaries retrieval

% Init
emptyStruct = struct('lats', [], 'lons', [], 'names', []);
country = emptyStruct;
provinces = emptyStruct;
districts = emptyStruct;

% Limits
lat_lims = limits.lat;
lon_lims = limits.lon;
zoom = limits.zoom;
bbx = [lon_lims(1), lat_lims(1); lon_lims(2), lat_lims(2)];

% Base paths
baseDir = fullfile(pwd, 'map_data', 'layers', 'boundaries');
files = struct(...
    'country', fullfile(baseDir, 'country.shp'), ...
    'provinces', fullfile(baseDir, 'provincial.shp'), ...
    'districts', fullfile(baseDir, 'districts.shp'));

% Helper
readBoundary = @(file) shaperead(file, 'BoundingBox', bbx);

%% Country
if prefs.country_check
    s = readBoundary(files.country);
    if ~isempty(s)
        country.lats = [s.Y];
        country.lons = [s.X];
    end
end

%% Provinces
if prefs.provinces_check && zoom > 6
    [s,a] = shaperead(files.provinces, 'BoundingBox', bbx);
    if ~isempty(s)
        provinces.lats = [s.Y];
        provinces.lons = [s.X];
        provinces.names = {a.NAME_1};
    end
end

%% Districts
if prefs.districts_check && zoom > 8.9
    [s,a] = shaperead(files.districts, 'BoundingBox', bbx);
    if ~isempty(s)
        districts.lats = [s.Y];
        districts.lons = [s.X];
        districts.names = {a.NAME_3};
    end
end
end
