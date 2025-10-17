%% Function creates and manages the airways layer on the map axis
% This function creates a background process to get data for the airways in
% the display area and plot them once data is available.
% The need for this function is due to its callbacks requested from
% pan and zoom action, as both those modify map display area.

% get map limits in which to plot the airways, we can't plot all roads in 
% whole country!

function create_airways_service(map_handle)

% Cancel existing service if running
if isfield(map_handle.UserData, 'airways_bckgnd_service')
    f = map_handle.UserData.airways_bckgnd_service;
    if ~isempty(f) && isvalid(f) && ~strcmp(f.State,'finished')
        cancel(f);
    end
end

% Get current map limits and preferences
limits.lat = map_handle.LatitudeLimits;
limits.lon = map_handle.LongitudeLimits;
limits.zoom = map_handle.ZoomLevel;
prefs = map_handle.UserData.airways_prefs;

% Launch background fetch
f = parfeval(backgroundPool, @get_airways_data, 2, limits, prefs);
map_handle.UserData.airways_bckgnd_service = f;

% Register plotting callback when data arrives
afterEach(f, @(fut)plot_airways(fut, map_handle), 0, "PassFuture", true);
end
