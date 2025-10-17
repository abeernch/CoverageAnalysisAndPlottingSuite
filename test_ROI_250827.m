f= figure;
a = axes;

cmap = flipud(colormap('turbo'));
fh = drawfreehand("Parent",a,"Closed",true,"Multiclick",true,"Color", ...
    cmap(1,:),"FaceAlpha",0.15,"FaceSelectable",true,"LabelAlpha",0.5, ...
    "InteractionsAllowed","translate","StripeColor",'r');

% lockmenu = uimenu('Parent',fh.ContextMenu,'Text','Lock ROI Polygon', ...
%     'MenuSelectedFcn',@(src,event) set(fh,'InteractionsAllowed','none'),"Accelerator",'L');
lockmenu = uimenu('Parent',fh.ContextMenu,'Text','Lock Position', ...
    'MenuSelectedFcn',@(src,event) lockPosition(fh,1),'Accelerator','L');
unlockmenu = uimenu('Parent',fh.ContextMenu,'Text','Unlock Position', ...
    'MenuSelectedFcn',@(src,event) lockPosition(fh,0),'Accelerator','U');



fh.UserData.lockmenu = lockmenu;
fh.UserData.unlockmenu = unlockmenu;
fh.UserData.unlockmenu.Visible = 'off';
fh.UserData.lockedpos = fh.Position;

% fh.UserData.positionListener = addlistener(fh, 'Position', 'PostSet', ...
%     @(src,event) enforceLockState(fh));

% function lockPosition(fh,lockstate)
% fh.UserData.lockstate = lockstate;
% if lockstate
%     set(fh.UserData.lockmenu,'Visible','off');
%     set(fh.UserData.unlockmenu,'Visible','on');
%     fh.FaceSelectable = 0;
% else
%     set(fh.UserData.lockmenu,'Visible','on');
%     set(fh.UserData.unlockmenu,'Visible','off')
%     fh.FaceSelectable = 1;
% end
% end
