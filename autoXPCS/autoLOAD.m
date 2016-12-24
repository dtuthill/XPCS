function varargout = autoLOAD(varargin)
% AUTOLOAD MATLAB code for autoLOAD.fig
%      AUTOLOAD, by itself, creates a new AUTOLOAD or raises the existing
%      singleton*.
%
%      H = AUTOLOAD returns the handle to a new AUTOLOAD or the handle to
%      the existing singleton*.
%
%      AUTOLOAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTOLOAD.M with the given input arguments.
%
%      AUTOLOAD('Property','Value',...) creates a new AUTOLOAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before autoLOAD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to autoLOAD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help autoLOAD

% Last Modified by GUIDE v2.5 21-Nov-2016 12:09:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @autoLOAD_OpeningFcn, ...
                   'gui_OutputFcn',  @autoLOAD_OutputFcn, ...
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


% --- Executes just before autoLOAD is made visible.
function autoLOAD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to autoLOAD (see VARARGIN)

% Choose default command line output for autoLOAD
handles.output = hObject;

cla(handles.zzdisp);
cla(handles.imgsum);
cla(handles.sumint);
cla(handles.autoc);

set(handles.progress,'String','');
set(handles.filestring,'String','');
set(handles.timelabel,'String','');
set(handles.tinterval,'String','');
set(handles.ninterval,'String','');
set(handles.finterval,'Value',0);
handles.xyBin=str2num(get(handles.bin,'String'));

set(handles.ninterval,'Enable','On');

contents=cellstr(get(handles.g2select,'String'));
choices=contents{get(handles.g2select,'Value')};

if (strcmp(choices,'ROI'));
    handles.ROIOrFullPeak='ROI';
    set(findall(handles.roipanel, '-property', 'enable'), 'enable', 'on');
    
elseif (strcmp(choices,'Full Image'));
    handles.ROIOrFullPeak='Full';
    set(findall(handles.roipanel, '-property', 'enable'), 'enable', 'off');
    
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes autoLOAD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = autoLOAD_OutputFcn(hObject, eventdata, handles) 
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
cla(handles.imgsum);
cla(handles.autoc);

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
cla(handles.imgsum);
cla(handles.autoc);

handles.data=handles.zz;

% Col 1 = X coordinate of pixel
% Col 2 = Y coordinate of pixel 
% Col 3 = gain of detector          
% Col 4 = Time at which photons arrived

totalPixel = 4096;
pixelBin = totalPixel/handles.xyBin;
totsumImage = zeros(pixelBin,pixelBin);

%h=waitbar(0,'Summing Data...');

nandata=find(handles.data(:,1)==0 & handles.data(:,2)==0);
handles.data(nandata,:)=[];

for i = 1: length(handles.data)
    
        totsumImage(uint16(handles.data(i,1)/handles.xyBin),uint16(handles.data(i,2)/handles.xyBin)) = totsumImage(uint16(handles.data(i,1)/handles.xyBin),uint16(handles.data(i,2)/handles.xyBin)) + 1;
        
        %waitbar(i/length(handles.data);
    
end

%close(h);

handles.totsumImage=totsumImage;

imagesc(totsumImage,'Parent',handles.imgsum);

setappdata(0,'sumdata',totsumImage);

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

cla(handles.zzdisp);
cla(handles.sumint);
cla(handles.imgsum);
cla(handles.autoc);

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
        set(handles.totinterval,'Enable','On');
    case 1
        set(handles.totinterval,'Enable','Off');
end

% --- Executes on button press in createim.
function createim_Callback(hObject, eventdata, handles)
% hObject    handle to createim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.sumint);
cla(handles.autoc);

z=handles.zstore;

interval=str2num(get(handles.tinterval,'String'))*1e9;

% switch (get(handles.finterval,'Value'))
%     case 0
        p=str2num(get(handles.ninterval,'String'));
%     case 1
%         p=double(ceil(handles.max/interval));
% end

switch (get(handles.finterval,'Value'))
    case 0
        q=str2num(get(handles.totinterval,'String'));
    case 1
        q=double(ceil(handles.max/(p*interval)));
end

totalPixel = 4096;
pixelBin = totalPixel/handles.xyBin;

