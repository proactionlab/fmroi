function multislice(hObject,~)

handles = guidata(hObject);

if isfield(handles,'panel_graphmulti')
    if isobject(handles.panel_graphmulti)
        if isvalid(handles.panel_graphmulti)
            delete(handles.panel_graphmulti)
        end
    end
    handles = updatehandles(handles);
end


panelgraph_pos = [0.26, 0.01,.73,.98];

handles.panel_graphmulti = uipanel(gcf, 'BackgroundColor','k',...
        'Units','normalized','Visible','on',...
        'Position',panelgraph_pos,'Visible','off');

if isfield(handles,'axannot')
    if isobject(handles.axannot)
        if isvalid(handles.axannot)
            
            axannotvis = zeros(...
                size(handles.axannot,1),size(handles.axannot,2));
            for i = 1:size(handles.axannot,1)
                for j = 1:size(handles.axannot,2)
                    axannotvis(i,j) = get(handles.axannot(i,j),'Visible');
                    set(handles.axannot(i,j),'Visible','off')
                end
            end

        end
    end
end
n = 10;
s = round(linspace(20,70,n));
p = .6;

w = 1/(p*(n-1)+1);
h = 1;

for i = 1:n
    x = (i-1)*w*p;
    y = 0;

    handles.multiax(i) = axes('Parent', handles.panel_graphmulti,...
        'Position',[x,y,w,h],'Units','normalized',...
        'Box','off','XTick',[],'YTick',[],'Color','none');

    set(handles.edit_pos(2,3),'String',num2str(s(i)))
    editpos_callback(handles.edit_pos(2,3),[])

    pos = GetLayoutInformation(handles.ax{1,1}.ax);
    rect = pos.PlotBox - [0,0,2,2];
    rect(1:2) = 1;

    f = getframe(handles.ax{1,1}.ax,rect);
    im = frame2im(f);
    d = image(im,'Parent',handles.multiax(i));

    a = (sum(im,3))>0;
    d.AlphaData = a;

    set(handles.multiax(i),'XLimMode','auto','YLimMode','auto',...
            'XTick',[],'YTick',[],'Color','none',...
            'XColor','none','YColor','none');

    
    axis image
end

set(handles.panel_graphmulti,'Visible','on');

if isfield(handles,'axannot')
    if isobject(handles.axannot)
        if isvalid(handles.axannot)
            
            for i = 1:size(handles.axannot,1)
                for j = 1:size(handles.axannot,2)
                    set(handles.axannot(i,j),'Visible',axannotvis(i,j));
                end
            end

        end
    end
end

guidata(hObject,handles)

% delete(panel_graphmulti)
