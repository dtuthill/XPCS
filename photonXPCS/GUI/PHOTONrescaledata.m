function varargout = PHOTONrescaledata(varargin)
% PHOTONRESCALEDATA MATLAB code for PHOTONrescaledata.fig
%      PHOTONRESCALEDATA, by itself, creates a new PHOTONRESCALEDATA or raises the existing
%      singleton*.
%
%      H = PHOTONRESCALEDATA returns the handle to a new PHOTONRESCALEDATA or the handle to
%      the existing singleton*.
%
%      PHOTONRESCALEDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHOTONRESCALEDATA.M with the given input arguments.
%
%      PHOTONRESCALEDATA('Property','Value',...) creates a new PHOTONRESCALEDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PHOTONrescaledata_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PHOTONrescaledata_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PHOTONrescaledata

% Last Modified by GUIDE v2.5 23-Oct-2016 21:51:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PHOTONrescaledata_OpeningFcn, ...
                   'gui_OutputFcn',  @PHOTONrescaledata_OutputFcn, ...
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


% --- Executes just before PHOTONrescaledata is made visible.
function PHOTONrescaledata_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PHOTONrescaledata (see VARARGIN)

% Choose default command line output for PHOTONrescaledata
handles.output = hObject;

handles.data=getappdata(0,'data');

cla(handles.center);
cla(handles.sumint);
cla(handles.qx);
cla(handles.qy);
cla(handles.Qpara);
cla(handles.imsel);
cla(handles.imdis);

handles.vdbxpixel=str2double(get(handles.dbxpixel,'String'));
handles.vdbypixel=str2double(get(handles.dbypixel,'String'));
handles.venergy=str2double(get(handles.energy,'String'));
handles.vsamplecameradistance=str2double(get(handles.samplecameradistance,'String'));
handles.valpha=str2double(get(handles.alpha,'String'));
handles.vtimeperframe=str2double(get(handles.timeperframe,'String'));
handles.vpixelsize=str2double(get(handles.pixelsize,'String'));
handles.startPixelX=str2num(get(handles.startpixelX,'String'));
handles.startPixelY=str2num(get(handles.startpixelY,'String'));
handles.endPixelX=str2num(get(handles.endpixelX,'String'));
handles.endPixelY=str2num(get(handles.endpixelY,'String'));
handles.vxstartlength=str2num(get(handles.xstartlength,'String'));
handles.vxHeight=str2num(get(handles.xHeight,'String'));
handles.vystartlength=str2num(get(handles.ystartlength,'String'));
handles.vyHeight=str2num(get(handles.yHeight,'String'));
handles.vqxBin=str2num(get(handles.qxBin,'String'));
handles.vqyBin=str2num(get(handles.qyBin,'String'));

handles.n=length(handles.startpixelX);
handles.recta=[str2num(get(handles.startpixelY,'String')) str2num(get(handles.startpixelX,'String')) str2num(get(handles.endpixelY,'String'))-str2num(get(handles.startpixelY,'String')) str2num(get(handles.endpixelX,'String'))-str2num(get(handles.startpixelX,'String'))];

contents=cellstr(get(handles.imagedirection,'String'));
choices=contents{get(handles.imagedirection,'Value')};

if (strcmp(choices,'Vertical'));
    handles.vimagedirection='vert';
    
elseif (strcmp(choices,'Horizontal'));
    handles.vimagedirection='horz';
    
elseif (strcmp(choices,'Transmission'));
    handles.vimagedirection='trans';
    set(handles.alpha,'String','0');
    handles.valpha=str2double(get(handles.alpha,'String'));
end

contents=cellstr(get(handles.roiselection,'String'));
choices=contents{get(handles.roiselection,'Value')};

if (strcmp(choices,'Continuous Region'));
    handles.roiselection='continuousregion';
    set(findall(handles.pansel, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.pancon, '-property', 'enable'), 'enable', 'on');
    
elseif (strcmp(choices,'Select Region'));
    handles.roiselection='selectregion';
    set(findall(handles.pansel, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.pancon, '-property', 'enable'), 'enable', 'off');
    
end

irs = get(handles.imageregionselect,'Value');
if irs == get(handles.imageregionselect,'Max')
	set(handles.imageregionselect,'String','Yes','Value',1);
elseif irs == get(handles.imageregionselect,'Min')
	set(handles.imageregionselect,'String','No','Value',0);
