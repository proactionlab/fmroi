function fmroi()
% fMROI is a software dedicated to create ROIs in fMRI images...
%
% Syntax: fmroi
%
% Author: Andre Peres, 2019, peres.asc@gmail.com
% Last update: Andre Peres, 09/05/2022, peres.asc@gmail.com

clear global
set(0,'units','pixels');
scnsize = get(0,'screensize');
figw = ceil(scnsize(3)*0.9);
figh = floor(scnsize(4)*0.8);
[fmroirootdir,~,~] = fileparts(mfilename('fullpath'));

addpath(fullfile(fmroirootdir,'callback'),...
    fullfile(fmroirootdir,'gui'),...
    fullfile(fmroirootdir,'methods'));

addpath(genpath(fullfile(fmroirootdir,'toolbox')));
addpath(genpath(fullfile(fmroirootdir,'roimethods')));

tmpdir = fullfile(fmroirootdir,'tmp');
if exist(tmpdir,'dir')
    rmdir(tmpdir, 's');
end
mkdir(tmpdir);

templatedir = fullfile(fmroirootdir,'templates');
if ~exist(templatedir,'dir')
   mkdir(templatedir);
end
handles.tpldir = templatedir;
% templatestruc = dir(templatedir);
% tpldirstruc = templatestruc([templatestruc(:).isdir]);
% tpldirstruc = tpldirstruc(~startsWith({tpldirstruc(:).name},'.'));
% templatedirname = {tpldirstruc(:).name};


% Figure creation
% hObject is the handle to the figure
hObject = figure('Name', 'Parameters Detection', 'Color', [255 255 255]/255, ...
    'MenuBar', 'none', 'ToolBar', 'none',... , 'CloseRequestFcn', @close_signalhunter,...
    'DockControls', 'off', 'NumberTitle','off','Render','opengl', 'Visible', 'off');

set(hObject, 'Units', 'Pixels', 'Position', [0 0 figw figh],'windowbuttonmotionfcn',@mousemove);
% center the figure window on the screen
movegui(hObject, 'center');

%--------------------------------------------------------------------------
% creates the menu bar 1 with 1 submenu
hmenufile = uimenu('Label', 'File', 'Parent', hObject);

%--------------------------------------------------------------------------
% creates the File submenus
hmenufile_open = uimenu(hmenufile, 'Label', 'Open',...
    'Callback', @menufile_open_callback);

handles.hmenufile_templates(1) = uimenu(hmenufile, 'Label', 'Load Template');

%--------------------------------------------------------------------------
% Create the templates submenus automatically
guidata(hObject,handles);
updatemenutemplate(hObject);
handles = guidata(hObject);
%--------------------------------------------------------------------------

hmenufile_roi = uimenu(hmenufile, 'Label', 'Load ROIs',...
    'Callback', @menufile_roiopen_callback);

hmenufile_exit = uimenu(hmenufile, 'Label', 'Exit',...
    'Callback', @menufile_exit_callback);

%--------------------------------------------------------------------------
% creates the menu bar 2 with 1 submenu
hmenuconfig = uimenu('Label', 'Config', 'Parent', hObject);

hmenuconfig_dplres = uimenu(hmenuconfig, 'Label', 'Display resolution');%,...
%     'Callback', @menufile_open_callback);

hmenuconfig_imptpl = uimenu(hmenuconfig, 'Label', 'Import template',...
     'Callback', @menuconfig_imptpl_callback);
% hmenuconfig_imptpl_file = uimenu(hmenuconfig_imptpl, 'Label', 'Files',...
%     'Callback', @menuconfig_imptpl_callback);
% 
% hmenuconfig_imptpl_file = uimenu(hmenuconfig_imptpl, 'Label', 'Folder',...
%     'Callback', @menuconfig_imptpl_callback);

hmenuconfig_cleartpl = uimenu(hmenuconfig,'Label','Clear template folder',...
    'Callback', @menuconfig_cleartpl_callback);

hmenuconfig_restoretpl = uimenu(hmenuconfig,'Label','Restore default templates',...
    'Callback', @menuconfig_restoretpl_callback);

hmenuconfig_improifun = uimenu(hmenuconfig, 'Label', 'Import ROI function',...
    'Callback', @menuconfig_improifun_callback);

hmenuconfig_restoreroifun = uimenu(hmenuconfig, 'Label', 'Restore default ROI functions',...
    'Callback', @menuconfig_restoreroifun_callback);

%--------------------------------------------------------------------------
% creates the menu bar 3 with 1 submenu
hmenutools = uimenu('Label', 'Tools', 'Parent', hObject);

%--------------------------------------------------------------------------
% creates the menu bar 4 with 1 submenu
hmenuhelp = uimenu('Label', 'Help', 'Parent', hObject);
hmenuhelp_showquickguide = uimenu(hmenuhelp,'Label','Show quick guide',...
    'Callback', @menuhelp_showquickguide_callback);
handles.menuhelp_showctrlpanel = uimenu(hmenuhelp,...
    'Label','Show Control Panel','Enable','off',...
    'Callback', @menuhelp_showctrlpanel_callback);

