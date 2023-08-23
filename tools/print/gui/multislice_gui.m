function multislice_gui(hObject)
% multislice_gui is an internal function of fMROI.
%
% Syntax:
%   multislice_gui(hObject)
%
% Inputs:
%   hObject: handle of the figure that contains the fMROI main window.
%
% Author: Andre Peres, 2023, peres.asc@gmail.com
% Last update: Andre Peres, 22/08/2023, peres.asc@gmail.com

handles = guidata(hObject);
fss = handles.fss; % font size scale

if isfield(handles,'panel_scrshtctrl')
    if isobject(handles.panel_scrshtctrl)
        if isvalid(handles.panel_scrshtctrl)
            delete(handles.panel_scrshtctrl)
        end
    end
end


%--------------------------------------------------------------------------
% creates a new blank panel screenshot controls
handles.panel_scrshtctrl = uipanel(handles.panel_tools,...
    'BackgroundColor','w','Units','normalized',...
    'Position',[.01,.01,.98,.56]);

%--------------------------------------------------------------------------
%creates the edit text for the number of slices
handles.text_scrshtnslices = uicontrol(handles.panel_scrshtctrl,...
    'Style','text','Units','normalized',...
    'String','Slices','BackgroundColor','w',...
    'FontUnits','normalized','FontSize',fss*.7,...
    'Position',[.01,.84,.32,.15],'HorizontalAlignment','right');

handles.edit_scrshtnslices = uicontrol(handles.panel_scrshtctrl,...
    'Style','edit','Units','normalized','String','5',...
    'FontUnits','normalized','FontSize',fss*.7,'BackgroundColor','w',...
    'HorizontalAlignment','center','Position', [.34,.84,.15,.15]);

%--------------------------------------------------------------------------
%creates the edit text for the initial slice
handles.text_scrshtinitslice = uicontrol(handles.panel_scrshtctrl,...
    'Style','text','Units','normalized',...
    'String','Init slice','BackgroundColor','w',...
    'FontUnits','normalized','FontSize',fss*.7,...
    'Position',[.67,.84,.32,.15],'HorizontalAlignment','left');

handles.edit_scrshtinitslice = uicontrol(handles.panel_scrshtctrl,...
    'Style','edit','Units','normalized','String','30',...
    'FontUnits','normalized','FontSize',fss*.7,'BackgroundColor','w',...
    'HorizontalAlignment','center','Position', [.51,.84,.15,.15]);

%--------------------------------------------------------------------------
%creates the edit text for the last slice
handles.text_scrshtlastslice = uicontrol(handles.panel_scrshtctrl,...
    'Style','text','Units','normalized',...
    'String','Last slice','BackgroundColor','w',...
    'FontUnits','normalized','FontSize',fss*.7,...
    'Position',[.67,.68,.32,.15],'HorizontalAlignment','left');

handles.edit_scrshtlastslice = uicontrol(handles.panel_scrshtctrl,...
    'Style','edit','Units','normalized','String','70',...
    'FontUnits','normalized','FontSize',fss*.7,'BackgroundColor','w',...
    'HorizontalAlignment','center','Position',[.51,.68,.15,.15]);

%--------------------------------------------------------------------------
% Creates the dropdown menu to select the axis to screenshot
handles.text_scrshtax = uicontrol(handles.panel_scrshtctrl,...
    'Style','text','Units','normalized',...
    'String','Target axis','BackgroundColor','w',...
    'FontUnits','normalized','FontSize',fss*.7,...
    'Position',[.01,.45,.49,.15],'HorizontalAlignment','right');


handles.popup_scrshtax = uicontrol(handles.panel_scrshtctrl,...
    'Style','popup','Units','normalized','Position',[.515,.48,.3,.13],...
    'String',{'Axial';'Coronal';'Sagittal'},...
    'FontUnits','normalized','FontSize',fss*.75,'background','w');

%--------------------------------------------------------------------------
%creates the edit text for the overlap percentage
handles.text_scrshtoverlap = uicontrol(handles.panel_scrshtctrl,...
    'Style','text','Units','normalized',...
    'String','Overlap','BackgroundColor','w',...
    'FontUnits','normalized','FontSize',fss*.7,...
    'Position',[.01,.22,.5,.15],'HorizontalAlignment','right');

handles.edit_multioverlap = uicontrol(handles.panel_scrshtctrl,...
    'Style','edit','Units','normalized','String','1',...
    'FontUnits','normalized','FontSize',fss*.7,'BackgroundColor','w',...
    'HorizontalAlignment','center','Position',[.52,.22,.15,.15],...
    'Callback',@edit_multioverlap_callback);

%--------------------------------------------------------------------------
% creates the slider overlap
spos = [.2,.07,.6,.1];

handles.slider_multioverlap = uicontrol(handles.panel_scrshtctrl,...
    'Style','slider','Tag','slider_multi','Units','normalized',...
    'Position',spos,'Value',1);

addlistener(handles.slider_multioverlap,'Value','PostSet',...
    @(src,evnt)listener_multioverlap_callback...
    (src,evnt,handles.slider_multioverlap));

 
handles.text_scrshtoverlapmin = uicontrol(handles.panel_scrshtctrl,...
    'Style','text','Units','normalized','String','-1',...
    'FontUnits','normalized','FontSize',fss*.7,'BackgroundColor', 'w',...
    'HorizontalAlignment','right','Position',...
    [.01,...
    spos(2)-.03,...
    spos(1)-.02,...
    .15]);
    
handles.text_scrshtoverlapmax = uicontrol(handles.panel_scrshtctrl,...
    'Style','text','Units','normalized','String','1',...
    'FontUnits','normalized','FontSize',fss*.7,'BackgroundColor','w',...
    'HorizontalAlignment','left','Position',...
    [spos(1)+spos(3)+.01,...
    spos(2)-.03,...
    .98-(spos(1)+spos(3)),...
    .15]);


guidata(hObject,handles)