end

drsi = get(handles.displayregionselectimage,'Value');
if drsi == get(handles.displayregionselectimage,'Max')
	set(handles.displayregionselectimage,'String','Yes','Value',1);
elseif drsi == get(handles.displayregionselectimage,'Min')
	set(handles.displayregionselectimage,'String','No','Value',0);
end

dqv = get(handles.discreteQvalue,'Value');
if dqv == get(handles.discreteQvalue,'Max')
	set(handles.discreteQvalue,'String','Yes','Value',1);
elseif dqv == get(handles.discreteQvalue,'Min')
	set(handles.discreteQvalue,'String','No','Value',0);
end

contents=cellstr(get(handles.numImagedisplay,'String'));
choices=contents{get(handles.numImagedisplay,'Value')};

if (strcmp(choices,'One'));
    handles.numImagedisplay=1;
    
elseif (strcmp(choices,'All'));
    handles.numImagedisplay=length(str2num(get(handles.startpixelX,'String')));

end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PHOTONrescaledata wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PHOTONrescaledata_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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



function energy_Callback(hObject, eventdata, handles)
% hObject    handle to energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.venergy=str2double(get(hObject,'String'));

% Hints: get(hObject,'String') returns contents of energy as text
%        str2double(get(hObject,'String')) returns contents of energy as a double

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



function timeperframe_Callback(hObject, eventdata, handles)
% hObject    handle to timeperframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeperframe as text
%        str2double(get(hObject,'String')) returns contents of timeperframe as a double

handles.vtimeperframe=str2double(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function timeperframe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeperframe (see GCBO)
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


% --- Executes on selection change in roiselection.
function roiselection_Callback(hObject, eventdata, handles)
% hObject    handle to roiselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns roiselection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from roiselection

contents=cellstr(get(hObject,'String'));
choices=contents{get(hObject,'Value')};

if (strcmp(choices,'Continuous Region'));
    handles.roiselection='continuousregion';
    set(findall(handles.pansel, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.pancon, '-property', 'enable'), 'enable', 'on');
    
elseif (strcmp(choices,'Select Region'));
    handles.roiselection='selectregion';
    set(findall(handles.pansel, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.pancon, '-property', 'enable'), 'enable', 'off');
    
end
    
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function roiselection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roiselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in imageregionselect.
function imageregionselect_Callback(hObject, eventdata, handles)
% hObject    handle to imageregionselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imageregionselect

irs = get(hObject,'Value');
if irs == get(hObject,'Max')
	set(handles.imageregionselect,'String','Yes','Value',1);
elseif irs == get(hObject,'Min')
	set(handles.imageregionselect,'String','No','Value',0);
end

guidata(hObject, handles);


% --- Executes on button press in displayregionselectimage.
function displayregionselectimage_Callback(hObject, eventdata, handles)
% hObject    handle to displayregionselectimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displayregionselectimage

drsi = get(hObject,'Value');
if drsi == get(hObject,'Max')
	set(handles.displayregionselectimage,'String','Yes','Value',1);
elseif drsi == get(hObject,'Min')
	set(handles.displayregionselectimage,'String','No','Value',0);
end

guidata(hObject, handles);


% --- Executes on button press in discreteQvalue.
function discreteQvalue_Callback(hObject, eventdata, handles)
% hObject    handle to discreteQvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of discreteQvalue

dqv = get(hObject,'Value');
if dqv == get(hObject,'Max')
	set(handles.discreteQvalue,'String','Yes','Value',1);
elseif dqv == get(hObject,'Min')
	set(handles.discreteQvalue,'String','No','Value',0);
end

guidata(hObject, handles);


% --- Executes on selection change in numImagedisplay.
function numImagedisplay_Callback(hObject, eventdata, handles)
% hObject    handle to numImagedisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns numImagedisplay contents as cell array
%        contents{get(hObject,'Value')} returns selected item from numImagedisplay

contents=cellstr(get(hObject,'String'));
choices=contents{get(hObject,'Value')};

if (strcmp(choices,'One'));
    handles.numImagedisplay=1;
    
elseif (strcmp(choices,'All'));
    handles.numImagedisplay=length(str2num(get(handles.startpixelX,'String')));

end

guidata(hObject, handles)




% --- Executes during object creation, after setting all properties.
function numImagedisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numImagedisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startpixelX_Callback(hObject, eventdata, handles)
% hObject    handle to startpixelX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startpixelX as text
%        str2double(get(hObject,'String')) returns contents of startpixelX as a double

handles.startPixelX=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function startpixelX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startpixelX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endpixelX_Callback(hObject, eventdata, handles)
% hObject    handle to endpixelX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endpixelX as text
%        str2double(get(hObject,'String')) returns contents of endpixelX as a double

handles.endPixelX=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function endpixelX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endpixelX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startpixelY_Callback(hObject, eventdata, handles)
% hObject    handle to startpixelY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startpixelY as text
%        str2double(get(hObject,'String')) returns contents of startpixelY as a double

handles.startPixelY=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function startpixelY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startpixelY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function endpixelY_Callback(hObject, eventdata, handles)
% hObject    handle to endpixelY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endpixelY as text
%        str2double(get(hObject,'String')) returns contents of endpixelY as a double

handles.endPixelY=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function endpixelY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endpixelY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runrescale.
function runrescale_Callback(hObject, eventdata, handles)
% hObject    handle to runrescale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.center);
cla(handles.sumint);
cla(handles.qx);
cla(handles.qy);
cla(handles.Qpara);
cla(handles.imsel);
cla(handles.imdis);

