function varargout = pixelselect(varargin)
% PIXELSELECT MATLAB code for pixelselect.fig
%      PIXELSELECT, by itself, creates a new PIXELSELECT or raises the existing
%      singleton*.
%
%      H = PIXELSELECT returns the handle to a new PIXELSELECT or the handle to
%      the existing singleton*.
%
%      PIXELSELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PIXELSELECT.M with the given input arguments.
%
%      PIXELSELECT('Property','Value',...) creates a new PIXELSELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pixelselect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pixelselect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pixelselect

% Last Modified by GUIDE v2.5 18-Aug-2016 14:17:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pixelselect_OpeningFcn, ...
                   'gui_OutputFcn',  @pixelselect_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before pixelselect is made visible.
function pixelselect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pixelselect (see VARARGIN)

% Choose default command line output for pixelselect
handles.output = hObject;

cla(handles.plot,'reset');

handles.rawdata=getappdata(0,'rawdata');
handles.qxv=getappdata(0,'qx');
handles.qyv=getappdata(0,'qy');
handles.qzv=getappdata(0,'qz');
handles.qparav=getappdata(0,'qpara');
handles.q=getappdata(0,'q');
handles.ImageDirection=getappdata(0,'imagedirection');

set(handles.dbxpixel,'String','');
set(handles.dbypixel,'String','');
set(handles.qx,'String','');
set(handles.qy,'String','');
set(handles.qz,'String','');
set(handles.qpara,'String','');

handles.NumXpixel = length(handles.rawdata(1,:,1)); % pixels in x-direction
handles.NumYpixel = length(handles.rawdata(:,1,1)); % pixels in y-direction

switch(handles.ImageDirection)
    case 'vert'
        handles.h=imagesc([max(handles.qyv(1,:)) min(handles.qyv(1,:))],[max(handles.qxv(:,1)) min(handles.qxv(:,1))],handles.rawdata(:,:,1),'Parent',handles.plot);
        xlabel('qy');
        ylabel('qx');
    case 'horz'
        handles.h=imagesc([min(handles.qyv(1,:)) max(handles.qyv(1,:))],[min(handles.qxv(:,1)) max(handles.qxv(:,1))],handles.rawdata(:,:,1),'Parent',handles.plot);
        xlabel('qy');
        ylabel('qx');
    case 'trans'
        handles.h=imagesc([min(handles.qxv(1,:)) max(handles.qxv(1,:))],[max(handles.qyv(:,1)) min(handles.qyv(:,1))],handles.rawdata(:,:,1),'Parent',handles.plot);
        xlabel('qx');
        ylabel('qy');
end

set(handles.h,'ButtonDownFcn',@plot_ButtonDownFcn);

switch(handles.ImageDirection)
    case 'vert'
        hold on
        handles.marker1=plot([0,0,Inf,min(handles.qyv(1,:)),max(handles.qyv(1,:))],[0,0,Inf,0,0],'-r','Parent',handles.plot);
        hold on
        handles.marker2=plot([0,0,Inf,0,0],[0,0,Inf,min(handles.qxv(:,1)),max(handles.qxv(:,1))],'-r','Parent',handles.plot);
    case 'horz'
        hold on
        handles.marker1=plot([0,0,Inf,max(handles.qyv(1,:)),min(handles.qyv(1,:))],[0,0,Inf,0,0],'-r','Parent',handles.plot);
        hold on
        handles.marker2=plot([0,0,Inf,0,0],[0,0,Inf,min(handles.qxv(:,1)),max(handles.qxv(:,1))],'-r','Parent',handles.plot);
    case 'trans'
        hold on
        handles.marker1=plot([0,0,Inf,min(handles.qxv(1,:)),max(handles.qxv(1,:))],[0,0,Inf,0,0],'-r','Parent',handles.plot);
        hold on
        handles.marker2=plot([0,0,Inf,0,0],[0,0,Inf,min(handles.qyv(:,1)),max(handles.qyv(:,1))],'-r','Parent',handles.plot);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pixelselect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pixelselect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function plot_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);

delete(handles.marker1)
delete(handles.marker2)

pp=get(handles.plot,'CurrentPoint');
[nrows,ncols] = size(handles.rawdata(:,:,1));
xdata = get(handles.h,'XData');
ydata = get(handles.h,'YData');
handles.x = round(axes2pix(nrows,ydata,pp(1,2)));
handles.y = round(axes2pix(ncols,xdata,pp(1,1)));

% handles.x=round(point(1,1));
% handles.y=round(point(1,2));

set(handles.dbxpixel,'String',num2str(handles.x));
set(handles.dbypixel,'String',num2str(handles.y));
set(handles.qx,'String',num2str(handles.qxv(handles.x,handles.y)));
set(handles.qy,'String',num2str(handles.qyv(handles.x,handles.y)));

switch(handles.ImageDirection)
    case 'vert'
        set(handles.qz,'String',num2str(handles.qzv(handles.x,handles.y)));
    case 'horz'
        set(handles.qz,'String',num2str(handles.qzv(handles.x,handles.y)));
    case 'trans'
        set(handles.qz,'String',num2str(0.0));
end

set(handles.qpara,'String',num2str(handles.qparav(handles.x,handles.y)));

switch(handles.ImageDirection)
    case 'vert'
        hold on
        handles.marker1=plot([0,0,Inf,min(handles.qyv(1,:)),max(handles.qyv(1,:))],[0,0,Inf,pp(1,2),pp(1,2)],'-r','Parent',handles.plot);
        hold on
        handles.marker2=plot([0,0,Inf,pp(1,1),pp(1,1)],[0,0,Inf,min(handles.qxv(:,1)),max(handles.qxv(:,1))],'-r','Parent',handles.plot);
    case 'horz'
        hold on
        handles.marker1=plot([0,0,Inf,min(handles.qyv(1,:)),max(handles.qyv(1,:))],[0,0,Inf,pp(1,2),pp(1,2)],'-r','Parent',handles.plot);
        hold on
        handles.marker2=plot([0,0,Inf,pp(1,1),pp(1,1)],[0,0,Inf,min(handles.qxv(:,1)),max(handles.qxv(:,1))],'-r','Parent',handles.plot);
    case 'trans'
        hold on
        handles.marker1=plot([0,0,Inf,min(handles.qxv(1,:)),max(handles.qxv(1,:))],[0,0,Inf,pp(1,2),pp(1,2)],'-r','Parent',handles.plot);
        hold on
        handles.marker2=plot([0,0,Inf,pp(1,1),pp(1,1)],[0,0,Inf,min(handles.qyv(:,1)),max(handles.qyv(:,1))],'-r','Parent',handles.plot);
end

guidata(hObject, handles);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject);

% --- Executes on button press in acm.
function acm_Callback(hObject, eventdata, handles)
% hObject    handle to acm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormapeditor;

cm=colormap;

colormap(handles.plot,cm);

guidata(hObject, handles);


% --- Executes on button press in zoombutt.
function zoombutt_Callback(hObject, eventdata, handles)
% hObject    handle to zoombutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zoombutt

switch(get(hObject,'Value'))
    case(1)
        zoom on;
    case(0)
        zoom off;
end