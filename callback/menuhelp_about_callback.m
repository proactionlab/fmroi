function menuhelp_about_callback(hObject,~)
% menuhelp_about_callback is an internal function of fMROI.
%
% Syntax:
%   menuhelp_about_callback(hObject,~)
%
% Inputs:
%   hObject: handle of the figure that contains the fMROI main window.
%
% Author: Andre Peres, 2023, peres.asc@gmail.com
% Last update: Andre Peres, 30/08/2023, peres.asc@gmail.com

handles = guidata(hObject);

%--------------------------------------------------------------------------
% delete panel_about
if isfield(handles,'panel_about')
    if isobject(handles.panel_about)
        if isvalid(handles.panel_about)
            delete(handles.panel_about)
        end
    end
    handles = updatehandles(handles);
end

%--------------------------------------------------------------------------
% generate a new blank panel_about
panelgraph_pos = [0.26, 0.01,.73,.98];

handles.panel_about = uipanel(handles.fig,'BackgroundColor','w',...
    'Units','normalized','Position',panelgraph_pos);


%--------------------------------------------------------------------------
% creates the title bar

handles.text_toolstitlebar = uicontrol(handles.panel_about,...
    'Style','text','Units','normalized','FontWeight','normal',...
    'String','About fMROI','BackgroundColor',[.9,.9,.9],...
    'FontUnits','normalized','FontSize',.65,...
    'HorizontalAlignment','center','Position',[0,.96,1,.04]);

%--------------------------------------------------------------------------
% creates the close icon pushbutton
handles.pbutton_panelaboutcloseicon = uicontrol(handles.panel_about,...
    'Style','PushButton','Units','normalized',...
    'FontUnits','normalized','FontSize',.8,'String','x',...
    'BackgroundColor','r','ForeGroundColor','w','FontWeight','bold',...
    'Position',[.97,.965,.025,.03],'HorizontalAlignment','center',...
    'Callback',@pbutton_panelaboutclose_callback);

%--------------------------------------------------------------------------
% creates the close pushbutton
handles.pbutton_panelaboutclose = uicontrol(handles.panel_about,...
    'Style','PushButton','Units','normalized',...
    'FontUnits','normalized','FontSize',.6,'String','Close',...
    'BackgroundColor','w','ForeGroundColor','k',...
    'Position',[.58,0.05,.14,.05],'HorizontalAlignment','center',...
    'Callback',@pbutton_panelaboutclose_callback);

%--------------------------------------------------------------------------
% creates the web doc pushbutton
handles.pbutton_panelaboutclose = uicontrol(handles.panel_about,...
    'Style','PushButton','Units','normalized',...
    'FontUnits','normalized','FontSize',.6,'String','Web doc',...
    'BackgroundColor','w','ForeGroundColor','k',...
    'Position',[.43,0.05,.14,.05],'HorizontalAlignment','center',...
    'Callback',@(src,event)web(handles.webdoc));

%--------------------------------------------------------------------------
% creates the github pushbutton
handles.pbutton_panelaboutclose = uicontrol(handles.panel_about,...
    'Style','PushButton','Units','normalized',...
    'FontUnits','normalized','FontSize',.6,'String','Go github',...
    'BackgroundColor','w','ForeGroundColor','k',...
    'Position',[.28,0.05,.14,.05],'HorizontalAlignment','center',...
    'Callback',@(src,event)web(handles.github));

%--------------------------------------------------------------------------
% creates the axis logo
axeslogo_pos = [0.375,0.55,0.25,0.3];

handles.axislogoabout = axes('Parent', handles.panel_about,'Position',axeslogo_pos, 'Box', 'off',...
    'Units', 'normalized','XTick', [],'YTick', []);
            
imshow(fullfile(handles.fmroirootdir,'etc','figs','fmroi_logo.png'))

set(handles.axislogoabout, 'Tag', 'axislogoabout')

%--------------------------------------------------------------------------
% creates the about texts
handles.fmroiversion = uicontrol(handles.panel_about,'Style','text',...
    'Units','normalized','BackgroundColor','w',...
    'String',handles.version,'FontUnits','normalized',...
    'FontSize',.5,'FontAngle','italic','FontWeight','bold',...
    'HorizontalAlignment','center','Position',[.1,.4,.8,.1]);
    jh = findjobj(handles.fmroiversion);
    jh.setVerticalAlignment(javax.swing.JLabel.CENTER) % Java fix due uicontrol missing vertical alignment property

handles.textlogoabout = uicontrol(handles.panel_about,'Style','text',...
    'Units','normalized','BackgroundColor','w','Position',[.1,.3,.8,.1],...
    'String','User-Friendly ROI Creation and Neuroimage Visualization Software',...
    'HorizontalAlignment','center','FontUnits','normalized',...
    'FontSize',.25,'FontAngle','italic','FontWeight','bold');

textabout = {'Developed by Andre Peres (peres.asc@gmail.com)';...
    'Proaction Lab - FPCE, University of Coimbra';...
    'https://proactionlab.fpce.uc.pt';...
    ' ';...
    ['Documentation: ',handles.webdoc];...
    ['Project github: ',handles.github]};

handles.textabout = uicontrol(handles.panel_about, 'Style', 'text',...
    'Units', 'normalized', 'String', textabout,'FontUnits','normalized',...
    'BackgroundColor', 'w', 'FontSize', .1,'FontAngle','italic',...
        'HorizontalAlignment', 'center','Position', [.2,.1,.6,.2]);

guidata(handles.fig,handles);