%--------------------------------------------------------------------------
% creates the Axes Panel

panelgraph_pos = [0.26, 0.01, 0.73, 0.98];

handles.panel_graph = uipanel(hObject, 'BackgroundColor', 'k', ...
    'Units', 'normalized', 'Visible', 'on', 'Position', panelgraph_pos);

%--------------------------------------------------------------------------
% creates the Control Panel and Welcome panel
panelcontrol_pos = [0.01, 0.01, 0.24, 0.98];

handles.panel_logo = uipanel(hObject, 'BackgroundColor', 'w', ...
    'Units', 'normalized', 'Position', panelcontrol_pos);

handles.panel_control = uipanel(hObject, 'BackgroundColor', 'w', ...
    'Units', 'normalized', 'Position', panelcontrol_pos);

%--------------------------------------------------------------------------
% creates the Welcome text
wt = {'\bf\fontsize{14}     Welcome to fMROI Apha 1.0.0';...
    '\fontsize{10} ';...
    'fMROI\rm is a free software designed to create regions of';...
    'interest (ROI) in functional magnetic resonance imaging';...
    '(fMRI). However, it is not limited to fMRI, and can be used';...
    'with structural images, diffusion maps (DTI), or even with';...
    'atlases such as FreeSurfer aparc-aseg and Julich atlas.';...
    '';...
    'To load an image, the users have three alternatives:';...
    '1. by clicking on \bfFile>Open menu\rm, to open a nifti file';...
    '(functional, structural, DTI, etc.);';...
    '2. by clicking on the menu \bfFile>Load ROI\rm to open a';...
    'binary nifti file and automatically use it as ROI;';...
    '3. clicking on \bfFile>Load Template\rm to open one of the';...
    'templates installed in fMROI.';...'
    'After loading the image, users can create and manipulate';...
    'ROIs in the tabs at the bottom of the control panel. To';...
    'create an ROI, the user must click on the \bfGen ROI\rm tab,';...
    'select the method from the popup menu, adjust the';...
    'parameters and when ready, click on the \bfGen ROI\rm button.';...
    'After this procedure the generated ROI will appear in the';...
    '\bfROI Table\rm tab, as well as an image will appear in the list';...
    'of loaded images (\bfroi\_under-construction.nii\rm ).';...
    'To save the ROIs, the user must select the \bfBin Mask\rm';...
    'checkbox to save each ROI as an independent mask, or';...
    '\bfAtlas+LUT\rm to save all the ROIs in the same image and ';...
    'click on the \bfSave\rm buttom at the botton of \bfROI Table\rm tab.';...
    '';...
    'For the complete documentation:';...
    'https://github.com/Proaction-Lab/fmroi'};

textwelcomepos = [0.01, 0.35, 0.98, 0.64];
annotation(handles.panel_logo,'textbox','Position',textwelcomepos,...
    'String',wt,'EdgeColor',[.8 .8 .8]);

%--------------------------------------------------------------------------
% creates the Logo axis and text
axeslogo_pos = [0.2545,0.12,0.4711,0.2000];

axes('Parent', handles.panel_logo,'Position',axeslogo_pos, 'Box', 'off',...
                'Units', 'normalized','XTick', [],'YTick', []);
            
imshow(fullfile(fmroirootdir,'etc','figs','fmroi_logo.png'))

logocaption = {'Developed by members and colaborators of';...
    'Proaction Lab - FPCE, University of Coimbra';...
    'Rua do Colégio Novo - 3001-802 Coimbra, Portugal';...
    'https://proactionlab.fpce.uc.pt'};

textlogopos = [0.01, 0.01, 0.98, 0.09];
handles.textlogo = uicontrol(handles.panel_logo, 'Style', 'text',...
    'Units', 'normalized', 'String', logocaption,...
    'BackgroundColor', [1 1 1], 'FontSize', 10,...
        'HorizontalAlignment', 'center','Position', textlogopos);
    
%--------------------------------------------------------------------------
% creates the Control Panel objects
guidata(hObject,handles);
create_panel_mainctrl(hObject);
handles = guidata(hObject);

set(handles.panel_control,'Visible','off');
%--------------------------------------------------------------------------
% Set the objects to handles

handles.fig = hObject;
handles.fmroirootdir = fmroirootdir;
handles.tmpdir = tmpdir;
handles.hmenufile = hmenufile;
handles.hmenuhelp = hmenuhelp;
handles.hsubopen = hmenufile_open;
% handles.hsub2open = hmenufile_templates2;
% handles.hsub3open = hmenufile_templates3;
handles.hsubexit = hmenufile_exit;
handles.config_dir = [];


set(hObject,'Visible','on');

% Update handles structure
guidata(hObject,handles);

function menufile_exit_callback(hObject, ~)
handles = guidata(hObject);
selection = questdlg('Do you want to exit fMROI?',...
      'Exit fMROI',...
      'Yes','No','Yes'); 
   switch selection 
      case 'Yes'
         delete(handles.fig)
      case 'No'
      return
   end
% close(handles.fig)
