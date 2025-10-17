fh = drawfreehand("Parent",app.map_axis,"Closed",true,"Multiclick",true,"Color", ...
[0.4667 0.6745 0.1882],"FaceAlpha",0.15,"FaceSelectable",true,"LabelAlpha",0.5, ...
"InteractionsAllowed","translate","StripeColor",[0.7882 0 0]);

lockmenu = uimenu('Parent',fh.ContextMenu,'Text','Lock Position', ...
    'MenuSelectedFcn',@(src,event) lockPosition(fh,1),'Accelerator','L');
unlockmenu = uimenu('Parent',fh.ContextMenu,'Text','Unlock Position', ...
    'MenuSelectedFcn',@(src,event) lockPosition(fh,0),'Accelerator','U');
polyreshape = uimenu('Parent',fh.ContextMenu,'Text','Enable Polygon Reshaping', ...
    'MenuSelectedFcn',@(src,event) polyreshape_fn(fh,1),'Accelerator','R');
cancelpolyreshape = uimenu('Parent',fh.ContextMenu,'Text','Disable Polygon Reshaping', ...
    'MenuSelectedFcn',@(src,event) polyreshape_fn(fh,0),'Accelerator','N');


fh.ContextMenu.Children(5).Text = 'Delete ROI';
fh.ContextMenu.Children(5).ForegroundColor = [0.8 0 0];
fh.UserData.lockmenu = lockmenu;
fh.UserData.unlockmenu = unlockmenu;
fh.UserData.polyreshape = polyreshape;
fh.UserData.cancelpolyreshape = cancelpolyreshape;
fh.UserData.unlockmenu.Visible = 'off';
fh.UserData.cancelpolyreshape.Visible = 'off';
fh.UserData.lockstate = 0;

%% Adding listener to update perimeter and area as the ROI is edited

l = addlistener(fh,'MovingROI',@(src,event) listener_updateROI(src));

%% Calculate and update area
a = areaint(fh.Position(:,1),fh.Position(:,2),wgs84Ellipsoid('km'));

%% Calculate and update perimeter/length of polygon/line
d = zeros(1,size(fh.Position,1));
fh.Position = [fh.Position;fh.Position(1,:)];
for i = 1:size(fh.Position,1)-1
d(i) = distance(fh.Position(i,1),fh.Position(i,2),fh.Position(i+1,1),fh.Position(i+1,2),wgs84Ellipsoid('km'));

end
perimeter = sum(d);

fh.Position(end,:) = [];

txt = sprintf('ROI 1: %0.3f sqkm\nPeri/L: %0.3f km',a,perimeter);

fh.Label = txt;
fh.LabelTextColor = 'w';
fh.LabelVisible ='hover';
%% Get top 5 highest elevation points in the region of interest
% Mesh spacing
[dlat,dlon] = deal(0.05,0.05); % 0.01 ~ 1.11m

lat = min(fh.Position(:,1)):dlat:max(fh.Position(:,1));
lon = min(fh.Position(:,2)):dlat:max(fh.Position(:,2));

% Create a neshgrid
[latgrid,longrid] =meshgrid(lat,lon);

% Check points inside the poolygon
in = inpolygon(longrid,latgrid,fh.Position(:,2),fh.Position(:,1));

% Masking points inside the polygon
lat = unique(latgrid(in));
lon = unique(longrid(in));

%% Prealocate final elevation array
el = zeros(length(lat),length(lon));
elmax = zeros(length(lat),1);
for p_lat = 1:length(lat)
    for p_lon = 1:length(lon)
        tx = txsite("Latitude",lat(p_lat),"Longitude",lon(p_lon));
       el(p_lat,p_lon) = elevation(tx,'Map','Pak_Master_3');
    end
    % elmax(p_lat) = max(el);
end

% Linearize the matrix and extract the top 5 elevations
t5 = maxk(el(:),5);

% Get indices for the extracted values to map the corresponding lat, lon
[r,c] = arrayfun(@(x) find(x==el),t5);

% Top elevation coords
t5Coords = [lat(r) lon(c)];

%% scatter plotting of detected peaks in the ROI
s = scatter('Parent',app.map_axis,t5Coords(:,1),t5Coords(:,2),'Marker','diamond','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','r');
s.UserData.t5el = t5;
cm = uicontextmenu('Parent',app.RAPSUIFigure);
s.ContextMenu = cm;
s.Tag = 't5peaks';
delmenu = uimenu('Parent',s.ContextMenu,'Text','Delete', 'MenuSelectedFcn',@(src,event) delete(s));
delmenu.Tooltip = 'Delete pointers';
delmenu.ForegroundColor = [0.8 0 0];
getinfomenu = uimenu('Parent',s.ContextMenu,'Text','Get Info', 'MenuSelectedFcn',@(src,event) getinfo(s));
getinfomenu.Tooltip = 'Copy data to clipboard';






