function pbutton_savescrsht_callback(hObject, ~)
% pbutton_savescrsht_callback is an internal function of fMROI.
%
% Syntax:
%   pbutton_savescrsht_callbackt(hObject,~)
%
% Inputs:
%   hObject: handle of the figure that contains the fMROI main window.
%
% Author: Andre Peres, 2023, peres.asc@gmail.com
% Last update: Andre Peres, 22/08/2023, peres.asc@gmail.com

handles = guidata(hObject);

% handles.pbutton_savescrsht
outfilename = get(handles.edit_outscrshtpath,'string');
[pn,fn,ext] = fileparts(outfilename);

% Save the visible axes to images
ax_tag = {'axi','cor','sag','vol'};
for i = 1:4
           
    ax = axes('Parent',handles.panel_graph(i),...
        'Box','off','Units','normalized','XTick',[],'YTick',[],...
        'color','none','Position',[0,0,1,1]);

    f = getframe(ax);
    im = frame2im(f);
    
    % removes white edges generated by getframe
    im(1:2,:,:) = [];
    im(end-1:end,:,:) = [];
    im(:,1:2,:) = [];
    im(:,end-1:end,:) = [];

    outfn = fullfile(pn,strcat(fn,'_',ax_tag{i},ext));
    imwrite(im,outfn)
    delete(ax);    
end

% Give feedback
% if exist(outfn,'file')
%     fmsg = msgbox("Saved!");
%     pause(3) ;
%     close(fmsg); clear(fmsg);
% end
% 
% a = 1; 