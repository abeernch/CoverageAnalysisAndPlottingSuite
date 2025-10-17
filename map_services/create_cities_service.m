% function create_cities_service(map_handle)
% % this function creates a background process to get data for the roads in
% % the display area and plot them once data is available.
% % The need for this function is due to its callbacks requested from
% % pan and zoom action, as both those modify map display area.
% % !! Data dependency: This function needs the data field
% % 'map_handle.UserData.places_prefs' to be defined before call
% %% get map limits in which to plot the roads, we can't plot all roads in whole country!
% limits.lat=map_handle.LatitudeLimits;
% limits.lon=map_handle.LongitudeLimits;
% limits.zoom=map_handle.ZoomLevel;
% prefs=map_handle.UserData.places_prefs;
% %% Create background process to run the function which retrieves roads data
% f=parfeval(backgroundPool,@get_cities_data,3,limits,prefs);
% map_handle.UserData.cities_bckgnd_service=f;
% % fprintf('create service\n')
% %% After above function finishes execution and data is available, call plotting function
% afterEach(f,@(fut_)plot_cities(fut_,map_handle),0,"PassFuture",true);
% end

%%

function create_cities_service(map_handle)
% Optimized creation of background cities fetch service
% Assumes get_cities_data returns 3 outputs

% Cancel existing fetch if running
if isfield(map_handle.UserData, 'cities_bckgnd_service')
    f = map_handle.UserData.cities_bckgnd_service;
    if ~isempty(f) && isvalid(f) && ~strcmp(f.State, 'finished')
        cancel(f);
    end
end

% Validate preferences
if ~isfield(map_handle.UserData, 'places_prefs') || isempty(map_handle.UserData.places_prefs)
    warning('places_prefs not defined. Skipping cities fetch.');
    updateText(app,'Places_prefs not defined. Skipping cities fetch.')
    return;
end
prefs = map_handle.UserData.places_prefs;

% Get map limits and zoom
limits.lat = map_handle.LatitudeLimits;
limits.lon = map_handle.LongitudeLimits;
limits.zoom = map_handle.ZoomLevel;

if map_handle.UserData.placesUpdated == 0
    if isfield(map_handle.UserData, 'last_cities_limits')
        prev = map_handle.UserData.last_cities_limits;
        dlat = abs(mean(limits.lat) - mean(prev.lat));
        dlon = abs(mean(limits.lon) - mean(prev.lon));
        dzoom = abs(limits.zoom - prev.zoom);
        if dlat < 0.0001 && dlon < 0.0001 && dzoom < 0.1
            % No meaningful change, skip fetch
            return;
        end
    end
end
% Store current extent
map_handle.UserData.last_cities_limits = limits;

% Launch background fetch
f = parfeval(backgroundPool, @get_cities_data, 3, limits, prefs);
map_handle.UserData.cities_bckgnd_service = f;

% Register plotting callback when done
afterEach(f, @(fut)plot_cities(fut, map_handle), 0, "PassFuture", true);
map_handle.UserData.placesUpdated=0;
end
