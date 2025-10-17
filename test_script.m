% 
gx=gca;
cla(gx);
hold(gx,"on")
 h=drawfreehand(gx);
 lats=h.Position(:,1);
 lons=h.Position(:,2);
 % delete(h);
 for i=1:length(lats)
     lat=lats(i);
     lon=lons(i);
     p=geoplot(gx,lat,lon,'Marker','diamond','MarkerSize',10,'Color','red');
     l=geoplot(gx,lats(1:i),lons(1:i),'LineStyle','-','Color','blue');
     pause(0.05)
     delete(p);
     delete(l);
 end
% %% parf eval test
% 
% fprintf('parfeval test')
% p=backgroundPool;
% f=parfeval(p,@local_func,1,2);
% input_=0;
% while input_==0
% input_=input('press any key to cancle background process, press 0 to keep going\n');
% if input_>0
%     fprintf('cancelling service\n');
%     cancel(f)
% else
%     f.State
% end
% end
% 
% function x=local_func(x)
% while true
%     fprintf('local func: %.2f',x);
%     x=x+1;
%     pause(2);
% end
% end
%% Get the point coordinates from given tx at azimuth,distance and height
% function h=test_script(distance_in_km,rx_out,tx,azimuth,height)
%     arc_angle = rad2deg(distance_in_km*1000/earthRadius('m')); % create new rx site b/w current range and prev. range
%     [latOut,lonOut] = reckon(tx.Latitude, tx.Longitude,arc_angle,azimuth);
%     rx_out.Latitude=latOut;
%     rx_out.Longitude=lonOut;
%     el=elevation(rx_out,'Map','Pak_Master_2');
%     % rx_out.AntennaHeight=abs(height-el);
%     if el>height
%         rx_out.AntennaHeight=0;
%     else
%         rx_out.AntennaHeight=height-el;
%     end
%     h=rx_out.AntennaHeight;
% end
%% Cancelable diaglog test
% function test_script(app)
% % global continue_calculation
% continue_calculation=true;
% app.continue_calculation=continue_calculation;
% disp('start of function\n')
% % fig=figure;
% % w=uiprogressdlg(fig,"Cancelable","on","CancelText",'Cancel','Icon',[pwd '\icons\icon_nav.png'],'Message','Progress Bar','Value',0);
% w=waitbar(0,'calculation.','CreateCancelBtn',@cancel_callback,'Icon',[pwd '\icons\icon_nav.png'])
% max_count=0;
% while app.value<10
%     waitbar(app.value/10,w,'calculating')
%     % w.Value=app.value/10;
%     pause(1)
%     app.value=app.value+1;
%     if(app.continue_calculation==false) || max_count>20
%         app.continue_calculation=continue_calculation;
%         break;
%     end
%     max_count=max_count+1;
% end
% disp('the end\n')
% delete(w)
% end
%% script to get elevation data and save in excel files

