% -------------------- Adding Custom Basemaps --------------------------
% The following script adss custom basemaps for use use with matlab and
% associated apps. The scripts requires location of the mbtiles files.
% When adding maps, set the 'map_name_prefix' to set the map name and range
% of zoom levels. Please note that script assumes separte .mbtile file for
% each zoom level. When script runs asks for option, select 1 to add maps

% This same script can be used to remove already installed basemaps. This
% may be required if you want to change the directory of mbtiles files. In
% that case, you will remove already installed maps and re-install maps
% with new path to mbtiles files.
% To remove maps, set the 'map_name_prefix' variable and the corresponding
% zoom levels for which you want to remove maps. Then run the script and
% select option 2 to remove maps.

% If you enter any other input than 1 or 2, script does nothing.

% **** This script can be complied and run on target PC if deploying apps**
% *** See the folder add_remove_maps_binary for compilation project. ***s
%% !! Set the Configuration parameters before running this script
prompt=sprintf("Select an option: \n1. Add Basemaps    2. Remove Basemaps\n");
inpt=100;
inpt=input(prompt);
%% Configuration parameters
adding_maps=false;
removing_maps=false;
map_name_prefix='satellite_';
zoom_start=1;
zoom_end=16;
%% process script
if(inpt==1)
    adding_maps=true;  % set to true if adding maps
else
    if(inpt==2)
        removing_maps=true;
    end
end
if adding_maps
    fprintf('you opted to add maps\n');
end
if removing_maps
    fprintf('you opted to remove maps\n');
end
% !! setting above two parameters both to true will do neither of the two
dir=uigetdir; % get directory of where the tile data is stored,
             % usually D:\RCI_Data\terrain_maps
%%
for zoom=zoom_start:zoom_end
    % disp(zoom)
    map_name=[map_name_prefix char(string(zoom))];
    file_path=[dir '\' map_name '.mbtiles'];

    if exist(file_path)==2
        fprintf("file found: %s \n",file_path)
        if(adding_maps==true && removing_maps==false)
            fprintf("adding map: %s\n",map_name)
            addCustomBasemap(map_name,file_path,'Attribution','Developed by Radar Div NASTAP','IsDeployable',true)
            pause(2)
        end
    else
        fprintf("file not found: %s \n",file_path);
    end
    if(adding_maps==false && removing_maps==true)
        fprintf("removing map: %s\n",map_name)
        removeCustomBasemap(map_name)
        pause(2)
    end

end

inpt=input("\n Press any key to exit....\n","s");
