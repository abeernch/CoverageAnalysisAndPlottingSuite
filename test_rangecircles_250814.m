clear; close all
pos = [33.6077;73.1040];
th = linspace(0,360,360);
r= 100:100:400;
f = figure;
g = geoaxes(f, "Basemap",'satellite');
g.MapCenter = pos.';
g.ZoomLevel = 12;
geoscatter(pos(1),pos(2),6,'r','filled')
%%
lat = cell(1,4);
lon = cell(1,4);
txt = cell(1,4);

for i = 1:length(r)
    [lat{i},lon{i}] = reckon(pos(1),pos(2),r(i),th,wgs84Ellipsoid("kilometer"));
    % xunit{i} = r(i) * cos(th) + pos(1);
    % yunit{i} = r(i) * sin(th) + pos(2);
    txt{i} = sprintf('%2.0f km',r(i));
    p = geoplot(g,lat{i}, lon{i},'LineStyle','--','LineWidth',1,'Color','k');
    text(max(lat{i})+0.1,mean(lon{i}),txt{i},"FontSize",8,"Color",'w',"FontWeight","bold", ...
        "HorizontalAlignment","center",'HitTest','off', 'PickableParts','none')
end
   
    
    hold on
    % axis equal

