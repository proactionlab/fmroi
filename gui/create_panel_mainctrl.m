function create_panel_mainctrl(hObject)
% create_panel_mainctrl is a internal function of fMROI dedicated to create
% the panel and uicontrols for manipulating the images parameters (display,
% threshold, alpha, etc).
%
% Syntax:
%   create_panel_mainctrl(hObject)
%
% Inputs:
%   hObject: handle of the figure that contains the fMROI main window.
%
% Author: Andre Peres, 2019, peres.asc@gmail.com
% Last update: Andre Peres, 09/05/2022, peres.asc@gmail.com

handles = guidata(hObject);

%==========================================================================
% Main image control
%==========================================================================
%--------------------------------------------------------------------------
% creates the ListBox with images names
listpos = [0.01, 0.82, 0.98, 0.17];

handles.table_listimg = uitable(handles.panel_control,'Units','normalized',...
    'Position',listpos, 'Data', [],...
    'ColumnName', {'View', 'Value','Image name'},...
    'ColumnFormat', {'logical','char','char'},...
    'ColumnEditable', [true true true],...
    'RowName',[],...
    'BackgroundColor',[1 1 1],...
    'ForegroundColor',[0 0 0],...
    'CellEditCallback',@table_listimg_editcallback,...
    'CellSelectionCallback',@table_listimg_selcallback);

set(handles.table_listimg,'units','pixel')
tw = handles.table_listimg.Position(3);
cw = {.1*tw,.15*tw,.75*tw};

txt = sprintf('Line 1\nLine 2');
set(handles.table_listimg,'units','normalized','ColumnWidth',cw,'Tooltip',txt)


%--------------------------------------------------------------------------
% creates the checkbox rendering
handles.checkbox_rendering = uicontrol(handles.panel_control, 'Style', 'checkbox',...
    'Units', 'normalized','Position', [0.01, 0.79, 0.14, 0.02],'Value',0,...
    'String','3D','FontUnits','normalized', 'FontSize', .9,...
    'BackgroundColor', 'w','Callback',@checkbox_rendering_callback);

%--------------------------------------------------------------------------
% creates the colormap dropdown menu
handles.popup_colormap = uicontrol(handles.panel_control, 'Style', 'popup',...
    'Units', 'normalized','Position', [0.165, 0.775, 0.2, 0.039],...
    'String', {'popup'},'FontUnits','normalized', 'FontSize', .4,...    
    'background','w','Callback',@popup_colormap_callback);


colorpath = fullfile(matlabroot,'toolbox','matlab','graphics','color');
if exist(colorpath, 'dir')
    colordir = dir(colorpath);
    cmaps = cell(length(colordir),1);
    
    for i = 1:size(colordir)
        if length(colordir(i).name) > 2
            cmaps{i} = colordir(i).name(1:end-2);
        else
            cmaps{i} = colordir(i).name;
        end
    end
    cmaps{1} = 'custom';
    cmaps{2} = 'colorLUT';
else
    cmaps{1} = 'custom';
    cmaps{2} = 'colorLUT';
    cmaps{3} = 'cool';
    cmaps{4} = 'gray';
    cmaps{5} = 'jet';
    cmaps{6} = 'parula';
end

set(handles.popup_colormap,'String',cmaps)

%--------------------------------------------------------------------------
% creates the ROI color dropdown menu
handles.popup_roicolor = uicontrol(handles.panel_control,...
    'Style','popup','Units','normalized',...
    'Position', [0.37, 0.775, 0.2, 0.039],...
    'FontUnits','normalized','FontSize',.4,'background','w',...
    'Callback',@popup_roicolor_callback);

roicmaps{1} = 'red';
roicmaps{2} = 'green';
roicmaps{3} = 'blue';
roicmaps{4} = 'yellow';
roicmaps{5} = 'cyan';
roicmaps{6} = 'magenta';
roicmaps{7} = 'black';
roicmaps{8} = 'white';
roicmaps{9} = 'custom';

set(handles.popup_roicolor,'String',roicmaps)

