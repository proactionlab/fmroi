function contiguousclustering_gui(hObject)
% contiguousclustering_gui is a internal function of fMROI. It creates the
% panel and uicontrols for calling contiguousclustering function.
%
% Syntax:
%   contiguousclustering_gui(hObject)
%
% Inputs:
%   hObject: handle of the figure that contains the fMROI main window.
%
% Author: Andre Peres, 2019, peres.asc@gmail.com
% Last update: Andre Peres, 09/05/2022, peres.asc@gmail.com

handles = guidata(hObject);
%--------------------------------------------------------------------------
% creates the ROIs Panel
panelroi_pos = [0.01, 0.01, 0.98, 0.87];

handles.panel_roimethod = uipanel(handles.tab_genroi, 'BackgroundColor', 'c', ...
    'Units', 'normalized', 'Position', panelroi_pos, 'Visible', 'on');

%--------------------------------------------------------------------------
% creates the text for source image
guidata(hObject,handles)
imgname = getselectedimgname(hObject);

handles.text_roisourceimage = uicontrol(handles.panel_roimethod, 'Style', 'text',...
            'Units', 'normalized', 'String', ['Source image: ' imgname],...
            'BackgroundColor', 'w', 'FontSize', 9,...
            'HorizontalAlignment', 'left','Position', [0.01, 0.76, 0.98, 0.2]);
        
%--------------------------------------------------------------------------
% creates the text for radius/volume in voxels
handles.text_mincltsz = uicontrol(handles.panel_roimethod, 'Style', 'text',...
            'Units', 'normalized', 'String', 'min N voxels: ',...
            'BackgroundColor', 'w', 'FontSize', 9,...
            'HorizontalAlignment', 'right','Position', [0.45, 0.01, 0.20, 0.35]);
        
%--------------------------------------------------------------------------
% creates the edit text for radius/volume in voxels
handles.edit_mincltsz = uicontrol(handles.panel_roimethod, 'Style', 'edit',...
            'Units', 'normalized', 'String', '3',...
            'BackgroundColor', 'w', 'FontSize', 11,...
            'HorizontalAlignment', 'left','Position', [0.67, 0.01, 0.32, 0.35]);

guidata(hObject,handles)