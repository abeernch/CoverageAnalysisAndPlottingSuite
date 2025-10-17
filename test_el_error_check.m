%% Usage inforamtaion: This script finds the areas where data from dted
% files shows a change of given threshold. The step size is 1/1200 in both
% lat/lon. Set the below variables and run the script to find areas where
% you want to see the required change in elevation. The lat/lon of the
% identified areas are availbe in the workspace in variables 'lats/lons'.

% !Warning: The script clears the workspace
clc, clear;
search_lat_lim_low=26;%28.5;
search_lat_lim_up=34;%32.7;
search_lon_lim_up=74.4;%75.5;%74.4;
search_lon_lim_low=71.1;%66;%71.1;
el_threshold=50; % change in elevation to find
%% Read DTED Files
t1=tic;
parfor file_no=1:715
    file=string(file_no);
    if file_no<100
        file="0"+file;
        if file_no<10
            file="0"+file;
        end
    end
    file_path='D:/People/Shahzad Anwar Khan/RCI App/RCI/Master_DTEDs/Master';
    path=file_path+"/"+file+".dt1";
    if(isfile(path))
        [A,R]=readgeoraster(path);
        lat_lims=R.LatitudeLimits;
        lon_lims=R.LongitudeLimits;
        lat_check=sum(lat_lims<search_lat_lim_up) && sum(lat_lims>search_lat_lim_low);
        lon_check=sum(lon_lims<search_lon_lim_up) && sum(lon_lims>search_lon_lim_low);
        if lat_check && lon_check
            [lats,lons]=find_dips(A,R,el_threshold);
            % file_no_str="file"+string(file_no);
            dips{file_no}={lats,lons};
        else
            dips{file_no}={};
        end
    else
        fprintf("file missing: %s \n",path);
    end
end
toc(t1);
fprintf("*** all done with finding dips****\n")
breakpoint=0;
ind=1;
dips_found={};
for index=1:length(dips)
    dip=dips{index};
    if isempty(dip)
        continue;
    else
        if isempty(dip{1})
            continue;
        else
            dips_found{ind}=dip;
            ind=ind+1;
        end
    end
end

lats=[];
lons=[];
for x=1:length(dips_found)
    dip=dips_found{x};
    lats=[lats,dip{1}];
    lons=[lons,dip{2}];
end
%% Plot the points found
gx=geoaxes('Basemap','satellite');
geoplot(gx,lats,lons,'LineStyle','none','Marker','.');
%% Local Function to find elevation change
function [lats,lons]=find_dips(A,R,el_threshold)
ind=1;
lats=zeros(1,1201);
lons=zeros(1,1201);
for row=1:1201
    for col=1:1201
        pt1=A(row,col);
        if row>1
            pt2=A(row-1,col);
            if col>1
                pt3=A(row,col-1);
                pt4=A(row-1,col-1);
            else
                pt3=pt1;
                pt4=pt1;
            end
        else
            pt2=pt1;
            pt3=pt1;
            pt4=pt1;
        end
        if col>1
            if (row+1)<=1201
                pt5=A(row+1,col-1);
            else
                pt5=pt1;
            end
        else
            pt5=pt1;
        end
        diff=[abs(pt2-pt1),abs(pt3-pt1),abs(pt4-pt1),abs(pt5-pt1)];
        check=diff>el_threshold;
        if(sum(check)>0)
            lats(ind)=R.LatitudeLimits(2)-row/1201;
            lons(ind)=R.LongitudeLimits(1)+col/1201;
            ind=ind+1;
        end
    end
end
lats=lats(1,1:ind-1);
lons=lons(1,1:ind-1);
end