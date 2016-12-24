function varargout = fastXPCS(varargin)
% FASTXPCS MATLAB code for fastXPCS.fig
%      FASTXPCS, by itself, creates a new FASTXPCS or raises the existing
%      singleton*.
%
%      H = FASTXPCS returns the handle to a new FASTXPCS or the handle to
%      the existing singleton*.
%
%      FASTXPCS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FASTXPCS.M with the given input arguments.
%
%      FASTXPCS('Property','Value',...) creates a new FASTXPCS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fastXPCS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fastXPCS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fastXPCS

% Last Modified by GUIDE v2.5 02-Dec-2016 01:18:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fastXPCS_OpeningFcn, ...
                   'gui_OutputFcn',  @fastXPCS_OutputFcn, ...
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


% --- Executes just before fastXPCS is made visible.
function fastXPCS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fastXPCS (see VARARGIN)

% Choose default command line output for fastXPCS
handles.output = hObject;

addpath('GUI');
addpath('GUI/figureSAVE');
cla(handles.zzdisp);
cla(handles.imgsum);
cla(handles.imgarrive);
cla(handles.imgauto);

set(handles.progress,'String','');
set(handles.filestring,'String','');
set(handles.timelabel,'String','');
handles.xyBin=str2num(get(handles.bin,'String'));

contents=cellstr(get(handles.g2select,'String'));
choices=contents{get(handles.g2select,'Value')};

if (strcmp(choices,'ROI'));
    handles.ROIOrFullPeak='ROI';
    set(findall(handles.roipanel, '-property', 'enable'), 'enable', 'on');
    
elseif (strcmp(choices,'Full Peak'));
    handles.ROIOrFullPeak='Full';
    set(findall(handles.roipanel, '-property', 'enable'), 'enable', 'off');
    
end

handles.startPixelX=str2num(get(handles.startpixelX,'String'));
handles.startPixelY=str2num(get(handles.startpixelY,'String'));
handles.endPixelX=str2num(get(handles.endpixelX,'String'));
handles.endPixelY=str2num(get(handles.endpixelY,'String'));

set(handles.ninterval,'Enable','On');

handles.vvNcasc=str2num(get(handles.vNcasc,'String'));
handles.vvNsub=str2num(get(handles.vNsub,'String'));

handles.interval=str2num(get(handles.tinterval,'String'));

handles.errorremove=0;

set(handles.finterval,'Value',0)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fastXPCS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fastXPCS_OutputFcn(hObject, eventdata, handles) 
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
cla(handles.imgsum);
cla(handles.imgarrive);
cla(handles.imgauto);

handles.errorremove=0;

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

cla(handles.imgsum,'reset');
cla(handles.imgarrive);
cla(handles.imgauto);
set(handles.progress,'String','Summing Data...');

handles.errorremove=0;

handles.data=handles.zz;

nandata=find(handles.data(:,1)==0 & handles.data(:,2)==0);
handles.data(nandata,:)=[];

% Col 1 = X coordinate of pixel
% Col 2 = Y coordinate of pixel 
% Col 3 = gain of detector          
% Col 4 = Time at which photons arrived

% bin in pixel, 8 means 4096 pixel become 4096/8=512 pixel

totalPixel = 4096;
pixelBin = totalPixel/handles.xyBin;
sumImage = zeros(pixelBin,pixelBin);

%h=waitbar(0,'Summing Data...');

