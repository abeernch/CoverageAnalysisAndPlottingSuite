function listener_updateROI(fh)

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

txt = sprintf('%s: %0.3f sqkm\nPeri/L: %0.3f km',fh.UserData.label,a,perimeter);

fh.Label = txt;
fh.LabelTextColor = 'w';
fh.LabelVisible ='hover';
end