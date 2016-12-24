function varargout = p2q(varargin)
% P2Q MATLAB code for p2q.fig
%      P2Q, by itself, creates a new P2Q or raises the existing
%      singleton*.
%
%      H = P2Q returns the handle to a new P2Q or the handle to
%      the existing singleton*.
%
%      P2Q('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in P2Q.M with the given input arguments.
%
%      P2Q('Property','Value',...) creates a new P2Q or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before p2q_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to p2q_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help p2q

% Last Modified by GUIDE v2.5 14-Jul-2016 14:56:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @p2q_OpeningFcn, ...
                   'gui_OutputFcn',  @p2q_OutputFcn, ...
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


% --- Executes just before p2q is made visible.
function p2q_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to p2q (see VARARGIN)

% Choose default command line output for p2q
handles.output = hObject;

set(handles.filestring,'String','"Please Select File Path"');
cla(handles.imgscat);

addpath('GUI');

handles.vdbxpixel=str2double(get(handles.dbxpixel,'String'));
handles.vdbypixel=str2double(get(handles.dbypixel,'String'));
handles.venergy=str2double(get(handles.energy,'String'));
handles.vsamplecameradistance=str2double(get(handles.samplecameradistance,'String'));
handles.valpha=str2double(get(handles.alpha,'String'));
handles.vpixelsize=str2double(get(handles.pixelsize,'String'));

contents=cellstr(get(handles.imagedirection,'String'));
choices=contents{get(handles.imagedirection,'Value')};

if (strcmp(choices,'Vertical'));
    handles.vimagedirection='vert';
    
elseif (strcmp(choices,'Horizontal'));
    handles.vimagedirection='horz';
    
elseif (strcmp(choices,'Transmission'));
    handles.vimagedirection='trans';
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes p2q wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = p2q_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loaddata.
function loaddata_Callback(hObject, eventdata, handles)
% hObject    handle to loaddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.imgscat,'reset');

rawdata=[];
handles.rawdata=[];
handles.data=[];
handles.Intensity_sum=[];

[filename,pathname]=uigetfile(fullfile(pwd,'*.fits'),'Select Data File');
addpath(pathname);
rawdata=strcat(pathname,filename);
set(handles.filestring,'String',char(rawdata));
handles.rawdata=fitsread(rawdata);

imagesc(handles.rawdata(:,:,1),'Parent',handles.imgscat);

setappdata(0,'rawdata',handles.rawdata);

guidata(hObject, handles);



function energy_Callback(hObject, eventdata, handles)
% hObject    handle to energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of energy as text
%        str2double(get(hObject,'String')) returns contents of energy as a double

handles.venergy=str2double(get(hObject,'String'));

guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function energy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function samplecameradistance_Callback(hObject, eventdata, handles)
% hObject    handle to samplecameradistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of samplecameradistance as text
%        str2double(get(hObject,'String')) returns contents of samplecameradistance as a double

handles.vsamplecameradistance=str2double(get(hObject,'String'));

guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function samplecameradistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplecameradistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double

handles.valpha=str2double(get(hObject,'String'));

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in imagedirection.
function imagedirection_Callback(hObject, eventdata, handles)
% hObject    handle to imagedirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imagedirection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imagedirection

contents=cellstr(get(hObject,'String'));
choices=contents{get(hObject,'Value')};

if (strcmp(choices,'Vertical'));
    handles.vimagedirection='vert';
    
elseif (strcmp(choices,'Horizontal'));
    handles.vimagedirection='horz';
    
elseif (strcmp(choices,'Transmission'));
    handles.vimagedirection='trans';
    set(handles.alpha,'String','0');
    handles.valpha=str2double(get(handles.alpha,'String'));
end
    
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function imagedirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagedirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixelsize_Callback(hObject, eventdata, handles)
% hObject    handle to pixelsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixelsize as text
%        str2double(get(hObject,'String')) returns contents of pixelsize as a double

handles.vpixelsize=str2double(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pixelsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixelsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dbxpixel_Callback(hObject, eventdata, handles)
% hObject    handle to dbxpixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dbxpixel as text
%        str2double(get(hObject,'String')) returns contents of dbxpixel as a double

handles.vdbxpixel=str2double(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function dbxpixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dbxpixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dbypixel_Callback(hObject, eventdata, handles)
% hObject    handle to dbypixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dbypixel as text
%        str2double(get(hObject,'String')) returns contents of dbypixel as a double

handles.vdbypixel=str2double(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function dbypixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dbypixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


p2qcenterselect

uiwait;

handles.vdbxpixel=getappdata(0,'x');
handles.vdbypixel=getappdata(0,'y');

set(handles.dbxpixel,'String',num2str(handles.vdbxpixel));
set(handles.dbypixel,'String',num2str(handles.vdbypixel));

guidata(hObject, handles);


% --- Executes on button press in qconvert.
function qconvert_Callback(hObject, eventdata, handles)
% hObject    handle to qconvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.imgscat);

imagesc(handles.rawdata(:,:,1),'Parent',handles.imgscat);

lambda = 12.398/handles.venergy; %wavelength
NumXpixel = length(handles.rawdata(1,:,1)); % pixels in x-direction
NumYpixel = length(handles.rawdata(:,1,1)); % pixels in y-direction

setappdata(0,'NumXpixel',NumXpixel);
setappdata(0,'NumYpixel',NumYpixel);
setappdata(0,'dbxpixel',handles.vdbxpixel);
setappdata(0,'dbypixel',handles.vdbypixel);
setappdata(0,'imagedirection',handles.vimagedirection);
setappdata(0,'alpha',handles.valpha);
setappdata(0,'pixelsize',handles.vpixelsize);
setappdata(0,'samplecameradistance',handles.vsamplecameradistance);
setappdata(0,'lambda',lambda);

qpara=[];

[qx,qy,qz,q,qpara] = p2qpixelToQconv();

hold(handles.imgscat,'on')
    handles.cmark=plot([handles.vdbxpixel,handles.vdbxpixel,Inf,0,NumXpixel],[0,NumYpixel,Inf,handles.vdbypixel,handles.vdbypixel],'-r','Parent',handles.imgscat);

setappdata(0,'qx',qx);
setappdata(0,'qy',qy);
setappdata(0,'qz',qz);
setappdata(0,'qpara',qpara);
setappdata(0,'q',q);

guidata(hObject, handles);
    


% --- Executes on button press in pixelq.
function pixelq_Callback(hObject, eventdata, handles)
% hObject    handle to pixelq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pixelselect


% --- Executes on button press in loadlvdata.
function loadlvdata_Callback(hObject, eventdata, handles)
% hObject    handle to loadlvdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.imgscat,'reset');

handles.PathName = uigetdir(pwd,'Select the Data File');
addpath(handles.PathName);
set(handles.filestring,'String',char(handles.PathName));
handles.PathName=strcat(handles.PathName,'/');
handles.PathName1=strcat(handles.PathName,'*.fits/');
handles.filelist=dir(handles.PathName1);

pathlength=length(handles.filelist);

handles.rawdata=[];

clear i;

    for i=1
        a = handles.filelist(i).name;
        fileName = strcat(handles.PathName,a);
        handles.rawdata(:,:,i) = fitsread(fileName,'image');
    end

imagesc(handles.rawdata(:,:,1),'Parent',handles.imgscat);

setappdata(0,'rawdata',handles.rawdata);

guidata(hObject, handles);
