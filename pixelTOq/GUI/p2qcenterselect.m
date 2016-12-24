function varargout = p2qcenterselect(varargin)
% P2QCENTERSELECT MATLAB code for p2qcenterselect.fig
%      P2QCENTERSELECT, by itself, creates a new P2QCENTERSELECT or raises the existing
%      singleton*.
%
%      H = P2QCENTERSELECT returns the handle to a new P2QCENTERSELECT or the handle to
%      the existing singleton*.
%
%      P2QCENTERSELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in P2QCENTERSELECT.M with the given input arguments.
%
%      P2QCENTERSELECT('Property','Value',...) creates a new P2QCENTERSELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before p2qcenterselect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to p2qcenterselect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help p2qcenterselect

% Last Modified by GUIDE v2.5 18-Aug-2016 14:21:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @p2qcenterselect_OpeningFcn, ...
                   'gui_OutputFcn',  @p2qcenterselect_OutputFcn, ...
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


% --- Executes just before p2qcenterselect is made visible.
function p2qcenterselect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to p2qcenterselect (see VARARGIN)

% Choose default command line output for p2qcenterselect
handles.output = hObject;

handles.rawdata=getappdata(0,'rawdata');

set(handles.dbxpixel,'String','');
set(handles.dbypixel,'String','');

handles.NumXpixel = length(handles.rawdata(1,:,1)); % pixels in x-direction
handles.NumYpixel = length(handles.rawdata(:,1,1)); % pixels in y-direction

handles.h=imagesc(handles.rawdata(:,:,1),'Parent',handles.plot);
set(handles.h,'ButtonDownFcn',@plot_ButtonDownFcn);
% handles.hh=impoint(handles.plot);
% addNewPositionCallback(handles.hh,@plot_impoint);

hold on
handles.marker=plot([0,0,Inf,0,handles.NumXpixel],[0,handles.NumYpixel,Inf,0,0],'-r','Parent',handles.plot);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes p2qcenterselect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = p2qcenterselect_OutputFcn(hObject, eventdata, handles) 
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

delete(handles.marker)

point=get(handles.plot,'CurrentPoint');

handles.x=round(point(1,1));
handles.y=round(point(1,2));

set(handles.dbxpixel,'String',round(point(1,1)));
set(handles.dbypixel,'String',round(point(1,2)));

hold on
handles.marker=plot([handles.x,handles.x,Inf,0,handles.NumXpixel],[0,handles.NumYpixel,Inf,handles.y,handles.y],'-r','Parent',handles.plot);

guidata(hObject, handles);

% function plot_impoint(hObject, eventdata, handles)
% % hObject    handle to plot (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% handles=guidata(hObject);
% 
% handles.NumXpixel
% 
% guidata(hObject, handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(0,'x',handles.x);
setappdata(0,'y',handles.y);

guidata(hObject, handles);

close(p2qcenterselect);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

uiresume;

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
