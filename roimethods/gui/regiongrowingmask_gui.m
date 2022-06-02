function regiongrowingmask_gui(hObject)
% regiongrowingmask_gui is a internal function of fMROI. It creates the
% panel and uicontrols for calling regiongrowingmask function.
%
% Syntax:
%   regiongrowingmask_gui(hObject)
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

handles.panel_roimethod = uipanel(handles.tab_genroi, 'BackgroundColor', 'w', ...
    'Units', 'normalized', 'Position', panelroi_pos, 'Visible', 'on');

%--------------------------------------------------------------------------
% creates the text for source image
guidata(hObject,handles)
imgname = getselectedimgname(hObject);
guidata(hObject,handles);
imgnamelist = getimgnamelist(hObject);

handles.text_roisrcimagetxt = uicontrol(handles.panel_roimethod, 'Style', 'text',...
            'Units', 'normalized','FontWeight','bold', 'String', 'Source image:',...
            'BackgroundColor', 'w', 'FontSize', 9,...
            'HorizontalAlignment', 'left','Position', [0.01, 0.91, 0.3, .07]);
        
handles.text_roisrcimage = uicontrol(handles.panel_roimethod, 'Style', 'text',...
            'Units', 'normalized', 'String', imgname,...
            'BackgroundColor', 'w', 'FontSize', 9,...
            'HorizontalAlignment', 'left','Position', [0.01, 0.84, 0.98, 0.07]);


%--------------------------------------------------------------------------
% creates the Radio Button Group in panel_roi  

handles.buttongroup_spheremasktype = uibuttongroup(handles.panel_roimethod,...
    'BackgroundColor', 'w', 'Units', 'normalized',...
    'Position', [0.01, 0.72, 0.48, 0.1]);
%--------------------------------------------------------------------------
% creates the spheremasktype radio button radius
handles.radio_sphereradius = uicontrol(...
    handles.buttongroup_spheremasktype, 'Style', 'radiobutton',...
    'Units', 'normalized','Position', [0.01, 0.1, 0.4, 0.8],...
    'String','Sphere', 'BackgroundColor', 'w',...
    'Callback',@radiobutton_masksphere_callback);

%--------------------------------------------------------------------------
% creates the spheremasktype radio button volume
handles.radio_spherevolume = uicontrol(...
    handles.buttongroup_spheremasktype, 'Style', 'radiobutton',...
    'Units', 'normalized','Position', [0.45, 0.1, 0.55, 0.8],...
    'String','Mask image', 'BackgroundColor', 'w',...
    'Callback',@radiobutton_maskimage_callback);

%--------------------------------------------------------------------------
% creates the text for number of voxels in the ROI
handles.text_roinvox = uicontrol(handles.panel_roimethod, 'Style', 'text',...
            'Units', 'normalized', 'String', 'Size (voxels):',...
            'BackgroundColor', 'w', 'FontSize', 9,...
            'HorizontalAlignment', 'right','Position', [0.01, 0.62, 0.22, 0.07]);
        
%--------------------------------------------------------------------------
% creates the edit text for number of voxels in the ROI
handles.edit_roinvox = uicontrol(handles.panel_roimethod, 'Style', 'edit',...
            'Units', 'normalized', 'String', '50',...
            'BackgroundColor', 'w', 'FontSize', 11,...
            'HorizontalAlignment', 'left','Position', [0.23, 0.62, 0.25, 0.08]);
        
%--------------------------------------------------------------------------
% creates the text for radius/volume in voxels
handles.text_roiradius = uicontrol(handles.panel_roimethod, 'Style', 'text',...
            'Units', 'normalized', 'String', 'Radius:',...
            'BackgroundColor', 'w', 'FontSize', 9,...
            'HorizontalAlignment', 'right','Position', [0.01, 0.52, 0.22, 0.07]);
        
        
%--------------------------------------------------------------------------
% creates the edit text for radius/volume in voxels
handles.edit_roiradius = uicontrol(handles.panel_roimethod, 'Style', 'edit',...
            'Units', 'normalized', 'String', '3',...
            'BackgroundColor', 'w', 'FontSize', 11,...
            'HorizontalAlignment', 'left','Position', [0.23, 0.52, 0.25, 0.08]);
        

%--------------------------------------------------------------------------
% creates the text for radius/volume in voxels
handles.text_maskimg = uicontrol(handles.panel_roimethod, 'Style', 'text',...
            'Units', 'normalized', 'String', 'Mask image:',...
            'BackgroundColor', 'w', 'FontSize', 9,...
            'HorizontalAlignment', 'left',...
            'Position', [0.01, 0.52, 0.3, 0.07],'Visible', 'off');
        

%--------------------------------------------------------------------------
% creates the ROI type dropdown menu
handles.popup_maskimg = uicontrol(handles.panel_roimethod, 'Style', 'popup',...
    'Units', 'normalized','Position', [0.01, 0.41, 0.98, 0.1],...
    'background','w');

set(handles.popup_maskimg,'String',imgnamelist,'Visible', 'off')

guidata(hObject,handles)