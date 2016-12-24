function varargout = curveviewer(varargin)
% CURVEVIEWER MATLAB code for curveviewer.fig
%      CURVEVIEWER, by itself, creates a new CURVEVIEWER or raises the existing
%      singleton*.
%
%      H = CURVEVIEWER returns the handle to a new CURVEVIEWER or the handle to
%      the existing singleton*.
%
%      CURVEVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CURVEVIEWER.M with the given input arguments.
%
%      CURVEVIEWER('Property','Value',...) creates a new CURVEVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before curveviewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to curveviewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help curveviewer

% Last Modified by GUIDE v2.5 16-Nov-2016 13:26:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @curveviewer_OpeningFcn, ...
                   'gui_OutputFcn',  @curveviewer_OutputFcn, ...
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


% --- Executes just before curveviewer is made visible.
function curveviewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to curveviewer (see VARARGIN)

% Choose default command line output for curveviewer
handles.output = hObject;

addpath('figureSAVE');

handles.p=getappdata(0,'p');
handles.auto=getappdata(0,'auto');
handles.autotime=getappdata(0,'autotime');
handles.arrivalTimeInNsec=getappdata(0,'arrivalTimeInNsec');
handles.interval=getappdata(0,'interval');
handles.ROIOrFullPeak=getappdata(0,'caseswitch');

cla(handles.imgauto);

switch (get(handles.loglin,'Value'))
    case 0
        set(handles.imgauto, 'XScale', 'log', 'YScale', 'log')
    case 1
        set(handles.imgauto, 'XScale', 'log', 'YScale', 'linear')
end

curve_string={};

for m=1:handles.p

switch(handles.ROIOrFullPeak)
    
    case 'Full'
    
    try
        hold(handles.imgauto,'on')
        loglog(handles.autotime(:,m)*1e-9,handles.auto(:,m),'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
        xlabel('Delay Time (sec)','Parent',handles.imgauto);
        ylabel('g2','Parent',handles.imgauto);
        title('g2 curve for the whole Bragg peak','Parent',handles.imgauto);
    catch
    end
    
    curve_string=[curve_string;{sprintf('Curve %d',m)}];

    case 'ROI'
    
    try
        hold(handles.imgauto,'on')
        loglog(handles.autotime(:,m)*1e-9,handles.auto(:,m),'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
        xlabel('Delay Time (sec)','Parent',handles.imgauto);
        ylabel('g2','Parent',handles.imgauto);
        title('g2 curve for ROI pixels','Parent',handles.imgauto);
    catch
    end
    
    curve_string=[curve_string;{sprintf('Curve %d',m)}];

end

end

switch(handles.ROIOrFullPeak)
    
    case 'Full'
        
handles.auto_avg=mean(handles.auto(:,1:(handles.p-1)),2);
handles.auto_total=[handles.auto_avg,handles.auto];
curve_string=['Average';curve_string];

if handles.autotime(1,1)==0

hold(handles.imgauto,'on')
loglog(handles.autotime(:,2)*1e-9,handles.auto_total(:,m),'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
xlabel('Delay Time (sec)','Parent',handles.imgauto);
ylabel('g2','Parent',handles.imgauto);
title('g2 curve for the whole Bragg peak','Parent',handles.imgauto);

else

hold(handles.imgauto,'on')
loglog(handles.autotime(:,1)*1e-9,handles.auto_total(:,m),'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
xlabel('Delay Time (sec)','Parent',handles.imgauto);
ylabel('g2','Parent',handles.imgauto);
title('g2 curve for the whole Bragg peak','Parent',handles.imgauto);

end

    case 'ROI'
        
handles.auto_avg=mean(handles.auto(:,1:(handles.p-1)),2);
handles.auto_total=[handles.auto_avg,handles.auto];
curve_string=['Average';curve_string];

if handles.autotime(1,1)==0

hold(handles.imgauto,'on')
loglog(handles.autotime(:,2)*1e-9,handles.auto_total(:,m),'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
xlabel('Delay Time (sec)','Parent',handles.imgauto);
ylabel('g2','Parent',handles.imgauto);
title('g2 curve for ROI pixels','Parent',handles.imgauto);

else

hold(handles.imgauto,'on')
loglog(handles.autotime(:,1)*1e-9,handles.auto_total(:,m),'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
xlabel('Delay Time (sec)','Parent',handles.imgauto);
ylabel('g2','Parent',handles.imgauto);
title('g2 curve for ROI pixels','Parent',handles.imgauto);

end

end

set(handles.curveselect,'String',curve_string);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes curveviewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = curveviewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in curveselect.
function curveselect_Callback(hObject, eventdata, handles)
% hObject    handle to curveselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns curveselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from curveselect

cla(handles.imgauto,'reset');

switch (get(handles.loglin,'Value'))
    case 0
        ll=0;
        set(handles.imgauto, 'XScale', 'log', 'YScale', 'log')
    case 1
        ll=1;
        set(handles.imgauto, 'XScale', 'linear', 'YScale', 'log')
end

m=get(handles.curveselect,'Value');

switch(handles.ROIOrFullPeak)
    
    case 'Full'

for k=1:handles.p        
        
if handles.autotime(1,k)==0

else

switch ll
    case 0
        loglog(handles.autotime(:,k)*1e-9,handles.auto_total(:,m),'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
    case 1
        semilogy(handles.autotime(:,k)*1e-9,handles.auto_total(:,m),'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
end

xlabel('Delay Time (sec)','Parent',handles.imgauto);
ylabel('g2','Parent',handles.imgauto);
title('g2 curve for the whole Bragg peak','Parent',handles.imgauto);

break

end

end

    case 'ROI'
        
for k=1:handles.p     
        
if handles.autotime(1,k)==0

else
    
switch ll
    case 0
        loglog(handles.autotime(:,k)*1e-9,handles.auto_total(:,m),'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
    case 1
        semilogy(handles.autotime(:,k)*1e-9,handles.auto_total(:,m),'-','LineWidth',2,'MarkerSize',4,'Parent',handles.imgauto);
end

xlabel('Delay Time (sec)','Parent',handles.imgauto);
ylabel('g2','Parent',handles.imgauto);
title('g2 curve for ROI pixels','Parent',handles.imgauto);

break

end

end

end
    



% --- Executes during object creation, after setting all properties.
function curveselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curveselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in loglog.
function loglog_Callback(hObject, eventdata, handles)
% hObject    handle to loglog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linlin

% --- Executes on button press in linlin.
function loglin_Callback(hObject, eventdata, handles)
% hObject    handle to linlin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linlin


% --- Executes on button press in saveplot.
function saveplot_Callback(hObject, eventdata, handles)
% hObject    handle to saveplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uiputfile({'*.jpg';'*.png';'*.*'},'Save your GUI settings');
 
if pathname == 0 %if the user pressed cancelled, then we exit this callback
    return
end

export_fig(handles.imgauto,fullfile(pathname,filename),'-m2')