function [lats, lons] = get_roads_data(limits, preferences)
% This function reads shapefile data for roads within the specified bounding box.
% Returns structures containing latitude and longitude arrays for each road type.

% Initialize output structures
lats.motorway = [];
lons.motorway = [];
lats.primary = [];
lons.primary = [];
lats.secondary = [];
lons.secondary = [];
lats.tertiary = [];
lons.tertiary = [];

% Extract bounding box and zoom level
lat_lims = limits.lat;
lon_lims = limits.lon;
zoom = limits.zoom;
bbx = [lon_lims(1), lat_lims(1); lon_lims(2), lat_lims(2)];

% Extract user preferences
motorways_enabled = preferences.motorways_check;
primary_enabled = preferences.primary_check;
secondary_enabled = preferences.secondary_check;
tertiary_enabled = preferences.tertiary_check;

% Directory containing shapefiles
data_dir = fullfile(pwd, 'map_data', 'layers', 'roads');

% Shapefile names
motorways_file = 'motorways.shp';
primary_file = 'primary_roads.shp';
secondary_file = 'secondary_roads.shp';
tertiary_file = 'tertiary_roads.shp';

% Load motorways if enabled
if motorways_enabled
    path = fullfile(data_dir, motorways_file);
    [latData, lonData] = read_road_file(path, bbx);
    lats.motorway = latData;
    lons.motorway = lonData;
end

% Load primary roads if enabled and zoom threshold met
if primary_enabled && zoom > 7
    path = fullfile(data_dir, primary_file);
    [latData, lonData] = read_road_file(path, bbx);
    lats.primary = latData;
    lons.primary = lonData;
end

% Load secondary roads if enabled and zoom threshold met
if secondary_enabled && zoom > 10.9
    path = fullfile(data_dir, secondary_file);
    [latData, lonData] = read_road_file(path, bbx);
    lats.secondary = latData;
    lons.secondary = lonData;
end

% Load tertiary roads if enabled and zoom threshold met
if tertiary_enabled && zoom > 11.7
    path = fullfile(data_dir, tertiary_file);
    [latData, lonData] = read_road_file(path, bbx);
    lats.tertiary = latData;
    lons.tertiary = lonData;
end

% Local helper function for reading shapefile
    function [latOut, lonOut] = read_road_file(filePath, boundingBox)
        s = shaperead(filePath, 'BoundingBox', boundingBox);
        latOut = [];
        lonOut = [];
        for k = 1:numel(s)
            latOut = [latOut, s(k).Y];
            lonOut = [lonOut, s(k).X];
        end
    end
end