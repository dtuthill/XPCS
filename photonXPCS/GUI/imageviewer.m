function varargout = imageviewer(varargin)
% IMAGEVIEWER MATLAB code for imageviewer.fig
%      IMAGEVIEWER, by itself, creates a new IMAGEVIEWER or raises the existing
%      singleton*.
%
%      H = IMAGEVIEWER returns the handle to a new IMAGEVIEWER or the handle to
%      the existing singleton*.
%
%      IMAGEVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEVIEWER.M with the given input arguments.
%
%      IMAGEVIEWER('Property','Value',...) creates a new IMAGEVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageviewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageviewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageviewer

% Last Modified by GUIDE v2.5 22-Oct-2016 16:19:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageviewer_OpeningFcn, ...
                   'gui_OutputFcn',  @imageviewer_OutputFcn, ...
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


% --- Executes just before imageviewer is made visible.
function imageviewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageviewer (see VARARGIN)

% Choose default command line output for imageviewer
handles.output = hObject;

handles.rawdata=getappdata(0,'rawdata');

cla(handles.imview);

image_string={};

for j=1:size(handles.rawdata,3)
    
    image_string=[image_string;{sprintf('Image %d',j)}];
    
end

set(handles.imageselect,'String',image_string);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imageviewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imageviewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in imageselect.
function imageselect_Callback(hObject, eventdata, handles)
% hObject    handle to imageselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imageselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imageselect

cla(handles.imview);

m=get(handles.imageselect,'Value');

imagesc(handles.rawdata(:,:,m),'Parent',handles.imview);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function imageselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in acm.
function acm_Callback(hObject, eventdata, handles)
% hObject    handle to acm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormapeditor;

cm=colormap;

colormap(handles.imview,cm);

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
