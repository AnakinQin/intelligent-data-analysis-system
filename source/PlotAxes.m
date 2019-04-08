% ��������
function PlotAxes(File,index_plot,var,layout,x_label)


h_MainPlotFig = findobj('Tag','Main Plot Figure');
h_axes= findobj(h_MainPlotFig,'Type','axes');   % delete axes, change for ploting var in single figure
delete(h_axes);

color{1}='b';
color{2}='r';
color{3}=[0 0.5 0]; % text���ϣ���д���ַ���\color[rgb]{0 0.5 0}
color{4}='m';
color{5}='k';
color{6}=[0.3 0.3 0.3];% gray
color{7}=[1 0.5 0]; % orange
color{8}=[0 0.5 0.5]; % cyan
% color{9}=[0.3 0.0 0.7]; % ��ɫ
color{9}='g';
color{10}='y';
% % eight basic named colors (red, green, yellow, magenta, blue, black, white),
% % and plus four Simulink colors (gray, darkGreen, orange, and lightBlue)
colorstr{1}='blue';
colorstr{2}='red';
colorstr{3}='darkGreen'; % plot ���ϴ���ɫ
colorstr{4}='magenta';
colorstr{5}='black';
colorstr{6}='gray';
colorstr{7}='orange';
colorstr{8}='cyan';
colorstr{9}='green';
colorstr{10}='yellow';

property{1}='-';
property{2}='-';
property{3}='-';
property{4}='-';
property{5}='-';
property{6}='-';
property{7}='-';
property{8}='-';
property{9}='-';
property{10}='-';

figure(h_MainPlotFig);
filenamestr='';
for i=1:length(File)
    [pathstr, name, ext] = fileparts(File{i});
    %     Filename=[name, ext];
    %     if length(Filename)>30
    %         Filename=[Filename(1:30)];
    %     end
    filenamestr=[filenamestr,'\color{',colorstr{i},'}������',name,'  '];
end
filenamestr=strrep(filenamestr,'_','\_');
filenamestr=strrep(filenamestr,'^','\^');
axes('Parent',h_MainPlotFig,'Position',[0.2,0.976,0.6,0.02],'Visible','off');
text(0.5,0.2,filenamestr,'FontName','Arial Unicode MS','FontWeight','bold','Interpreter','tex','HorizontalAlignment','center');




%%
% �����Ҽ��˵�
rightclickmenu=uicontextmenu;
uimenu(rightclickmenu,'Tag','label1','label','�Ա�����','callback',@CompareLine);
uimenu(rightclickmenu,'Tag','label2','label','�����ƻ�ͼ','callback',@PlotBinary);
%��������ʱ��ƽ�ƹ���Anakin.Qin20180109
uimenu(rightclickmenu,'Tag','label3','label','ʱ��ƽ��','callback',@ShiftPlot);


h_MainPlotFig = findobj('Tag','Main Plot Figure');
xlim_property=get(h_MainPlotFig,'Userdata');

nvar_selected=length(index_plot);
haxes=zeros(nvar_selected,1);
for iFile=1:length(File)
    x=var{iFile}.xdata;
    xlen=length(x);
    for ivar_selected=1:nvar_selected
        %%%%%%%%%%%%%%%%%%%
        y=var{iFile}.Data(index_plot(ivar_selected),:);
        %%%%%%%%%%%%%%%%%%%
        %%%APM���ݻ�ͼ
        if isfield(var{iFile},'label')
            y=y{1};
            ned=index_plot(ivar_selected);
            k=1;
            ff=0;
            while k<length(var{iFile}.label)
                %den=var{iFile}.label(k)-k;
                if ned+1<var{iFile}.label(2)
                    % added by Anakin.Qin 20181101 all totally is to debug
                    % the right button functione when you click the mouse
                    % right button, and chose the variable to be the x
                    % label parameters, the structure of the idasdata.xdata
                    % would be different from the original xdata array
                    % So, when the x label is no longer the time var, we
                    % should do care about the structure of itself.
                    if xlen~=1
                        x=var{iFile}.xdata{1};
                    else
                        x=x{1};
                    end
                    temp_str=var{iFile}.logfeq(1);
                    ff=1;
                elseif ned+k>var{iFile}.label(k) && ned+k<var{iFile}.label(k+1)
                    if xlen~=1
                        x=var{iFile}.xdata{k};
                    else
                        x=x{1};
                    end
                    temp_str=var{iFile}.logfeq(k);
                    ff=1;
                elseif ned+length(var{iFile}.label)>var{iFile}.label(length(var{iFile}.label))
                    if xlen~=1
                        x=var{iFile}.xdata{length(var{iFile}.label)};
                    else
                        x=x{1};
                    end
                    temp_str=var{iFile}.logfeq(length(var{iFile}.label));
                    ff=1;
                end
                if ff==1
                    break;
                end
                k=k+1;
            end
        end
        if iFile==1  % add for saving time
            PositionMatrix=Coordinate(ivar_selected,layout);
            haxes(ivar_selected)=axes('Parent',h_MainPlotFig,'Position',PositionMatrix,'ButtonDownFcn',@axes_ButtonDownFcn,...
                'FontSize',8,'Box','on','NextPlot','add','xlim',xlim_property); %replace 'datacursormode on'
            grid on
            if strcmp(x_label(end),')')%APM data contain time and log frequence
                temp_str=num2str(temp_str);
                x_label_dsp=strcat(x_label,'_',temp_str,'Hz');
                xlabel(x_label_dsp,'VerticalAlignment','middle','FontName','Verdana','FontSize',9,'Interpreter','none');%���Ӵ���ʾX����
            else
                xlabel(x_label,'VerticalAlignment','middle','FontName','Verdana','FontSize',9,'FontWeight','bold','Interpreter','none');%Arial Unicode MS,Verdana
            end
            ylabel(var{iFile}.varlist{index_plot(ivar_selected)} ,'VerticalAlignment','middle','FontName','Verdana','FontSize',9,'FontWeight','bold','Interpreter','none');  % top|cap|middle|baseline|bottom
        end
        plot(haxes(ivar_selected),x,y,property{iFile},'Color',color{iFile},'LineWidth',1,'Tag','line','ButtonDownFcn',@line_buttondownfcn,'UIContextMenu',rightclickmenu);
    end
    clear x y
