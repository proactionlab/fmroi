function listener_maxcolor_callback(~, eventdata, hObject)
% listener_maxcolor_callback is an internal function of fMROI.
%
% Syntax:
%   listener_maxcolor_callback(~, eventdata, hObject)
%
% Inputs:
%     hObject: handle of the figure that contains the fMROI main window.
%   eventdata: conveys information about changes or actions that occurred
%              within the slider_maxcolor.
%
% Author: Andre Peres, 2019, peres.asc@gmail.com
% Last update: Andre Peres, 09/05/2022, peres.asc@gmail.com

global st
handles = guidata(hObject);
n = handles.table_selectedcell(1);
hpos = get(hObject,'Position');
value = get(eventdata.AffectedObject, 'Value');

thrs = value*(st.vols{n}.clim(2)-st.vols{n}.clim(1))+...
            st.vols{n}.clim(1);

imgthrs_str = sprintf('%0.2g',thrs);
imgthrs_str(imgthrs_str=='+')=[];

set(handles.edit_maxcolorupdate,'String', imgthrs_str,...
    'Position',...
    [(value*.56+.22),...
    hpos(2)+hpos(4),...
    0.14,...
    0.02]);