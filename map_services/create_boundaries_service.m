function create_boundaries_service(map_handle)
% this function creates a background process to get data for the boundaries in
% the display area and plot them once data is available.
% The need for this function is due to its callbacks requested from
% pan and zoom action, as both those modify map display area.
%% get map limits in which to plot the roads, we can't plot all roads in whole country!
limits.lat=map_handle.LatitudeLimits;
limits.lon=map_handle.LongitudeLimits;
limits.zoom=map_handle.ZoomLevel;
prefs=map_handle.UserData.boundaries_prefs;
%% Create background process to run the function which retrieves roads data
f=parfeval(backgroundPool,@get_boundaries_data,3,limits,prefs);
map_handle.UserData.bounds_bckgnd_service=f;
% fprintf('create service\n')
%% After above function finishes execution and data is available, call plotting function
afterEach(f,@(fut_)plot_boundaries(fut_,map_handle),0,"PassFuture",true);
end