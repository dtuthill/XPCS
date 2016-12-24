function varargout = autoselectregion(varargin)
% AUTOSELECTREGION MATLAB code for autoselectregion.fig
%      AUTOSELECTREGION, by itself, creates a new AUTOSELECTREGION or raises the existing
%      singleton*.
%
%      H = AUTOSELECTREGION returns the handle to a new AUTOSELECTREGION or the handle to
%      the existing singleton*.
%
%      AUTOSELECTREGION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTOSELECTREGION.M with the given input arguments.
%
%      AUTOSELECTREGION('Property','Value',...) creates a new AUTOSELECTREGION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before autoselectregion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to autoselectregion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help autoselectregion

% Last Modified by GUIDE v2.5 16-Nov-2016 16:31:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @autoselectregion_OpeningFcn, ...
                   'gui_OutputFcn',  @autoselectregion_OutputFcn, ...
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


% --- Executes just before autoselectregion is made visible.
function autoselectregion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to autoselectregion (see VARARGIN)

% Choose default command line output for autoselectregion
handles.output = hObject;

handles.data=getappdata(0,'sumdata');

set(handles.startxpixel,'String','');
set(handles.endxpixel,'String','');
set(handles.startypixel,'String','');
set(handles.endypixel,'String','');

handles.NumXpixel = length(handles.data(1,:,1)); % pixels in x-direction
handles.NumYpixel = length(handles.data(:,1,1)); % pixels in y-direction

handles.h=imagesc(handles.data,'Parent',handles.plot);
set(handles.h,'ButtonDownFcn',@plot_ButtonDownFcn);

handles.rect=getrect(handles.plot);

handles.ymin=round(handles.rect(1));
handles.ymax=round(handles.rect(1)+handles.rect(1,3));
handles.xmin=round(handles.rect(2));
handles.xmax=round(handles.rect(2)+handles.rect(1,4));

set(handles.startxpixel,'String',num2str(handles.xmin));
set(handles.endxpixel,'String',num2str(handles.xmax));
set(handles.startypixel,'String',num2str(handles.ymin));
set(handles.endypixel,'String',num2str(handles.ymax));

hold on

handles.box=rectangle('Position',handles.rect,'Parent',handles.plot,'EdgeColor','r');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes autoselectregion wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = autoselectregion_OutputFcn(hObject, eventdata, handles) 
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

delete(handles.box);

handles.rect=getrect(handles.plot);

handles.ymin=round(handles.rect(1));
handles.ymax=round(handles.rect(1)+handles.rect(1,3));
handles.xmin=round(handles.rect(2));
handles.xmax=round(handles.rect(2)+handles.rect(1,4));

set(handles.startxpixel,'String',num2str(handles.xmin));
set(handles.endxpixel,'String',num2str(handles.xmax));
set(handles.startypixel,'String',num2str(handles.ymin));
set(handles.endypixel,'String',num2str(handles.ymax));

hold on

handles.box=rectangle('Position',handles.rect,'Parent',handles.plot,'EdgeColor','r');

guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

uiresume;

delete(hObject);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(0,'xmin',handles.xmin);
setappdata(0,'xmax',handles.xmax);
setappdata(0,'ymin',handles.ymin);
setappdata(0,'ymax',handles.ymax);
setappdata(0,'rect',handles.rect);

close


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