end
linkaxes(haxes,'x');
%%



%----------------ButtonDownFcn--------------
function line_buttondownfcn(varargin)

h1=findobj(gca,'Tag','datatip');
h2=findobj(gca,'Tag','datatipmarker');
delete(h1);
delete(h2);


findNearestLine;
gcaUserdata=get(gca,'UserData');
if gcaUserdata.hNearestLine==-1
    return;  % pointer is too far from any line
end
set(gcf,'WindowButtonMotionFcn',@createdatatip);
set(gcf,'WindowButtonUpFcn',@WindowButtonUpFcn);

%----------------ButtonDownFcn--------------
function axes_ButtonDownFcn(hobj,varargin)


line_buttondownfcn;


%----------------ButtonUpFcn----------------
function WindowButtonUpFcn(varargin)

set(gca,'UserData',[]);
set(gcf,'WindowButtonMotionFcn','');



% --- Executes when right-click on line.
function CompareLine(varargin)

findNearestLine;
gcaUserdata=get(gca,'UserData');
xlabelStr=get(get(gca,'Xlabel'),'String');
ylabelStr=get(get(gca,'Ylabel'),'String');
Xlim=get(gca,'Xlim');

handles.fig=findobj('Tag','CompareLine');
if isempty(handles.fig)
    handles.fig=figure('Tag','CompareLine',...
        'Name','�����Աȴ���',...
        'NumberTitle','off',...
        'MenuBar','none',...
        'Units','normalized',...
        'Position',[0.3,0.3,0.5,0.5]);
    chgicon(handles.fig,'network.png');
    %������ʹ��icondata.mat�ļ�����������exe
    [new,Print,Refresh,Layout,Axis,Copy,Zoom,First,Previous,Next,Last,Search,lineSize,Lookup,Pan,Datacursor,AIicon]=load_icondata();
%     load icondata.mat
    handles.customtoolbar=uitoolbar(handles.fig,'Tag','CompareLineToolBar');
    handles.Copy=uipushtool(handles.customtoolbar,'CData',Copy,...
        'TooltipString','Copy','Separator','on','ClickedCallback','print -dmeta');
    handles.Zoom=uitoggletool(handles.customtoolbar,'CData',Zoom,...
        'TooltipString','Zoom','Separator','on','OnCallback',@zoomon,'OffCallback',@zoomoff);
    handles.SetLineWidth=uipushtool(handles.customtoolbar,'CData',lineSize,...
        'TooltipString','�ı��߿�','Separator','on','ClickedCallback',@SetLineWidth);
    handles.Pan=uitoggletool(handles.customtoolbar,'CData',Pan,...
        'TooltipString','Pan','Separator','on','OnCallback','pan xon','OffCallback','pan off');
    
    handles.axes=axes('Parent',handles.fig,'Tag','compare axes','Position',[0.07 0.08 0.9 0.85],'ButtonDownFcn',@axes_ButtonDownFcn,...
        'FontSize',8,'Box','on','NextPlot','add');
    xlabel(xlabelStr,'FontName','Verdana','FontSize',9,'FontWeight','bold','Interpreter','none');%Arial Unicode MS,Verdana
    title('�����Ա�','FontName','Verdana','FontSize',12,'FontWeight','bold');
    Userdata.LineNumber=0;
    Userdata.LineWidth=1;
    Userdata.LegendStr='';
    set(handles.axes,'Userdata',Userdata);
else
    handles.axes=findobj(handles.fig,'Tag','compare axes');
    figure(handles.fig); % makes the figure identified by h the current figure,