set(handles.pixelerr,'String','');
set(handles.imselerr,'String','');
set(handles.imdiserr,'String','');

lambda = 12.398/handles.venergy; %wavelength
numImages = length(handles.data(1,1,:));  % number of images in the movie series
NumXpixel = length(handles.data(1,:,1)); % pixels in x-direction
NumYpixel = length(handles.data(:,1,1)); % pixels in y-direction
tauInFrames(1)= 0;
tauInFrames(2:numImages) =  1:(numImages-1);
% dbXpixel = round(x);  %specular beam pixel number in x direction, input from  ginput
% dbYpixel = round(y);  %specular beam pixel number in Y direction, input from  ginput

switch(handles.roiselection)
    case 'continuousregion'

% endX = dbYpixel-xstartlength;
% startX = endX-xHeight;
startX=handles.vdbypixel-handles.vxstartlength;
endX=startX+handles.vxHeight;
startY=handles.vdbxpixel-handles.vystartlength;
endY=startY+handles.vyHeight;

startPixX = cell(length(handles.vxstartlength),1);       %preallocating startPixX
endPixX = cell(length(handles.vxstartlength),1);         %preallocating endPixX
startPixY = cell(length(handles.vxstartlength),1);       %preallocating startPixY
endPixY = cell(length(handles.vxstartlength),1);         %preallocating endPixY

for i=1:length(handles.vxstartlength)
    if handles.vxHeight(i) > handles.vyHeight(i)
        startPixX{i,:} =startX(i):handles.vqxBin(i):(endX(i)-handles.vqxBin(i));
        endPixX{i,:}=(startX(i)+handles.vqxBin(i)):handles.vqxBin(i):endX(i);
        startPixY{i,:}=repmat(startY(i),1,length(startPixX{i,:}));
        endPixY{i,:}=repmat(endY(i),1,length(startPixX{i,:}));
   
    elseif handles.vxHeight(i) < handles.vyHeight(i)
        startPixY{i,:}=startY(i):handles.vqyBin(i):(endY(i)-handles.vqyBin(i));
        endPixY{i,:}=(startY(i)+handles.vqyBin(i)):handles.vqyBin(i):endY(i);
        startPixX{i,:}=repmat(startX(i),1,length(startPixY{i,:}));
        endPixX{i,:}=repmat(endX(i),1,length(startPixY{i,:}));
              
    else
        set(handles.pixelerr,'String','X-Height and Y-Height are the same Please change');
        halt;
    
    end
end
    
if length(handles.vxstartlength)==1
   handles.vstartpixelX = startPixX{1,:}; 
   handles.vendpixelX = endPixX{1,:};
   handles.vstartpixelY = startPixY{1,:};
   handles.vendpixelY = endPixY{1,:};
else
    handles.vstartpixelX = cat(2,startPixX{:,:});
    handles.vendpixelX = cat(2,endPixX{:,:});
    handles.vstartpixelY = cat(2,startPixY{:,:});
    handles.vendpixelY = cat(2,endPixY{:,:});
