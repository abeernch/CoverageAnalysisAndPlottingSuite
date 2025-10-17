function [lats, lons] = get_airways_data(limits, preferences)
% This function reads shapefile data for the airways within the specified bounding box.
% Returns structures containing latitude and longitude arrays.

% Initialize output structures
lats = [];
lons = [];

% Extract bounding box and zoom level
lat_lims = limits.lat;
lon_lims = limits.lon;
zoom = limits.zoom;
bbx = [lon_lims(1), lat_lims(1); lon_lims(2), lat_lims(2)];

% Extract user preferences
airways_enabled = preferences.check;

% Directory containing shapefiles
data_dir = fullfile(pwd, 'map_data', 'Airways');

% Shapefile names
filename = 'Airways.shp';

% Load airways if enabled
if airways_enabled
    path = fullfile(data_dir, filename);
    [latData, lonData] = read_airways_file(path, bbx);
    lats = latData;
    lons = lonData;
end


% Local helper function for reading shapefile
    function [latOut, lonOut] = read_airways_file(filePath, boundingBox)
        s = shaperead(filePath, 'BoundingBox', boundingBox);
        latOut = [];
        lonOut = [];
        for k = 1:numel(s)
            latOut = [latOut, s(k).Y];
            lonOut = [lonOut, s(k).X];
        end
    end
end