for i = 1: length(handles.data)
    
        sumImage(uint16(handles.data(i,1)/handles.xyBin),uint16(handles.data(i,2)/handles.xyBin)) = sumImage(uint16(handles.data(i,1)/handles.xyBin),uint16(handles.data(i,2)/handles.xyBin)) + 1;
        
        %waitbar(i/length(handles.data);
    
end

%close(h);

handles.sumImage=sumImage;

imagesc(sumImage,'Parent',handles.imgsum);

setappdata(0,'data',sumImage);

% Convert all time by taking into account the wraps

diffValue = int64(diff(int32(handles.data(:,4))));
%numWrapIndices = find(diffValue < -21000000);
numWrapIndices = find(diffValue < 0);
numWrap = length(numWrapIndices);

clear i; clear j;

z = int64(handles.data(:,4));
%plot(zz(:,4));

set(handles.progress,'String','Converting Time...');

%h=waitbar(0,'Converting Time...');

for i=1:numWrap-1
    
    sumv=0;
    for k=1:i
        sumv=sumv+abs(diffValue(numWrapIndices(k)));
    end
    
    for j = numWrapIndices(i) : numWrapIndices(i+1)-1
        z(j+1) = z(j+1)+sumv;
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
    
    z(j) = z(j)+sumv;
    
        %waitbar(j/(length(handles.data(:,4))))
end

z=z-min(z);

%close(h);

handles.arrivalTimeInNsec = double(z .* 40);  % converts time in nanoseconds in double

%nandata=find(handles.arrivalTimeInNsec<=round(min(handles.arrivalTimeInNsec),-8));      %removes weird initial data points
%handles.arrivalTimeInNsec(nandata)=[];

plot(handles.arrivalTimeInNsec,'Parent',handles.imgarrive);
title('Arrival Time','Parent',handles.imgarrive)

clear z; clear diffValue;

set(handles.progress,'String','Data Summed');
set(handles.timelabel,'String',num2str(max(handles.arrivalTimeInNsec)*1e-9));

guidata(hObject, handles);



% End of time conversion


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
    
elseif (strcmp(choices,'Full Peak'));
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


% --- Executes on button press in fastg2.
function fastg2_Callback(hObject, eventdata, handles)
% hObject    handle to fastg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.imgauto,'reset');
cla(handles.imgsum);

imagesc(handles.sumImage,'Parent',handles.imgsum);

switch (handles.ROIOrFullPeak)
    case'Full'
    case'ROI'
        hold(handles.imgsum,'on')
            handles.recta=rectangle('Position',handles.rect,'Parent',handles.imgsum,'EdgeColor','r');
end

set(handles.progress,'String','Calculating g2...');

% calculates g2 function for given sets of pixel coordinates from SSL
% detector

X1=handles.startPixelX;
X2=handles.endPixelX;
Y1=handles.startPixelY;
Y2=handles.endPixelY;

%X1=2046; Y1=2634; %for stripe
%X2=2113; Y2=2705;

%X1=2099; Y1=2466; % near center
%X2=2161; Y2=2496;

cla(handles.imgarrive);
interval=handles.interval*1e9;

h=waitbar(0,'Calculating g2...');

handles.vauto=[];
handles.vautotime=[];

switch (get(handles.finterval,'Value'))
    case 0
        p=str2num(get(handles.ninterval,'String'));
        if p>ceil(max(handles.arrivalTimeInNsec)/interval)
            errordlg('Number of intervals exceeds Data length. Please select less intervals.');
            close(h);
            return
        end
    case 1
        p=ceil(max(handles.arrivalTimeInNsec)/interval);
end

switch(get(handles.loglin,'Value'))
    case 0
         ll=0;
        set(handles.imgauto, 'XScale', 'log', 'YScale', 'log')
    case 1
         ll=1;
        set(handles.imgauto, 'XScale', 'log', 'YScale', 'linear')
end

%for m=1:ceil(length(handles.arrivalTimeInNsec)/interval)
for m=1:p
    
clear i; clear j; clear k;
k=1;
switch (handles.ROIOrFullPeak)
    case 'Full'
