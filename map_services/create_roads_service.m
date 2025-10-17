% function create_roads_service(map_handle)
% % this function creates a background process to get data for the roads in
% % the display area and plot them once data is available.
% % The need for this function is due to its callbacks requested from
% % pan and zoom action, as both those modify map display area.
% %% get map limits in which to plot the roads, we can't plot all roads in whole country!
% limits.lat=map_handle.LatitudeLimits;
% limits.lon=map_handle.LongitudeLimits;
% limits.zoom=map_handle.ZoomLevel;
% prefs=map_handle.UserData.roads_prefs;
% %% Create background process to run the function which retrieves roads data
% f=parfeval(backgroundPool,@get_roads_data,2,limits,prefs);
% map_handle.UserData.bckgnd_service=f;
% % fprintf('create service\n')
% %% After above function finishes execution and data is available, call plotting function
% afterEach(f,@(fut_)plot_roads(fut_,map_handle),0,"PassFuture",true);
% end

%%

function create_roads_service(map_handle)
% Throttled creation of background roads service

% Cancel existing service if running
if isfield(map_handle.UserData, 'bckgnd_service')
    f = map_handle.UserData.bckgnd_service;
    if ~isempty(f) && isvalid(f) && ~strcmp(f.State,'finished')
        cancel(f);
    end
end

% Get current map limits and preferences
limits.lat = map_handle.LatitudeLimits;
limits.lon = map_handle.LongitudeLimits;
limits.zoom = map_handle.ZoomLevel;
prefs = map_handle.UserData.roads_prefs;

% Launch background fetch
f = parfeval(backgroundPool, @get_roads_data, 2, limits, prefs);
map_handle.UserData.bckgnd_service = f;

% Register plotting callback when data arrives
afterEach(f, @(fut)plot_roads(fut, map_handle), 0, "PassFuture", true);
end
