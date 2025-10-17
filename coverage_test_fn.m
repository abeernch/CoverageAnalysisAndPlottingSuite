function [return_status, LOS_LENGTH, LOS_LATS, LOS_LONGS, info_data] = coverage_test_fn(app, lat_all, lon_all, antena_heights_all, ...
                         coverage_dist, angle_step, site_en_flags, height_array, range_step_minor, start_dist, range_step_major, convergance_distance, ...
                         Terrain_Name, AGL_ASL_FLAG, session_tag)
t = tic;
% Initialize
info_data = [];
data_directory = 'D:\RCI_Data\';
if ~exist(data_directory, 'dir')
    mkdir(data_directory);
end

angles = 1:angle_step:360;
no_of_angles = numel(angles);
no_of_sites = numel(lat_all);
no_of_heights = numel(height_array);

% Preallocate output arrays
LOS_LENGTH = zeros(no_of_angles, no_of_heights, no_of_sites);
LOS_LATS = zeros(no_of_angles, no_of_heights, no_of_sites);
LOS_LONGS = zeros(no_of_angles, no_of_heights, no_of_sites);

% Check cancellation
if ~app.continue_calculation
    return_status = false;
    return
end

earth_radius = earthRadius('m');
wait_bar_handle = waitbar(0, 'Computing coverage regions, Please wait...', 'CreateCancelBtn', {@cancel_callback, app}, ...
    'WindowStyle', 'modal', 'Name', 'Computing Coverage');

site_names = ["C-Site", "Site-1", "Site-2", "Site-3"];
session_data = struct();
progress = 0;
total_iterations = 1;

for current_site_index = 1:no_of_sites
    if ~app.continue_calculation
        return_status = false;
        delete(wait_bar_handle);
        return
    end

    current_site_name=site_names(current_site_index);

    if site_en_flags(current_site_index)
        % TX site setup
        write_to_file = false;
        latIn = lat_all(current_site_index);
        lonIn = lon_all(current_site_index);
        Antenna_Height = antena_heights_all(current_site_index);
        tx = txsite("Latitude", latIn, "Longitude", lonIn, 'AntennaHeight', Antenna_Height);

        % Prepare parallel pool if needed
        if isempty(gcp('nocreate'))
            waitbar(progress, wait_bar_handle, 'Starting parallel pool...');
            parpool('RAPS');
        end

        % Elevation data generation (parfor over angles)
        % elevation_angles = zeros(ceil(coverage_dist / range_step_minor), no_of_angles);
        num_points = numel(range_step_minor : range_step_minor : coverage_dist) + 1;
        elevation_angles = zeros(num_points, no_of_angles);

        %%%%%
        parfor angle_index = 1:no_of_angles
            azimuth = angles(angle_index);
            arc_angle = rad2deg(coverage_dist / earth_radius);
            [latOut, lonOut] = reckon(latIn, lonIn, arc_angle, azimuth);
            rx = rxsite("Latitude", latOut, "Longitude", lonOut);
            elevation_angles(:, angle_index) = el_data_gen(tx, range_step_minor, Terrain_Name, azimuth, coverage_dist);
        end

        % Loop over heights
        t1 = tic;
        for height_index = 1:no_of_heights
            current_height = height_array(height_index);
            los_length_temp = zeros(no_of_angles, 1);
            los_lat_temp = zeros(no_of_angles, 1);
            los_long_temp = zeros(no_of_angles, 1);

            % LOS calculation (parfor over angles)
            for angle_index = 1:no_of_angles
                azimuth = angles(angle_index);
                arc_angle = rad2deg(coverage_dist / earth_radius);
                [latOut, lonOut] = reckon(latIn, lonIn, arc_angle, azimuth);
                rx = rxsite("Latitude", latOut, "Longitude", lonOut);

                % Determine antenna height
                if AGL_ASL_FLAG
                    height = current_height;
                else
                    elev = elevation(rx, 'Map', Terrain_Name);
                    height = max(current_height - elev, 0);
                end

                rx.AntennaHeight = height;

                % If height under terrain, LOS not possible
                if rx.AntennaHeight == 0
                    los_length_temp(angle_index) = 0;
                    continue
                end

                [obs_lat, obs_lon, obs_dist, los_status] = line_of_sight(tx, rx, range_step_minor, Terrain_Name, azimuth, ...
                    coverage_dist, coverage_dist, elevation_angles(:, angle_index));

                % If no obstruction found, record maximum distance
                if los_status || obs_dist >= coverage_dist - 50
                    los_length_temp(angle_index) = coverage_dist;
                    los_lat_temp(angle_index) = latOut;
                    los_long_temp(angle_index) = lonOut;
                else
                    % Convergence loop
                    d_start = 1000;
                    d_end = coverage_dist;
                    for iter = 1:20
                        midpoint = (d_start + d_end) / 2;
                        arc_angle = rad2deg(midpoint / earth_radius);
                        [latMid, lonMid] = reckon(latIn, lonIn, arc_angle, azimuth);
                        rx.Latitude = latMid;
                        rx.Longitude = lonMid;

                        if AGL_ASL_FLAG
                            height = current_height;
                        else
                            elev = elevation(rx, 'Map', Terrain_Name);
                            height = max(current_height - elev, 0);
                        end

                        rx.AntennaHeight = height;

                        if rx.AntennaHeight == 0
                            break
                        end

                        [~, ~, obs_dist, los_status] = line_of_sight(tx, rx, range_step_minor, Terrain_Name, azimuth, ...
                            midpoint, coverage_dist, elevation_angles(:, angle_index));

                        if los_status
                            d_start = midpoint;
                        else
                            d_end = midpoint;
                        end

                        if abs(d_end - d_start) < convergance_distance
                            break
                        end
                    end

                    los_length_temp(angle_index) = midpoint;
                    los_lat_temp(angle_index) = latMid;
                    los_long_temp(angle_index) = lonMid;
                end
            end

            % Store results
            LOS_LENGTH(:, height_index, current_site_index) = los_length_temp;
            LOS_LATS(:, height_index, current_site_index) = los_lat_temp;
            LOS_LONGS(:, height_index, current_site_index) = los_long_temp;

            % Progress
            progress = total_iterations / (no_of_heights * sum(site_en_flags));
            waitbar(progress, wait_bar_handle, sprintf('Processed %s height %d m', site_names(current_site_index), current_height));
            total_iterations = total_iterations + 1;

            if ~app.continue_calculation
                return_status = false;
                delete(wait_bar_handle);
                return
            end
            write_to_file = true;
        end

        toc(t1)

        % Save to file 
        if (write_to_file) % write data to file only if new data was calculated
            distance_2=LOS_LENGTH(:,:,current_site_index);
            los_lat_data=LOS_LATS(:,:,current_site_index);
            los_lon_data=LOS_LONGS(1:end,:,current_site_index);
            [tbl,file]=write_site_data(app.dir,los_lat_data,los_lon_data,distance_2,current_site_name,latIn,lonIn,Antenna_Height,height_array,coverage_dist,AGL_ASL_FLAG);
            site_name=erase(current_site_name,'-');
            table_size=size(tbl);
            cols=table_size(2);
            tbl(:,cols+1)=table(file,'VariableNames',{'data_file'});
            tbl.Properties.VariableNames{cols+1}='data_file';
            session_data.(site_name)=tbl;
            info_data = session_data;

        end

    end
end

delete(wait_bar_handle)
return_status = true;
fprintf("LOS calculation completed.\n");
toc(t); 
end

function cancel_callback(src, app)
app.continue_calculation = false;
src.Enable = 'off';
end
