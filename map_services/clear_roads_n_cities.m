function clear_roads_n_cities(map_handle)
delete(map_handle.UserData.roads.motorway);
delete(map_handle.UserData.roads.tertiary);
delete(map_handle.UserData.roads.secondary);
delete(map_handle.UserData.roads.primary);

delete(map_handle.UserData.cities);
delete(map_handle.UserData.towns.txt);
delete(map_handle.UserData.towns.pts);
delete(map_handle.UserData.villages.txt);
delete(map_handle.UserData.villages.pts);
delete(map_handle.UserData.airways);
end

%%

% function clear_roads_n_cities(map_handle)
% % Safe deletion of roads and city overlays
% 
% % Delete road layers if valid
% road_fields = {'motorway', 'primary', 'secondary', 'tertiary'};
% for i = 1:numel(road_fields)
%     h = map_handle.UserData.roads.(road_fields{i});
%     if ~isempty(h) && isvalid(h)
%         delete(h);
%     end
% end
% 
% % Delete city layer if valid
% if isfield(map_handle.UserData, 'cities')
%     h = map_handle.UserData.cities;
%     if ~isempty(h) && all(isvalid(h))
%         delete(h);
%     end
% end
% 
% % Delete town/village text and points if valid
% categories = {'towns', 'villages'};
% for i = 1:numel(categories)
%     cat = categories{i};
%     if isfield(map_handle.UserData, cat)
%         t = map_handle.UserData.(cat);
%         if isfield(t, 'txt') && any(isgraphics(t.txt))
%             delete(t.txt);
%         end
%         if isfield(t, 'pts') && any(isgraphics(t.pts))
%             delete(t.pts);
%         end
%     end
% end
% end