%--------------------------------------------------------------------------
% creates the cursor pushbutton
handles.pbuttoncross.obj = uicontrol(handles.panel_control,...
    'Style','PushButton',...
    'Units', 'normalized','Position', [0.575, 0.775, 0.1, 0.04],...
    'String','+','FontUnits','normalized','FontSize',.5,...
    'ForeGroundColor',[1 0 0],'Callback',@pbuttoncross_callback);
handles.pbuttoncross.action = 1;

%--------------------------------------------------------------------------
% creates the delete pushbutton
handles.pbutton_delete = uicontrol(handles.panel_control,...
    'Style','PushButton',...
    'Units','normalized','Position',[0.68, 0.775, 0.1, 0.04],...
    'String','Del','FontUnits','normalized','FontSize',.4,...
    'Callback',@pbutton_delete_callback);

%--------------------------------------------------------------------------
% creates the move image up pushbutton
uparrow = double(imread(fullfile(handles.fmroirootdir,'etc','figs','move_up.png')))/255;
a = sum(uparrow,3)==0;
upalpha = cat(3,a,a,a);
uparrow(upalpha) = nan;
handles.pbutton_imgup = uicontrol(handles.panel_control,...
    'Style','PushButton',...
    'Units','normalized','Position',[0.785, 0.775, 0.1, 0.04],...
    'CData',uparrow,...'String','Up','FontUnits','normalized','FontSize',.4,...
    'Callback',@pbutton_imgup_callback);

%--------------------------------------------------------------------------
% creates the move image down pushbutton
downarrow = double(imread(fullfile(handles.fmroirootdir,'etc','figs','move_down.png')))/255;
a = sum(downarrow,3)==0;
 downalpha= cat(3,a,a,a);
downarrow(downalpha) = nan;
handles.pbutton_imgdown = uicontrol(handles.panel_control,...
    'Style','PushButton',...
    'Units','normalized','Position',[0.89, 0.775, 0.1, 0.04],...
    'CData',downarrow,...'String','Down','FontUnits','normalized','FontSize',.4,...
    'Callback',@pbutton_imgdown_callback);

%==========================================================================
% Position edit text control
%==========================================================================
%--------------------------------------------------------------------------
% creates the Edit and Text ui with image position
w = .14; % text width (.21)
h = .03; % text height
lpos = .22; % text left position (.01)
bpos = .69; % text botton position
textlabel = {'Scanner:';...
             'Voxel Nat:'};

for i = 1:2
    textpos = [.67, (i-1)*(h+.01)+bpos, .32, h];
    
    handles.text_pos(i) = uicontrol(handles.panel_control,...
        'Style','text','Units','normalized','Position',textpos,...
        'String','','FontUnits','normalized','FontSize',.4,...
        'BackgroundColor', [.9 .9 .9],'HorizontalAlignment', 'center');
    
    textlabelpos = [.01, (i-1)*(h+.01)+bpos, .21, h];
    
    handles.text_poslabel(i) = uicontrol(handles.panel_control,...
        'Style','text','Units','normalized','Position',textlabelpos,...
        'String',textlabel{i},'FontUnits','normalized','FontSize',.4,...
        'BackgroundColor','w','HorizontalAlignment', 'left');
    
    for j = 1:3
        
        editpos = [(j-1)*(w+.0067)+lpos, (i-1)*(h+.01)+bpos, w, h];
        
        handles.edit_pos(i,j) = uicontrol(handles.panel_control, ...
            'Style','edit','Units','normalized','Position',editpos,...
             'String','','FontUnits','normalized','FontSize',.4,...
            'BackgroundColor','w','HorizontalAlignment','left',...
            'Tag',['edit',num2str(i),num2str(j)],...
            'Callback',@editpos_callback);
    end
end

%==========================================================================
% Slider block
%==========================================================================
%--------------------------------------------------------------------------
% creates the Edit and Text ui with image position

sw = .7; % sliders width
sh = .02; % sliders height
slpos = .22; % botton slider left position
sbpos = .38; % botton slider botton position
sdist = .05; % distance between 2 sliders (botton to botton)

%--------------------------------------------------------------------------
% creates the Slider Min threshold
slider_thrs_pos = [slpos, (sbpos+5*sdist), sw, sh];

handles.slider_minthrs = uicontrol(handles.panel_control,'Style','slider',...
    'Tag','slider_thrs','Units','normalized','FontUnits','normalized',...
    'Position', slider_thrs_pos,'Callback',@slider_thrs_callback);