end

case 'selectregion'
    handles.vstartpixelX = handles.startPixelX;
    handles.vendpixelX = handles.endPixelX;
    handles.vstartpixelY = handles.startPixelY;
    handles.vendpixelY = handles.endPixelY;
end

%******** Calculates qx, qy and qz by calling the function pixelToQconv

numqpara = length(handles.vstartpixelX);             % number of parallel regions selected
numqparadisplay = numqpara;                         % this goes with the image thing below I don't understand

setappdata(0,'NumXpixel',NumXpixel);
setappdata(0,'NumYpixel',NumYpixel);
setappdata(0,'dbxpixel',handles.vdbxpixel);
setappdata(0,'dbypixel',handles.vdbypixel);
setappdata(0,'imagedirection',handles.vimagedirection);
setappdata(0,'alpha',handles.valpha);
setappdata(0,'pixelsize',handles.vpixelsize);
setappdata(0,'samplecameradistance',handles.vsamplecameradistance);
setappdata(0,'lambda',lambda);
setappdata(0,'startpixelX',handles.vstartpixelX);
setappdata(0,'startpixelY',handles.vstartpixelY);
setappdata(0,'endpixelX',handles.vendpixelX);
setappdata(0,'endpixelY',handles.vendpixelY);
setappdata(0,'discreteQvalue',get(handles.discreteQvalue,'Value'));

qpara=[];

[qx,qy,qz,qpara] = GUIpixelToQconv();


imagesc(handles.data(:,:,1),'Parent',handles.center);
    
hold(handles.center,'on')
    plot([handles.vdbxpixel,handles.vdbxpixel,Inf,0,NumXpixel],[0,NumYpixel,Inf,handles.vdbypixel,handles.vdbypixel],'-r','Parent',handles.center);
    
    i=0;
    for i=1:handles.n;
    hold(handles.center,'on')
    rectangle('Position',handles.recta(i,:),'Parent',handles.center,'EdgeColor','r');
    end
    
imagesc(qx,'Parent',handles.qx);
xlabel('numYpixel','Parent',handles.qx);
ylabel('Qx','Parent',handles.qx);
imagesc(qy,'Parent',handles.qy);
xlabel('numXpixel','Parent',handles.qy);
ylabel('Qy','Parent',handles.qy);
imagesc(qpara,'Parent',handles.Qpara);
xlabel('numXpixel','Parent',handles.Qpara);
ylabel('numYpixel','Parent',handles.Qpara);


qparaValue1 = zeros(numqpara,1);      %preallocating qparaValue1
qparaValue2 = zeros(numqpara,1) ;     %preallocating qparaValue2      


for m=1:numqpara
            qparaValue1(m)=(qpara(handles.vstartpixelX(m),handles.vstartpixelY(m))+qpara(handles.vendpixelX(m),handles.vstartpixelY(m)))/2;
            qparaValue2(m)=(qpara(handles.vstartpixelX(m),handles.vendpixelY(m))+qpara(handles.vendpixelX(m),handles.vendpixelY(m)))/2;
            qparaValue(m)=(qparaValue1(m)+qparaValue2(m))/2;
            qparaTol(m)=qpara(handles.vstartpixelX(m),handles.vstartpixelY(m));
end

%************** Region of interest selection in image************

setappdata(0,'numqpara',numqpara);
setappdata(0,'numImages',numImages);
setappdata(0,'qpara',qpara);
setappdata(0,'qparaValue',qparaValue);
setappdata(0,'qparaTol',qparaTol);

[rescaleData]=GUIimageSelect();

handles.rescaleData=rescaleData;
     handles.rescaleData=double(handles.rescaleData);

     
setappdata(0,'rescaleData',handles.rescaleData);

if isequal(get(handles.discreteQvalue,'Value'),1)

switch(get(handles.imageregionselect,'String'))

    case 'Yes'
        imagesc(handles.rescaleData(:,:,1),'Parent',handles.imsel);
        set(handles.imselerr,'String','')
    case 'No'
        set(handles.imselerr,'String','Image selection not used')
end

switch(get(handles.displayregionselectimage,'String'))          
    case 'Yes'
        for ii=1:handles.numImagedisplay
            for jj=1:numqparadisplay
                imagesc(handles.rescaleData(:,:,ii,jj),'Parent',handles.imdis); 
            end
        end
        set(handles.imdiserr,'String','')

    case 'No'
        set(handles.imdiserr,'String','No display of region selected images')
