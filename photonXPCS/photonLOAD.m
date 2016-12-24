function varargout = photonLOAD(varargin)
% PHOTONLOAD MATLAB code for photonLOAD.fig
%      PHOTONLOAD, by itself, creates a new PHOTONLOAD or raises the existing
%      singleton*.
%
%      H = PHOTONLOAD returns the handle to a new PHOTONLOAD or the handle to
%      the existing singleton*.
%
%      PHOTONLOAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHOTONLOAD.M with the given input arguments.
%
%      PHOTONLOAD('Property','Value',...) creates a new PHOTONLOAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before photonLOAD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to photonLOAD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help photonLOAD

% Last Modified by GUIDE v2.5 27-Oct-2016 15:17:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @photonLOAD_OpeningFcn, ...
                   'gui_OutputFcn',  @photonLOAD_OutputFcn, ...
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


% --- Executes just before photonLOAD is made visible.
function photonLOAD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to photonLOAD (see VARARGIN)

% Choose default command line output for photonLOAD
handles.output = hObject;

cla(handles.zzdisp);

set(handles.progress,'String','');
set(handles.filestring,'String','');
set(handles.timelabel,'String','');
set(handles.tinterval,'String','');
set(handles.ninterval,'String','');
set(handles.finterval,'Value',0);
handles.xyBin=str2num(get(handles.bin,'String'));

set(handles.ninterval,'Enable','On');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes photonLOAD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = photonLOAD_OutputFcn(hObject, eventdata, handles) 
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

cla(handles.zzdisp);
cla(handles.sumint);

set(handles.progress,'String','');
set(handles.timelabel,'String','');

handles.PathName = uigetdir(pwd,'Select the Data File');
addpath(handles.PathName);
set(handles.filestring,'String',char(handles.PathName));
set(handles.progress,'String','Loading Data...');
handles.PathName=strcat(handles.PathName,'/');
handles.PathName1=strcat(handles.PathName,'*.fits');
handles.fileList=dir(handles.PathName1);

clear fastdataA1;

%h=waitbar(0,'Loading Data...')

for index=1:1:length(handles.fileList)
    
    clear fileName;
    
    a=handles.fileList(index).name;
    
    fileName=strcat(handles.PathName,a);
        
    fastdataA1(:,:,index)=cell2mat(fitsread(fileName,'binarytable'));
    
    %waitbar(index/length(handles.fileList));
    
end

%close(h);

set(handles.progress,'String','Concatenating Files...');

handles.zz=[];

%h=waitbar(0,'Concatenating Files...');

for index=1:1:length(handles.fileList)

    if index == 1
        
        handles.zz(:,:) = fastdataA1(:,:,1);
       
    else
        handles.zz=vertcat(handles.zz(:,:),fastdataA1(:,:,index));
    end
    
    %waitbar(index/length(handles.fileList));
    
end

%close(h);

plot(handles.zz(:,4),'Parent',handles.zzdisp);

set(handles.progress,'String','Data Loaded');

guidata(hObject, handles);



function bin_Callback(hObject, eventdata, handles)
% hObject    handle to bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bin as text
%        str2double(get(hObject,'String')) returns contents of bin as a double

handles.xyBin=str2num(get(handles.bin,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sumimage.
function sumimage_Callback(hObject, eventdata, handles)
% hObject    handle to sumimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.progress,'String','Summing Data...');
cla(handles.sumint);

handles.data=handles.zz;

% Col 1 = X coordinate of pixel
% Col 2 = Y coordinate of pixel 
% Col 3 = gain of detector          
% Col 4 = Time at which photons arrived

diffValue = int64(diff(int32(handles.data(:,4))));
numWrapIndices = find(diffValue < 0);
numWrap = length(numWrapIndices);

clear i; clear j;

z = int64(handles.data);
%plot(zz(:,4));

set(handles.progress,'String','Converting Time...');

%h=waitbar(0,'Converting Time...');

for i=1:numWrap-1
    
    sumv=0;
    for k=1:i
        sumv=sumv+abs(diffValue(numWrapIndices(k)));
    end
    
    for j = numWrapIndices(i) : numWrapIndices(i+1)-1
        z(j+1,4) = z(j+1,4)+ sumv;
    
    end
    
    %waitbar(i/(numWrap-1))
    
end

%close(h);


clear i; clear j;

%waitbar(0,'Converting Time...');

for j = numWrapIndices(numWrap)+1 : length(handles.data(:,4))
    
    sumv=0;
    for k=1:numWrap
        sumv=sumv+abs(diffValue(numWrapIndices(k)));
    end
    
    z(j,4) = z(j,4)+ sumv;
    
        %waitbar(j/(length(handles.data(:,4))))
end

%close(h);

z(:,4)=z(:,4).*40;

z(:,4)=z(:,4)-min(z(:,4));  

handles.arrivalTime=double(z(:,4));

[row,column]=find(round(handles.arrivalTime,-6)==0);      %removes weird initial data points

for i=1:length(row)
    z(row,:)=[];
end

nandata=find(z(:,1)==0 & z(:,2)==0);
z(nandata,:)=[];

z(:,4)=z(:,4)-min(z(:,4));

handles.arrivalTime=double(z(:,4));

cla(handles.zzdisp,'reset');
plot(handles.arrivalTime,'Parent',handles.zzdisp);
title('Arrival Time','Parent',handles.zzdisp)

handles.zstore=z;

set(handles.progress,'String','Data Summed');

handles.max=max(handles.arrivalTime);

set(handles.timelabel,'String',num2str(handles.max*1e-9));

clear z; clear diffValue;

guidata(hObject, handles);


% --- Executes on button press in loadcompiledata.
function loadcompiledata_Callback(hObject, eventdata, handles)
% hObject    handle to loadcompiledata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.filestring,'String','');

