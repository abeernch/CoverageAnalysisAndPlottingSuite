function flag=map_roads_service(x)
% an infinite running function in the background to serve as service for
% map data ploting like roads/places/boundaries
flag=1;
gx=gca;
fprintf('map service started\n')
lat_lims_prev=gx.LatitudeLimits;
lon_lims_prev=gx.LongitudeLimits;
limits_changed=false;
while true
    lat_lims=gx.LatitudeLimits;
    lon_lims=gx.LongitudeLimits;
    if lat_lims==lat_lims_prev
        if lon_lims==lon_lims_prev
            pause(2);
            limits_changed=false;
        else
            limits_changed=true;
        end
    else
        limits_changed=true;
    end
    if(limits_changed)
        fprintf('limits changed\n');
        limits_changed=false;
    end
    lat_lims_prev=lat_lims;
    lon_lims_prev=lon_lims;
end
fprintf('map service ended\n')
flag=0;
end