startX=str2num(get(handles.startpixelX,'String'))*handles.xyBin;
endX=str2num(get(handles.endpixelX,'String'))*handles.xyBin;
startY=str2num(get(handles.startpixelY,'String'))*handles.xyBin;
endY=str2num(get(handles.endpixelY,'String'))*handles.xyBin;

switch handles.ROIOrFullPeak
    case 'ROI'
        [row,column]=find((z(:,1)>=startX)&(endX>=z(:,1))&(z(:,2)>=startY)&(endY>=z(:,2)));
%         totrow=row;
        z=z(row,:);
    otherwise
end

try
    switch handles.ROIOrFullPeak
        case 'ROI'
            sumImage= zeros((endX-startX+1),(endY-startY+1),p,q);
        otherwise
            sumImage = zeros(pixelBin,pixelBin,p,q);
    end
catch 'MATLAB:array:SizeLimitExceeded';
    errordlg('Array memory exceeded. Increase xyBin, reduce number of intervals, and or reduce interval span.','Array too large');
    return
end

h=waitbar(0,'Calculating Interval Intensities...');

for n=1:q

for m=1:p
    
    clear row; clear column;
    
    if m==1
    [row,column]=find((z(:,4)>=((m-1)*interval+(n-1)*p*interval))&(z(:,4)<(m*interval+(n-1)*p*interval)));

    else        
    [row,column]=find((z(:,4)>=((m-1)*(interval)+1+(n-1)*p*interval))&(z(:,4)<(m*interval+(n-1)*p*interval)));
    end
    
%     switch handles.ROIOrFullPeak
%         case 'ROI'
%             row=intersect(row,totrow);
%         otherwise
%     end
    
        for i = 1: length(row)
            
            switch handles.ROIOrFullPeak
                case 'ROI'   
                    sumImage(uint16((z(row(i),1)-startX+1)/handles.xyBin),uint16((z(row(i),2)-startY+1)/handles.xyBin),m,n) = sumImage(uint16((z(row(i),1)-startX+1)/handles.xyBin),uint16((z(row(i),2)-startY+1)/handles.xyBin),m)+1;                
                otherwise                    
                    sumImage(uint16((z(row(i),1))/handles.xyBin),uint16((z(row(i),2))/handles.xyBin),m,n) = sumImage(uint16((z(row(i),1))/handles.xyBin),uint16((z(row(i),2))/handles.xyBin),m)+1;                    
            end

        
        end
        
        waitbar(m/p);
        
end

end
        
close(h);

cla(handles.imgsum,'reset')

imagesc(sumImage(:,:,1,1),'Parent',handles.imgsum);

handles.sumImage=sumImage;

handles.orderedData=z;

handles.Intensity_sum=zeros(length(handles.sumImage(1,1,:,1)),q);

clear k;

clear j;

h=waitbar(0,'Calculating Normalization Matrix...');

for j = 1:q

for k = 1:length(handles.sumImage(1,1,:,1))
    handles.Intensity_sum(k,j) = sum(sum(handles.sumImage(:,:,k,j)));
    waitbar(k/length(handles.sumImage(1,1,:,1)));
end

end
close(h);

handles.normdata=zeros(size(handles.sumImage));

clear i, clear k, clear j;

h=waitbar(0,'Normalizing Data...');
for j = 1:q

for k = 1:length(handles.Intensity_sum(:,1))
   handles.normdata(:,:,k,j) = handles.sumImage(:,:,k,j)./handles.Intensity_sum(k,j);
   waitbar(k/(length(handles.Intensity_sum(:,1))));
end

end
close(h);

sinterval=zeros(length(handles.sumImage(1,1,:,1)),q);

clear k, clear j;

h=waitbar(0,'Convering time...');

for j=1:q;

for k=1:length(handles.sumImage(1,1,:,1))
    sinterval(k,j)=k*interval*1e-9+sinterval(1,j);
    waitbar(k/length(handles.sumImage(1,1,:,1)));
end

end

close(h);

clear j;

for j=1:q;

plot(sinterval(:,j),handles.Intensity_sum(:,j),...
                'Parent',handles.sumint,...
                'LineStyle','-',...
                'Marker','o',...
                'MarkerSize',2)         
%                 'Color','b',...
%                 'MarkerFaceColor','m'
hold(handles.sumint,'on');

end
xlim(handles.sumint,[min(sinterval(:,1)) max(sinterval(:,q))])
ylim(handles.sumint,[0.5*min(min(handles.Intensity_sum(:,:))) 1.2*max(max(handles.Intensity_sum(:,:)))])
            