% % 
% % %% 
% % 
% 
% % % pak_master_site=siteviewer('Basemap','darkwater','Terrain','Pak_Master_2');
% % % gmted_site=siteviewer('Basemap','darkwater',Terrain='gmted2010');
% % % 
% % % lat_limits=[30 33];
% % % lon_limits=[70 75];
% % % tx=txsite;
% % % iterations=1;
% % % total=((lat_limits(2)-lat_limits(1))/0.25)*((lon_limits(2)-lon_limits(1))/0.25);
% % % waitbar_h=waitbar(0,'computing elevations');
% % % dist_prev=0;
% % % for lat=lat_limits(1):0.25:lat_limits(2)
% % %     for lon=lon_limits(1):0.25:lon_limits(2)
% % %         tx.Latitude=lat;
% % %         tx.Longitude=lon;
% % %         tx2(iterations)=txsite(Latitude=lat,Longitude=lon);
% % %         el1=elevation(tx,'Map',pak_master_site);
% % %         el2=elevation(tx,'Map',gmted_site);
% % %         pak_master(iterations)=el1;
% % %         gmted_el(iterations)=el2;
% % %         lats(iterations)=lat;
% % %         lons(iterations)=lon;
% % %         iterations=iterations+1;
% % %         waitbar(iterations/total, waitbar_h);
% % %     end
% % %     waitbar((lat/5)/lat_limits(2), waitbar_h);
% % %     pause(0.2)
% % % end
% % % diff=abs(gmted_el-pak_master);
% % % col_names={'Lat','Lon','pak_master Elevation', 'GMTED Elevation', 'Abs Diff'};
% % % t=table(lats',lons',pak_master',gmted_el',diff','VariableNames',col_names);
% % % fprintf("points of calculations: %d\n",iterations);
% % % file='elevation_error.xlsx';
% % % writetable(t,file);
% % % close(waitbar_h)
% % % close(gmted_site);
% % % close(pak_master_site);
% % % show(tx2,'Map',pak_master_site)
% % 
% % % %% 
% % % height_index=5;
% % % az_data=zeros(60,3);
% % % heights=[2000 5000 10000 20000 30000];
% % % full_data=zeros(60,3,5);
% % % full_data(:,:,height_index)=az_data;
% % % tbl=array2table(az_data,'VariableNames',{'Azimuth','Latitude','Longitude'});
% % % tbl2=array2table(az_data,'VariableNames',{'Azimuth','Latitude','Longitude'});
% % % tbl3=array2table(az_data,'VariableNames',{'Azimuth','Latitude','Longitude'});
% % % tbl4=array2table(az_data,'VariableNames',{'Azimuth','Latitude','Longitude'});
% % % tbl5=array2table(az_data,'VariableNames',{'Azimuth','Latitude','Longitude'});
% % % tbl{1,1}=50;
% % % tbl2{1,2}=60;
% % % tbl3{1,3}=80;
% % % tbl4{1,1}=90;
% % % tbl5{1,2}=100;
% % % dir='D:\RCI_Data\prev_data';
% % % subfolder=string(lat)+","+string(lon);
% % % mkdir(dir,subfolder);
% % % file=string(dir)+"\"+subfolder+"\test.xlsx";
% % % writetable(tbl,file,WriteMode="replacefile",Sheet=string(heights(1))+"m");
% % % writetable(tbl2,file,WriteMode="append",Sheet=string(heights(2))+"m");
% % % writetable(tbl3,file,WriteMode="append",Sheet=string(heights(3))+"m");
% % % writetable(tbl4,file,WriteMode="append",Sheet=string(heights(4))+"m");
% % % writetable(tbl5,file,WriteMode="append",Sheet=string(heights(5))+"m");
% % 
% % 
% 
%% find dips
% %% Read DTED Files
% % clc, clear;
% % % w=waitbar(0,"finding files 0%%");
% % search_lat_lim_low=26;%28.5;
% % search_lat_lim_up=34;%32.7;
% % search_lon_lim_up=74.4;%75.5;%74.4;
% % search_lon_lim_low=71.1;%66;%71.1;
% % t1=tic;
% % parfor file_no=1:715
% %     file=string(file_no);
% %     if file_no<100
% %         file="0"+file;
% %         if file_no<10
% %             file="0"+file;
% %         end
% %     end
% %     file_path='D:/People/Shahzad Anwar Khan/RCI App/RCI/Master_DTEDs/Master';
% %     path=file_path+"/"+file+".dt1";
% %     % fprintf("%s\n",path);
% %     if(isfile(path))
% %         [A,R]=readgeoraster(path);
% %         lat_lims=R.LatitudeLimits;
% %         lon_lims=R.LongitudeLimits;
% %         lat_check=sum(lat_lims<search_lat_lim_up) && sum(lat_lims>search_lat_lim_low);
% %         lon_check=sum(lon_lims<search_lon_lim_up) && sum(lon_lims>search_lon_lim_low);
% %         if lat_check && lon_check
% %             [lats,lons]=find_dips(A,R);
% %             % file_no_str="file"+string(file_no);
% %             % dips_files.(file_no_str)={lats,lons};
% %             dips{file_no}={lats,lons};
% %         else
% %             dips{file_no}={};
% %         end
% %         % if lat_lims(1)==32% && 32<lat_lims(2)
% %         %     if lon_lims(2)==75% && 74<lon_lims(2)
% %         %         fprintf("lats in: %s \n",path);
% %         %     end
% %         % end
% %     else
% %         fprintf("missing: %s \n",path);
% %     end
% %     % p=file_no/715;
% %     % waitbar(p,w,sprintf("fiel search progress: %.2f %%",p*100));
% % end
% % toc(t1);
% % fprintf("*** all done with finding dips****\n")
% % breakpoint=0;
% % ind=1;
% % dips_found={};
% % for index=1:length(dips)
% %     dip=dips{index};
% %     if isempty(dip)
% %         continue;
% %     else
% %         if isempty(dip{1})
% %             continue;
% %         else
% %         dips_found{ind}=dip;
% %         ind=ind+1;
% %         end
% %     end
% % end
% 
% %% 

%% Function to get elevation from raw dted dta by lat/lon
% % function el=get_elevation(lat,lon,A,R)
% % if lat<=R.LatitudeLimits(2) && lat>=R.LatitudeLimits(1)
% %     if lon<=R.LongitudeLimits(2) && lon>=R.LongitudeLimits(1)
% % 
% %     lat_lim=R.LatitudeLimits(2);
% %     lon_lim=R.LongitudeLimits(1);
% %     y=int16((lat_lim-lat)*1201);
% %     if y==0 || y>1201
% %         if y==0
% %         y=1;
% %         else
% %             y=1201;
% %         end
% %     end
% %     x=int16((lon-lon_lim)*1201);
% %     if x==0 || x>1201
% %         if x==0
% %         x=1;
% %         else
% %             x=1201;
% %         end
% %     end
% %     el=A(y,x);
% %     else
% %         fprintf("longitude out of limit\n")
% %         el=0;
% %     end
% % else
% %         fprintf("latitude out of limit\n")
% %         el=0;
% % end
% % end
% %% 
%% Find dips to locate errors in our terrain data
% % function [lats,lons]=find_dips(A,R)
% % ind=1;
% % el_threshold=50;
% % % w=waitbar(0,"empthy");
% % lats=zeros(1,1201);
% % lons=zeros(1,1201);
% % for row=1:1201
% %     for col=1:1201
% %         pt1=A(row,col);
% %         if row>1
% %             pt2=A(row-1,col);
% %             if col>1
% %                 pt3=A(row,col-1);
% %                 pt4=A(row-1,col-1);
% %             else
% %                 pt3=pt1;
% %                 pt4=pt1;
% %             end
% %         else
% %             pt2=pt1;
% %             pt3=pt1;
% %             pt4=pt1;
% %         end
% %         if col>1
% %             if (row+1)<=1201
% %                 pt5=A(row+1,col-1);
% %             else
% %                 pt5=pt1;
% %             end
% %         else
% %             pt5=pt1;
% %         end
% %         diff=[abs(pt2-pt1),abs(pt3-pt1),abs(pt4-pt1),abs(pt5-pt1)];
% %         check=diff>el_threshold;
% %         if(sum(check)>0)
% %             lats(ind)=R.LatitudeLimits(2)-row/1201;
% %             lons(ind)=R.LongitudeLimits(1)+col/1201;
% %             ind=ind+1;
% %         end
% %     end
% %     % p=row/1200;
% %     % waitbar(p,w,sprintf("finding dips: %.2f %%",p*100));
% % end
% % lats=lats(1,1:ind-1);
% % lons=lons(1,1:ind-1);
% % % close(w);
% % end
% %% 
%%
% % function status=find_missing(A)
% %     rtr=false;
% %     for x=1:1201
% %         for y=1:1201
% %             if A(x,y)==-32767
% %                 fprintf("data miss : %d,%d \n",x,y);
% %                 rtr=true;
% %             end
% %         end
% %     end
% %     if rtr==true
% %         status=true;
% %     else status=false;
% %     end
% % end
%% 
% %% Test Classes and objects in Matlab
% % classdef test_script
% %     properties
% %         Lat=0;
% %         Lon=0;
% %         AntennaHeight=0;
% %         AGL=0;
% %     end
% %     methods
% %         function obj=test_script(lat,lon,antenna,agl)
% %             obj.Lat=lat;
% %             obj.Lon=lon;
% %             obj.AntennaHeight=antenna;
% %             obj.AGL=agl;
% %         end
% %     end
% % end
%%
% %% Test Listners  on figure objects
% % 
% % function test_script(src,event)
% %     disp('test_script called in \n');
% % end