addlistener(handles.slider_minthrs ,'Value', 'PostSet',...
    @(src,evnt)listener_minthrs_callback(src,evnt,handles.slider_minthrs));

 
handles.text_minthrslabel = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', 'Min thrs:',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [0.01,...
    slider_thrs_pos(2)+slider_thrs_pos(4),...
    slider_thrs_pos(1)-.01,...
    0.02]);

handles.edit_minthrs0 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '0',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'right','Position',...
    [0.01,...
    slider_thrs_pos(2),...
    slider_thrs_pos(1)-.01,...
    0.02]);

removeeditborder(handles.edit_minthrs0, 0)

    
handles.edit_minthrs100 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '1',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [slider_thrs_pos(1)+slider_thrs_pos(3),...
    slider_thrs_pos(2),...
    .08,...
    0.02]);

removeeditborder(handles.edit_minthrs100, 0)
    
handles.text_expminthrs100 = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', '',...
    'BackgroundColor', 'w',...
    'HorizontalAlignment', 'left','Position',...
    [slider_thrs_pos(1)+slider_thrs_pos(3),...
    slider_thrs_pos(2)-.02,...
    .08,...
    0.02]);


handles.edit_minthrsupdate = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', num2str(handles.slider_minthrs.Value),...
    'BackgroundColor', 'w','Callback',@edit_sliderupdate_callback,...
    'HorizontalAlignment', 'center','Tag','edit_minthrsupdate','Position',...
    [(handles.slider_minthrs.Value*.56+.22),...
    slider_thrs_pos(2)+slider_thrs_pos(4),...
    .14,...
    0.02]);
removeeditborder(handles.edit_minthrsupdate, 1)
    
%--------------------------------------------------------------------------
% creates the Slider Max threshold

slider_maxthrs_pos = [slpos, (sbpos+4*sdist), sw, sh];

handles.slider_maxthrs = uicontrol(handles.panel_control,'Style','slider',...
    'Tag','slider_thrs','Units','normalized','FontUnits','normalized',...
    'Position', slider_maxthrs_pos,'Value',1,...
    'Callback',@slider_maxthrs_callback);

addlistener(handles.slider_maxthrs ,'Value', 'PostSet',...
    @(src,evnt)listener_maxthrs_callback(src,evnt,handles.slider_maxthrs));

 
handles.text_maxthrslabel = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', 'Max thrs:',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [0.01,...
    slider_maxthrs_pos(2)+slider_maxthrs_pos(4),...
    slider_maxthrs_pos(1)-.01,...
    0.02]);

handles.edit_maxthrs0 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '0',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'right','Position',...
    [0.01,...
    slider_maxthrs_pos(2),...
    slider_maxthrs_pos(1)-.01,...
    0.02]);

removeeditborder(handles.edit_maxthrs0, 0)
    
handles.edit_maxthrs100 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '1',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [slider_maxthrs_pos(1)+slider_maxthrs_pos(3),...
    slider_maxthrs_pos(2),...
    .08,...
    0.02]);

removeeditborder(handles.edit_maxthrs100, 0)

handles.text_expmaxthrs100 = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', '',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [slider_maxthrs_pos(1)+slider_maxthrs_pos(3),...
    slider_maxthrs_pos(2)-.02,...
    .08,...
    0.02]);
    
handles.edit_maxthrsupdate = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', num2str(handles.slider_maxthrs.Value),...
    'BackgroundColor', 'w','Callback',@edit_sliderupdate_callback,...
    'HorizontalAlignment', 'center','Tag','edit_maxthrsupdate','Position',...
    [(handles.slider_maxthrs.Value*.56+.22),...
    slider_maxthrs_pos(2)+slider_maxthrs_pos(4),...
    .14,...
    0.02]);

removeeditborder(handles.edit_maxthrsupdate, 1)
    
%--------------------------------------------------------------------------
% creates the Slider Alpha
slider_alpha_pos = [slpos, (sbpos+3*sdist), sw, sh];

handles.slider_alpha = uicontrol(handles.panel_control,'Style','slider',...
    'Tag','slider_alpha','Units','normalized','FontUnits','normalized',...
    'Position', slider_alpha_pos,'Value',1,...
    'Callback',@slider_alpha_callback);