end

new_handle=copyobj(gcaUserdata.hNearestLine,handles.axes);
Userdata=get(handles.axes,'Userdata');
LineWidth=Userdata.LineWidth;
LineNumber=Userdata.LineNumber+1;
Userdata.LineNumber=LineNumber;
Userdata.LegendStr{Userdata.LineNumber}=ylabelStr;
legend(handles.axes,Userdata.LegendStr,'Location','NorthEast','Interpreter','none') ;
set(handles.axes,'Userdata',Userdata);
color{1}='b';
color{2}='r';
color{3}=[0 0.5 0]; % text���ϣ���д���ַ���\color[rgb]{0 0.5 0}
color{4}='m';
color{5}='k';
set(new_handle,'Color',color{LineNumber},'LineWidth',LineWidth)
set(handles.axes,'Xlim',Xlim);
grid on


% --- �����߿� ---
function SetLineWidth(varargin)

hlines=findobj(gca,'Type','line');
LineWidth=get(hlines(1),'LineWidth');
if LineWidth==1
    set(hlines,'LineWidth',2);
else
    set(hlines,'LineWidth',1);
end


%----------------------subfunction------------------
function zoomon(varargin)
zoom on;
set(gcbo,'State','on');

%----------------------subfunction------------------
function zoomoff(varargin)
zoom off;
set(gcbo,'State','off');


% --- Executes when right-click on line.
function PlotBinary(varargin)

xlabelStr=get(get(gca,'Xlabel'),'String');
ylabelStr=get(get(gca,'Ylabel'),'String');
hlines=findobj(gca,'Type','line');
hlines=sort(hlines,'ascend');% ��������
xdata=get(hlines,'Xdata');
ydata=get(hlines,'Ydata');
if iscell(ydata)
    nline=length(ydata);
else
    xdata={xdata};
    ydata={ydata};
    nline=1;
end


handles.figBinary=findobj('Tag','PlotBinary figure');
if isempty(handles.figBinary)
    handles.figBinary=figure('Tag','PlotBinary figure',...
        'Name','�����ƻ�ͼ����',...
        'NumberTitle','off',...
        'MenuBar','none',...
        'Units','normalized',...
        'Position',[0.3,0.3,0.5,0.5]);
    chgicon(handles.figBinary,'network.png');
    %������ʹ��icondata.mat�ļ�����������exe
    [new,Print,Refresh,Layout,Axis,Copy,Zoom,First,Previous,Next,Last,Search,lineSize,Lookup,Pan,Datacursor,AIicon]=load_icondata();
%     load icondata.mat
    handles.customtoolbar=uitoolbar(handles.figBinary,'Tag','CompareLineToolBar');
    handles.Copy=uipushtool(handles.customtoolbar,'CData',Copy,...
        'TooltipString','Copy','Separator','on','ClickedCallback','print -dmeta');
    handles.Zoom=uitoggletool(handles.customtoolbar,'CData',Zoom,...
        'TooltipString','Zoom','Separator','on','OnCallback',@zoomon,'OffCallback',@zoomoff);
    handles.SetLineWidth=uipushtool(handles.customtoolbar,'CData',lineSize,...
        'TooltipString','�ı��߿�','Separator','on','ClickedCallback',@SetLineWidth);
else
    figure(handles.figBinary); % makes the figure identified by h the current figure,
    handles.axes= findobj(handles.figBinary,'Type','axes');   % delete axes, change for ploting var in single figure
    delete(handles.axes);
end
handles.axes=axes('Parent',handles.figBinary,'Tag','PlotBinary axes','Position',[0.07 0.08 0.9 0.85],'ButtonDownFcn',@axes_ButtonDownFcn,...
    'FontSize',8,'Box','on','NextPlot','add');

color{1}='b';
color{2}='r';
color{3}=[0 0.5 0]; % text���ϣ���д���ַ���\color[rgb]{0 0.5 0}
color{4}='m';
color{5}='k';

for i=1:nline
    yin=uint32(ydata{i});
    yin=reshape(yin,[],1);
    str = dec2bin(max(yin)); % str ����Ϊ char
    xbit=1:length(str);
    tic
    yout=cell2mat(arrayfun(@(bit)uint32(bitget(yin,bit).*bit),xbit,'UniformOutput',0 ));toc
    %     stairs(xdata{i},yout,'-','linew',2,'Color',color{i},'LineWidth',1);
    plot(handles.axes,xdata{i},yout,'-','Color',color{i},'LineWidth',1);
end
grid on
xlabel(xlabelStr,'FontName','Verdana','FontSize',9,'FontWeight','bold','Interpreter','none');%Arial Unicode MS,Verdana
ylabel(ylabelStr,'FontName','Verdana','FontSize',9,'FontWeight','bold','Interpreter','none');%Arial Unicode MS,Verdana

% --- Executes when right-click on line.
function ShiftPlot(varargin)

a=1;