end

else
    set(handles.imselerr,'String','Static Q value used')
    set(handles.imdiserr,'String','Static Q value used')
    
end


handles.sumIntensityQbins=[];
IntensityQbins=[];

if isequal(get(handles.discreteQvalue,'Value'),1)

IntensityQbins = sum(sum(handles.rescaleData(:,:,:,:)));
handles.sumIntensityQbins(1:numImages,1:numqpara) = IntensityQbins(:,:,1:numImages,1:numqpara);         %Doesn't work constant Q value select. imageSelect outputs rescale as 1100x1 instead of a 10x10x1100
setappdata(0,'sumIntensityQbins',handles.sumIntensityQbins);

else
    
    handles.sumIntensityQbins=getappdata(0,'sumIntensityQbins');
end

for n=1:(numqpara)
    clear legendMatrix1;
    legendMatrix1=sprintf('%E',qparaValue(n));  
    legendMatrix(n,:)=legendMatrix1;
end

plot(tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerEdgeColor','r','MarkerSize',1,'Parent',handles.sumint);
legend(legendMatrix,1);
xlabel('Tau in Frames','Parent',handles.sumint);
ylabel('sumIntensity in q-bins','Parent',handles.sumint);

setappdata(0,'timeperframe',handles.vtimeperframe);

guidata(hObject, handles);



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



function xstartlength_Callback(hObject, eventdata, handles)
% hObject    handle to xstartlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xstartlength as text
%        str2double(get(hObject,'String')) returns contents of xstartlength as a double

handles.vxstartlength=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xstartlength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xstartlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xHeight_Callback(hObject, eventdata, handles)
% hObject    handle to xHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xHeight as text
%        str2double(get(hObject,'String')) returns contents of xHeight as a double
handles.vxHeight=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ystartlength_Callback(hObject, eventdata, handles)
% hObject    handle to ystartlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ystartlength as text
%        str2double(get(hObject,'String')) returns contents of ystartlength as a double

handles.vystartlength=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ystartlength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ystartlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yHeight_Callback(hObject, eventdata, handles)
% hObject    handle to yHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yHeight as text
%        str2double(get(hObject,'String')) returns contents of yHeight as a double

handles.vyHeight=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function yHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function qxBin_Callback(hObject, eventdata, handles)
% hObject    handle to qxBin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qxBin as text
%        str2double(get(hObject,'String')) returns contents of qxBin as a double

handles.vqxBin=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function qxBin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qxBin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function qyBin_Callback(hObject, eventdata, handles)
% hObject    handle to qyBin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qyBin as text
%        str2double(get(hObject,'String')) returns contents of qyBin as a double

handles.vqyBin=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function qyBin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qyBin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runxpcs.
function runxpcs_Callback(hObject, eventdata, handles)
% hObject    handle to runxpcs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GUIxpcs


% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


centerselect

uiwait;

handles.vdbxpixel=getappdata(0,'x');
handles.vdbypixel=getappdata(0,'y');

set(handles.dbxpixel,'String',num2str(handles.vdbxpixel));
set(handles.dbypixel,'String',num2str(handles.vdbypixel));

guidata(hObject, handles);


% --- Executes on button press in roiselect.
function roiselect_Callback(hObject, eventdata, handles)
% hObject    handle to roiselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectregion;

uiwait;

handles.startPixelX=[];
handles.endPixelX=[];
handles.startPixelY=[];
handles.endPixelY=[];

handles.startPixelX=getappdata(0,'xmin');
handles.endPixelX=getappdata(0,'xmax');
handles.startPixelY=getappdata(0,'ymin');
handles.endPixelY=getappdata(0,'ymax');
handles.recta=getappdata(0,'recta');

handles.n=length(handles.startPixelX);

set(handles.startpixelX,'String',num2str(handles.startPixelX));
set(handles.endpixelX,'String',num2str(handles.endPixelX));
set(handles.startpixelY,'String',num2str(handles.startPixelY));
set(handles.endpixelY,'String',num2str(handles.endPixelY));

guidata(hObject, handles);


% --- Executes on button press in cubetest.
function cubetest_Callback(hObject, eventdata, handles)
% hObject    handle to cubetest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cube