[filename,pathname]=uigetfile(fullfile(pwd,'*.fits'),'Select Data File');
addpath(pathname);
handles.PathName1=strcat(pathname,filename);
set(handles.filestring,'String',char(handles.PathName1));

set(handles.progress,'String','Loading Data...');

cla(handles.zzdisp);
cla(handles.sumint);

clear fastdataA1;
        
fastdataA1(:,:,1)=cell2mat(fitsread(handles.PathName1,'binarytable'));

handles.zz=[];
        
handles.zz(:,:) = fastdataA1(:,:,1);

plot(handles.zz(:,4),'Parent',handles.zzdisp);

set(handles.progress,'String','Data Loaded');

guidata(hObject, handles);



function tinterval_Callback(hObject, eventdata, handles)
% hObject    handle to tinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tinterval as text
%        str2double(get(hObject,'String')) returns contents of tinterval as a double


% --- Executes during object creation, after setting all properties.
function tinterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ninterval_Callback(hObject, eventdata, handles)
% hObject    handle to ninterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ninterval as text
%        str2double(get(hObject,'String')) returns contents of ninterval as a double


% --- Executes during object creation, after setting all properties.
function ninterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ninterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in finterval.
function finterval_Callback(hObject, eventdata, handles)
% hObject    handle to finterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of finterval

switch get(hObject,'Value')
    case 0
        set(handles.ninterval,'Enable','On');
    case 1
        set(handles.ninterval,'Enable','Off');
end


% --- Executes on button press in viewim.
function viewim_Callback(hObject, eventdata, handles)
% hObject    handle to viewim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addpath('GUI');

imageviewer


% --- Executes on button press in rescale.
function rescale_Callback(hObject, eventdata, handles)
% hObject    handle to rescale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PHOTONrescaledata


% --- Executes on button press in createim.
function createim_Callback(hObject, eventdata, handles)
% hObject    handle to createim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

z=handles.zstore;

interval=str2num(get(handles.tinterval,'String'))*1e9;

switch (get(handles.finterval,'Value'))
    case 0
        p=str2num(get(handles.ninterval,'String'));
    case 1
        p=double(ceil(handles.max/interval));
end

totalPixel = 4096;
pixelBin = totalPixel/handles.xyBin;

try
sumImage = zeros(pixelBin,pixelBin,p);
catch 'MATLAB:array:SizeLimitExceeded';
    errordlg('Array memory exceeded. Increase xyBin and or reduce Interval.','Array too large');
    return
end

h=waitbar(0,'Creating Scattering Images...');

for m=1:p
    
    clear row; clear column;
    
    if m==1
    [row,column]=find((z(:,4)>=((m-1)*interval))&(z(:,4)<(m*interval)));

    else        
    [row,column]=find((z(:,4)>=((m-1)*interval+1))&(z(:,4)<(m*interval)));
    
    end
    
        for i = 1: length(row)
            
        sumImage(uint16(z(row(i),1)/handles.xyBin),uint16(z(row(i),2)/handles.xyBin),m) = sumImage(uint16(z(row(i),1)/handles.xyBin),uint16(z(row(i),2)/handles.xyBin),m)+1;
        
        end
        
        waitbar(m/p);
        
end
        
close(h);

handles.sumImage=sumImage;

handles.orderedData=z;

handles.Intensity_sum=zeros(length(handles.sumImage(1,1,:)),1);

clear k;

h=waitbar(0,'Calculating Normalization Matrix...');
for k = 1:length(handles.sumImage(1,1,:))
    handles.Intensity_sum(k) = sum(sum(handles.sumImage(:,:,k)));
    waitbar(k/length(handles.sumImage(1,1,:)));
end
close(h);

clear i, clear k;

h=waitbar(0,'Normalizing Data...');
for k = 1:length(handles.Intensity_sum)
   handles.normdata(:,:,k) = handles.sumImage(:,:,k)./handles.Intensity_sum(k);
   waitbar(k/(length(handles.Intensity_sum)));
end
close(h);

plot(1:length(handles.sumImage(1,1,:)),handles.Intensity_sum,...
                'Parent',handles.sumint,...
                'Color','b',...
                'LineStyle','-',...
                'Marker','o',...
                'MarkerSize',2,...
                'MarkerFaceColor','m')
xlim(handles.sumint,[0 length(handles.sumImage(1,1,:))])
ylim(handles.sumint,[0.5*min(handles.Intensity_sum) 1.2*max(handles.Intensity_sum)])
            
handles.sumint.XGrid= 'on';
handles.sumint.YGrid= 'on';
xlabel('Frame Number','Parent',handles.sumint);
ylabel('Total Counts','Parent',handles.sumint);
title('Total Counts on Each Frame','Parent',handles.sumint);

clear z;

set(handles.progress,'String','Data Summed');

setappdata(0,'rawdata',handles.sumImage);
setappdata(0,'data',handles.normdata);

set(handles.progress,'String','Scattering Images Created');

guidata(hObject, handles);