addlistener(handles.slider_alpha ,'Value', 'PostSet',...
    @(src,evnt)listener_slicealpha_callback(src,evnt,handles.slider_alpha));

 
handles.text_slicealphalabel = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', 'Slices opac:',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [0.01,...
    slider_alpha_pos(2)+slider_alpha_pos(4),...
    slider_alpha_pos(1)-.01,...
    0.02]);

handles.edit_slicealpha0 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '0',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'right','Position',...
    [0.01,...
    slider_alpha_pos(2),...
    slider_alpha_pos(1)-.01,...
    0.02]);

removeeditborder(handles.edit_slicealpha0, 0)
    
handles.edit_slicealpha100 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '1',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [slider_alpha_pos(1)+slider_alpha_pos(3),...
    slider_alpha_pos(2),...
    .08,...
    0.02]);

removeeditborder(handles.edit_slicealpha100, 0)

handles.text_expslicealpha100 = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', '',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [slider_alpha_pos(1)+slider_alpha_pos(3),...
    slider_alpha_pos(2)-.02,...
    .08,...
    0.02]);
    
handles.edit_slicealphaupdate = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', num2str(handles.slider_alpha.Value),...
    'BackgroundColor', 'w','Callback',@edit_sliderupdate_callback,...
    'HorizontalAlignment', 'center','Tag','edit_slicealphaupdate','Position',...
    [(handles.slider_alpha.Value*.56+.22),...
    slider_alpha_pos(2)+slider_alpha_pos(4),...
    .14,...
    0.02]);

removeeditborder(handles.edit_slicealphaupdate, 1)    

%--------------------------------------------------------------------------
% creates the Slider ROI Alpha
slider_roialpha_pos = [slpos, (sbpos+2*sdist), sw, sh];

handles.slider_roialpha = uicontrol(handles.panel_control,'Style','slider',...
    'Tag','slider_alpha','Units','normalized','FontUnits','normalized',...
    'Position', slider_roialpha_pos,'Value',1,...
    'Callback',@slider_roialpha_callback);

addlistener(handles.slider_roialpha ,'Value', 'PostSet',...
    @(src,evnt)listener_roialpha_callback(src,evnt,handles.slider_roialpha));

 
handles.text_roialphalabel = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', 'Render opac:',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [0.01,...
    slider_roialpha_pos(2)+slider_roialpha_pos(4),...
    slider_roialpha_pos(1)-.01,...
    0.02]);

handles.edit_roialpha0 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '0',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'right','Position',...
    [0.01,...
    slider_roialpha_pos(2),...
    slider_roialpha_pos(1)-.01,...
    0.02]);

removeeditborder(handles.edit_roialpha0, 0)
    
handles.edit_roialpha100 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '1',...
    'BackgroundColor', 'w',...
    'HorizontalAlignment', 'left','Position',...
    [slider_roialpha_pos(1)+slider_roialpha_pos(3),...
    slider_roialpha_pos(2),...
    .08,...
    0.02]);

removeeditborder(handles.edit_roialpha100, 0)

handles.text_exproialpha100 = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', '',...
    'BackgroundColor', 'w',...
    'HorizontalAlignment', 'left','Position',...
    [slider_roialpha_pos(1)+slider_roialpha_pos(3),...
    slider_roialpha_pos(2)-.02,...
    .08,...
    0.02]);
    
handles.edit_roialphaupdate = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', num2str(handles.slider_roialpha.Value),...
    'BackgroundColor', 'w','Callback',@edit_sliderupdate_callback,...
    'HorizontalAlignment', 'center','Tag','edit_roialphaupdate','Position',...
    [(handles.slider_roialpha.Value*.56+.22),...
    slider_roialpha_pos(2)+slider_roialpha_pos(4),...
    .14,...
    0.02]);

removeeditborder(handles.edit_roialphaupdate, 1)

%--------------------------------------------------------------------------
% creates the Slider Min level colormap
slider_mincolor_pos = [slpos, (sbpos+sdist), sw, sh];