handles.sumint.XGrid= 'on';
handles.sumint.YGrid= 'on';
xlabel('Seconds','Parent',handles.sumint);
ylabel('Total Counts','Parent',handles.sumint);
title('Total Counts per Second','Parent',handles.sumint);

handles.p=p;
handles.sinterval=sinterval;
handles.q=q;

clear z;

setappdata(0,'rawdata',handles.sumImage);
setappdata(0,'data',handles.normdata);
setappdata(0,'startX',startX);
setappdata(0,'endX',endX);
setappdata(0,'startY',startY);
setappdata(0,'endY',endY);
setappdata(0,'ROIOrFullPeak',handles.ROIOrFullPeak);
setappdata(0,'xyBin',handles.xyBin);

set(handles.progress,'String','Interval Intensities Calculated');

guidata(hObject, handles);


% --- Executes on selection change in g2select.
function g2select_Callback(hObject, eventdata, handles)
% hObject    handle to g2select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns g2select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from g2select

contents=cellstr(get(hObject,'String'));
choices=contents{get(hObject,'Value')};

if (strcmp(choices,'ROI'));
    handles.ROIOrFullPeak='ROI';
    set(findall(handles.roipanel, '-property', 'enable'), 'enable', 'on');
    
elseif (strcmp(choices,'Full Image'));
    handles.ROIOrFullPeak='Full';
    set(findall(handles.roipanel, '-property', 'enable'), 'enable', 'off');
    
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function g2select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g2select (see GCBO)
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


% --- Executes on button press in roiselect.
function roiselect_Callback(hObject, eventdata, handles)
% hObject    handle to roiselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

autoselectregion;

uiwait;

handles.startPixelX=[];
handles.endPixelX=[];
handles.startPixelY=[];
handles.endPixelY=[];

handles.startPixelX=getappdata(0,'xmin');
handles.endPixelX=getappdata(0,'xmax');
handles.startPixelY=getappdata(0,'ymin');
handles.endPixelY=getappdata(0,'ymax');
handles.rect=getappdata(0,'rect');

handles.n=length(handles.startPixelX);

set(handles.startpixelX,'String',num2str(handles.startPixelX));
set(handles.endpixelX,'String',num2str(handles.endPixelX));
set(handles.startpixelY,'String',num2str(handles.startPixelY));
set(handles.endpixelY,'String',num2str(handles.endPixelY));

guidata(hObject, handles);


% --- Executes on button press in imview.
function imview_Callback(hObject, eventdata, handles)
% hObject    handle to imview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

autoimageviewer


% --- Executes on button press in autocorrelate.
function autocorrelate_Callback(hObject, eventdata, handles)
% hObject    handle to autocorrelate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.autoc,'reset');

% R=[];
% L=[];
% 
% for i=1:(length(handles.Intensity_sum(1,:))-1)
%     
%     a=(handles.Intensity_sum(:,i)-mean(handles.Intensity_sum(:,i)))/std(handles.Intensity_sum(:,i));
%     
%     for j=1:(length(handles.Intensity_sum(1,:))-1)
%         
%         if i<j
% 
%             b=(handles.Intensity_sum(:,j)-mean(handles.Intensity_sum(:,j)))/std(handles.Intensity_sum(:,j));
% 
%             [r,lags]=xcorr(a,b);
% 
%             hold on;
%             plot(lags,r,'Parent',handles.autoc)
% 
%             R=[R r];
%             L=[L; lags];
%             
%         else       
%         end
%         
%     end
%     
% end
% 
% Ravg=mean(R,2);
% Lavg=mean(L,1);
% 
% [acor,lags]=xcorr(a,b);
% 
% cla(handles.autoc);

[acf,lags,~]=autocorr(handles.Intensity_sum(:,1),90);

figure
plot(lags,acf);
xlim([0 5]);

% plot(Lavg,Ravg,'Parent',handles.autoc);

% pause(2)
% 
% figure
% autocorr(Ravg);

% ar(handles.Intensity_sum(1:(handles.p-1)),1)



function totinterval_Callback(hObject, eventdata, handles)
% hObject    handle to totinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of totinterval as text
%        str2double(get(hObject,'String')) returns contents of totinterval as a double


% --- Executes during object creation, after setting all properties.
function totinterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to totinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
