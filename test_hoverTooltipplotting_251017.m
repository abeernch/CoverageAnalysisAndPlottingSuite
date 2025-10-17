% Read, parse and clean data of locations. Followed by its plotting on an
% axis, both local and a geoaxes. Then create a callback function where the
% names of the locations popup as tooltips when the mouse is hovered over
% it.

clear;clc;close all
delete(timerfindall)

% Choose whether to test on local axis or geoaxes
geoplot = 1;

% Filepath
d = fullfile("Misc/GMCC_maps_files/Pak_Bases.txt");

% Read Data from file
data = readmatrix(d,'OutputType','string');

% Clean data by removing missing samples
cleanedData  = rmmissing(data);
% Convert all codes to uppercase
cleanedData(:,3) = upper(cleanedData(:,3));
% Extract coordinates
coordinates = str2double(cleanedData(:,1:2));

% Visualize redundant data
% figure;scatter(coordinates(:,1),coordinates(:,2),'.r')


%% Filter out repeating coords
f = cell(1,length(coordinates));
newCodes = double.empty(0,1);
repCode = [];

for i = 1:length(coordinates)
    f{i} = find(cleanedData(i,3)==cleanedData(:,3));
    newCodes(i) = f{i}(1);
    repeatingCodes = f{i}(2:end);
    repCode = [repeatingCodes.' repCode];
end

% Get the newCode (index) array, minus the repeating value, using the repCode as
% reference
cleanCodes = setdiff(newCodes,repCode);
% Now, filter the locations basedo on the cleaned indices. Only the indices
% listed in cleanCodes will be used as locations.
zayadacleanedData = cleanedData(cleanCodes,:);
% Extract the coordinates
cleanedCoordinates = str2double(zayadacleanedData(:,1:2));

% Visualize the frequency of repeating codes and cleaned codes
% figure;hist(newCodes,575,1)
% figure;hist(cleanCodes,575,1)

% Store data in figure properties for callback access
names = zayadacleanedData(:,3);

%% Plotting and callback creation 
if geoplot == 1
fig = gcf;
geo_ax = geoaxes;
% Plot cleaned coords
h = geoscatter(geo_ax,cleanedCoordinates(:,1),cleanedCoordinates(:,2),'.r');
else
    fig = gcf;
    h = scatter(cleanedCoordinates(:,1),cleanedCoordinates(:,2),'.r');
end 
fig.UserData.coordinates = cleanedCoordinates;
fig.UserData.names = names;
fig.UserData.scatterHandle = h;
% Create text object for tooltip
fig.UserData.tooltip = text(NaN, NaN, '', 'VerticalAlignment', 'bottom', ...
    'HorizontalAlignment', 'left', 'BackgroundColor', 'yellow', ...
    'Margin', 2, 'FontSize', 8, 'Visible', 'off');
%% Set up hover callback

% Set up callbacks with function handles
set(fig, 'WindowButtonMotionFcn', @hoverCallback);
%% Hover Callbakck
function hoverCallback(src, ~)
% Get stored data from figure
coordinates = src.UserData.coordinates;
names = src.UserData.names;
tooltip = src.UserData.tooltip;

% Get mouse position
ax = get(src, 'CurrentAxes');
cp = get(ax, 'CurrentPoint');
x = cp(1,1);
y = cp(1,2);

% Find closest location to the current point (mouse pointer) on the axis
distances = sqrt((coordinates(:,1)-x).^2 + (coordinates(:,2)-y).^2);
[minDist, idx] = min(distances);

% Show tooltip if close enough to a point
if minDist < 0.15 % Adjust this threshold as needed
    set(tooltip, 'Position', [x y 0], 'String', names{idx}, 'Visible', 'on');
else
    t = timer('TimerFcn', @(~,~) set(tooltip, 'Visible', 'off'), ...
        'StartDelay', 5, 'ExecutionMode', 'singleShot');
    start(t);
    % set(tooltip, 'Visible', 'off');
end
end