handles.slider_mincolor = uicontrol(handles.panel_control,'Style','slider',...
    'Tag','slider_alpha','Units','normalized','FontUnits','normalized',...
    'Position', slider_mincolor_pos,'Value',0,...
    'Callback',@slider_mincolor_callback);

addlistener(handles.slider_mincolor ,'Value', 'PostSet',...
    @(src,evnt)listener_mincolor_callback(src,evnt,handles.slider_mincolor));

 
handles.text_mincolorlabel = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', 'Min color:',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [0.01,...
    slider_mincolor_pos(2)+slider_mincolor_pos(4),...
    slider_mincolor_pos(1)-.01,...
    0.02]);

handles.edit_mincolor0 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '0',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'right','Position',...
    [0.01,...
    slider_mincolor_pos(2),...
    slider_mincolor_pos(1)-.01,...
    0.02]);

removeeditborder(handles.edit_mincolor0, 0)
    
handles.edit_mincolor100 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '1',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [slider_mincolor_pos(1)+slider_mincolor_pos(3),...
    slider_mincolor_pos(2),...
    .08,...
    0.02]);

removeeditborder(handles.edit_mincolor100, 0)

handles.text_expmincolor100 = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', '',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [slider_mincolor_pos(1)+slider_mincolor_pos(3),...
    slider_mincolor_pos(2)-.02,...
    .08,...
    0.02]);
    
handles.edit_mincolorupdate = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', num2str(handles.slider_mincolor.Value),...
    'BackgroundColor', 'w','Callback',@edit_sliderupdate_callback,...
    'HorizontalAlignment', 'center','Tag','edit_mincolorupdate','Position',...
    [(handles.slider_mincolor.Value*.56+.22),...
    slider_mincolor_pos(2)+slider_mincolor_pos(4),...
    .14,...
    0.02]);

removeeditborder(handles.edit_mincolorupdate, 1)

%--------------------------------------------------------------------------
% creates the Slider Max level colormap
slider_maxcolor_pos = [slpos, sbpos, sw, sh];

handles.slider_maxcolor = uicontrol(handles.panel_control,'Style','slider',...
    'Tag','slider_alpha','Units','normalized','FontUnits','normalized',...
    'Position', slider_maxcolor_pos,'Value',1,...
    'Callback',@slider_maxcolor_callback);

addlistener(handles.slider_maxcolor ,'Value', 'PostSet',...
    @(src,evnt)listener_maxcolor_callback(src,evnt,handles.slider_maxcolor));

 
handles.text_maxcolorlabel = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', 'Max color:',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [0.01,...
    slider_maxcolor_pos(2)+slider_maxcolor_pos(4),...
    slider_maxcolor_pos(1)-.01,...
    0.02]);

handles.edit_maxcolor0 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '0',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'right','Position',...
    [0.01,...
    slider_maxcolor_pos(2),...
    slider_maxcolor_pos(1)-.01,...
    0.02]);

removeeditborder(handles.edit_maxcolor0, 0)
    
handles.edit_maxcolor100 = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', '1',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [slider_maxcolor_pos(1)+slider_maxcolor_pos(3),...
    slider_maxcolor_pos(2),...
    .08,...
    0.02]);

removeeditborder(handles.edit_maxcolor100, 0)

handles.text_expmaxcolor100 = uicontrol(handles.panel_control, 'Style', 'text',...
    'Units', 'normalized', 'String', '',...
    'BackgroundColor', 'w',... 'FontSize', 11,...
    'HorizontalAlignment', 'left','Position',...
    [slider_maxcolor_pos(1)+slider_maxcolor_pos(3),...
    slider_maxcolor_pos(2)-.02,...
    .08,...
    0.02]);
    
handles.edit_maxcolorupdate = uicontrol(handles.panel_control, 'Style', 'edit',...
    'Units', 'normalized', 'String', num2str(handles.slider_maxcolor.Value),...
    'BackgroundColor', 'w','Callback',@edit_sliderupdate_callback,...
    'HorizontalAlignment', 'center','Tag','edit_maxcolorupdate','Position',...
    [(handles.slider_maxcolor.Value*.56+.22),...
    slider_maxcolor_pos(2)+slider_maxcolor_pos(4),...
    .14,...
    0.02]);

removeeditborder(handles.edit_maxcolorupdate, 1)

guidata(hObject,handles);