%         num = zeros(length(handles.arrivalTimeInNsec),1)+1; % this serves as "num" in tttr2xfcs routine
%         timeStampData = handles.arrivalTimeInNsec; 
%         [auto, autotime] = single_photon_xpcs(timeStampData,num,handles.vvNcasc,handles.vvNsub);
%         
%         plot(handles.arrivalTimeInNsec .* 1e-9,'Parent',handles.imgarrive);
%         xlabel('# events','Parent',handles.imgarrive);
%         ylabel('Time of arrival (sec)','Parent',handles.imgarrive);

        try
        %try
           %cutarrivalTimeInNsec=handles.arrivalTimeInNsec(((m-1)*interval+1):(m*interval));
           cutarrivalTimeInNsec=handles.arrivalTimeInNsec(find((handles.arrivalTimeInNsec>=((m-1)*interval+1))&(handles.arrivalTimeInNsec<(m*interval))));
        %catch
           %cutarrivalTimeInNsec=handles.arrivalTimeInNsec(((m-1)*interval+1):length(handles.arrivalTimeInNsec));
        %end

        num = zeros(length(cutarrivalTimeInNsec),1)+1; % this serves as "num" in tttr2xfcs routine
        timeStampData = cutarrivalTimeInNsec; 
        [auto, autotime] = single_photon_xpcs(timeStampData,num,handles.vvNcasc,handles.vvNsub);
        handles.vauto(:,m)=auto;
        handles.vautotime(:,m)=autotime;
        
        hold(handles.imgarrive,'on')
        plot(cutarrivalTimeInNsec .* 1e-9,'Parent',handles.imgarrive);
        xlabel('# events','Parent',handles.imgarrive);
        ylabel('Time of arrival (sec)','Parent',handles.imgarrive);
        
        hold(handles.imgauto,'on')
         switch ll
             case 0
                 loglog(autotime*1e-9,auto,'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
             case 1
                 semilogx(autotime*1e-9,auto,'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
         end
        xlabel('Delay Time (sec)','Parent',handles.imgauto);
        ylabel('g2','Parent',handles.imgauto);
        title('g2 curve for the whole Bragg peak','Parent',handles.imgauto);
        
        catch
        end
        
    case 'ROI'
        
%         timeStampDataIndices = find(((handles.data(:,1)>=X1)&(handles.data(:,1)<=X2))&((handles.data(:,2)>=Y1)&(handles.data(:,2)<=Y2)));
%         timeStampData = handles.arrivalTimeInNsec(timeStampDataIndices); % Arrival times in nanosec
%         num = zeros(length(timeStampData),1)+1; % this serves as "num" in tttr2xfcs routine
%         [auto, autotime] = single_photon_xpcs(timeStampData,num,handles.vvNcasc,handles.vvNsub);
%         
%         plot(timeStampData .* 1e-9,'Parent',handles.imgarrive);
%         xlabel('# events','Parent',handles.imgarrive);
%         ylabel('Time of arrival (sec)','Parent',handles.imgarrive);
% 
%         try
%            T=handles.arrivalTimeInNsec(m*interval);
%            TT=handles.arrivalTimeInNsec((m-1)*interval+1);
%         catch
%            T=handles.arrivalTimeInNsec(length(handles.arrivalTimeInNsec));
%            TT=handles.arrivalTimeInNsec((m-1)*interval+1);
%         end

try
    switch(handles.errorremove)
        case(0)
        timeStampDataIndices = find(((handles.data(:,1)>=X1)&(handles.data(:,1)<=X2))&((handles.data(:,2)>=Y1)&(handles.data(:,2)<=Y2)));   %&((handles.data(:,4)<=T)&(handles.data(:,4)>TT)));
        %cuttimeStampDataIndices=timeStampDataIndices(find((timeStampDataIndices<=(m*interval))&(timeStampDataIndices>((m-1)*interval+1))));
        timeStampData = handles.arrivalTimeInNsec(timeStampDataIndices); % Arrival times in nanosec
        cuttimeStampData=timeStampData(find((timeStampData>=((m-1)*interval+1))&(timeStampData<(m*interval))));
        num = zeros(length(cuttimeStampData),1)+1; % this serves as "num" in tttr2xfcs routine
        [auto, autotime] = single_photon_xpcs(cuttimeStampData,num,handles.vvNcasc,handles.vvNsub);
        handles.vauto(:,m)=auto;
        handles.vautotime(:,m)=autotime;
        
        hold(handles.imgarrive,'on')
        plot(cuttimeStampData .* 1e-9,'Parent',handles.imgarrive);
        xlabel('# events','Parent',handles.imgarrive);
        ylabel('Time of arrival (sec)','Parent',handles.imgarrive);
        
        hold(handles.imgauto,'on')
        switch ll
            case 0
                loglog(autotime*1e-9,auto,'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
            case 1
                semilogx(autotime*1e-9,auto,'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
        end
        xlabel('Delay Time (sec)','Parent',handles.imgauto);
        ylabel('g2','Parent',handles.imgauto);
        title('g2 curve for ROI pixels','Parent',handles.imgauto);
        
        case(1)
        timeStampDataIndices = find(((handles.data(:,1)>=X1)&(handles.data(:,1)<=X2))&((handles.data(:,2)>=Y1)&(handles.data(:,2)<=Y2)));   %&((handles.data(:,4)<=T)&(handles.data(:,4)>TT)));
        %cuttimeStampDataIndices=timeStampDataIndices(find((timeStampDataIndices<=(m*interval))&(timeStampDataIndices>((m-1)*interval+1))));
        timeStampData = handles.originaltime(timeStampDataIndices); % Arrival times in nanosec
        cuttimeStampData=timeStampData(find((timeStampData>=((m-1)*interval+1))&(timeStampData<(m*interval))));
        nandata=find(round(cuttimeStampData,-6)==0);      %removes weird initial data points
        cuttimeStampData(nandata)=[];
        num = zeros(length(cuttimeStampData),1)+1; % this serves as "num" in tttr2xfcs routine
        [auto, autotime] = single_photon_xpcs(cuttimeStampData,num,handles.vvNcasc,handles.vvNsub);
        handles.vauto(:,m)=auto;
        handles.vautotime(:,m)=autotime;
        
        hold(handles.imgarrive,'on')
        plot(cuttimeStampData .* 1e-9,'Parent',handles.imgarrive);
        xlabel('# events','Parent',handles.imgarrive);
        ylabel('Time of arrival (sec)','Parent',handles.imgarrive);
        
        hold(handles.imgauto,'on')
        switch ll
            case 0
                loglog(autotime*1e-9,auto,'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
            case 1
                semilogx(autotime*1e-9,auto,'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
        end
        xlabel('Delay Time (sec)','Parent',handles.imgauto);
        ylabel('g2','Parent',handles.imgauto);
        title('g2 curve for ROI pixels','Parent',handles.imgauto);
    end
catch
end
        
end

waitbar(m/p)

end

close(h)

set(handles.progress,'String','g2 Calculated');

setappdata(0,'auto',handles.vauto);
setappdata(0,'autotime',handles.vautotime);
setappdata(0,'arrivalTimeInNsec',handles.arrivalTimeInNsec);
setappdata(0,'interval',interval);
setappdata(0,'caseswitch',handles.ROIOrFullPeak);
setappdata(0,'p',p);

guidata(hObject, handles);



% --- Executes on button press in loadcompileddata.
function loadcompileddata_Callback(hObject, eventdata, handles)
% hObject    handle to loadcompileddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.filestring,'String','');
set(handles.timelabel,'String','');

handles.errorremove=0;

[filename,pathname]=uigetfile(fullfile(pwd,'*.fits'),'Select Data File');
addpath(pathname);
handles.PathName1=strcat(pathname,filename);
set(handles.filestring,'String',char(handles.PathName1));

set(handles.progress,'String','Loading Data...');

cla(handles.zzdisp);
cla(handles.imgsum);
cla(handles.imgarrive);
cla(handles.imgauto);

clear fastdataA1;
        
fastdataA1(:,:,1)=cell2mat(fitsread(handles.PathName1,'binarytable'));

handles.zz=[];
        
handles.zz(:,:) = fastdataA1(:,:,1);

nandata=find(handles.zz(:,2)==0);
handles.zz(nandata,:)=[];

plot(handles.zz(:,4),'Parent',handles.zzdisp);

set(handles.progress,'String','Data Loaded');

guidata(hObject, handles);



function startpixelX_Callback(hObject, eventdata, handles)
% hObject    handle to startpixelX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startpixelX as text
%        str2double(get(hObject,'String')) returns contents of startpixelX as a double

handles.startPixelX=str2num(get(hObject,'String'));

handles.rect=[handles.startPixelY handles.startPixelX (handles.endPixelY-handles.startPixelY) (handles.endPixelX-handles.startPixelX)];

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

handles.rect=[handles.startPixelY handles.startPixelX (handles.endPixelY-handles.startPixelY) (handles.endPixelX-handles.startPixelX)];

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

handles.rect=[handles.startPixelY handles.startPixelX (handles.endPixelY-handles.startPixelY) (handles.endPixelX-handles.startPixelX)];

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

handles.rect=[handles.startPixelY handles.startPixelX (handles.endPixelY-handles.startPixelY) (handles.endPixelX-handles.startPixelX)];

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


% --- Executes on button press in roiselect.
function roiselect_Callback(hObject, eventdata, handles)
% hObject    handle to roiselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fastselectregion;

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



function vNcasc_Callback(hObject, eventdata, handles)
% hObject    handle to vNcasc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vNcasc as text
%        str2double(get(hObject,'String')) returns contents of vNcasc as a double

handles.vvNcasc=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function vNcasc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vNcasc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vNsub_Callback(hObject, eventdata, handles)
% hObject    handle to vNsub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vNsub as text
%        str2double(get(hObject,'String')) returns contents of vNsub as a double

handles.vvNsub=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function vNsub_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vNsub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tinterval_Callback(hObject, eventdata, handles)
% hObject    handle to tinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tinterval as text
%        str2double(get(hObject,'String')) returns contents of tinterval as a double

handles.interval=str2num(get(hObject,'String'));

guidata(hObject, handles);


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


% --- Executes on button press in premove.
function premove_Callback(hObject, eventdata, handles)
% hObject    handle to premove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.imgarrive,'reset')

handles.originaltime=handles.arrivalTimeInNsec;

nandata=find(round(handles.arrivalTimeInNsec,-6)==0);      %removes weird initial data points
handles.arrivalTimeInNsec(nandata)=[];
handles.arrivalTimeInNsec=handles.arrivalTimeInNsec-min(handles.arrivalTimeInNsec);

plot(handles.arrivalTimeInNsec,'Parent',handles.imgarrive);
title('Arrival Time','Parent',handles.imgarrive)

set(handles.progress,'String','Data Corrected');
set(handles.timelabel,'String',num2str(max(handles.arrivalTimeInNsec)*1e-9));

handles.errorremove=1;

guidata(hObject, handles);


% --- Executes on button press in viewcurves.
function viewcurves_Callback(hObject, eventdata, handles)
% hObject    handle to viewcurves (see GCBO)
% eventdata  reserved - xto be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

curveviewer



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


% --- Executes on button press in linlin.
function loglog_Callback(hObject, eventdata, handles)
% hObject    handle to linlin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linlin

% --- Executes on button press in linlin.
function loglin_Callback(hObject, eventdata, handles)
% hObject    handle to linlin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linlin


% --- Executes on button press in savedata.
function savedata_Callback(hObject, eventdata, handles)
% hObject    handle to savedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

savefile=[handles.vautotime handles.vauto];
header='Delay Time, g2 Value';
[filename,pathname]=uiputfile('g2Values.txt','Select Save Location');
path=strcat(pathname,filename);
dlmwrite(path,header,'delimiter','');
dlmwrite(path,savefile,'-append','delimiter','\t','newline','pc','roffset',1);


