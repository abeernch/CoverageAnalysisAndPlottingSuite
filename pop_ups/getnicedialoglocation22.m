function figure_size = getnicedialoglocation(figure_size, figure_units)
% adjust the specified figure position to fig nicely over GCBF
% or into the upper 3rd of the screen

%  Copyright 1999-2020 The MathWorks, Inc.

figure_size = matlab.ui.internal.dialog.DialogUtils.centerWindowToFigure(figure_size, figure_units);
