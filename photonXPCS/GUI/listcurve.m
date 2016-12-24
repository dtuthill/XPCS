function varargout = listcurve(varargin)
% LISTCURVE MATLAB code for listcurve.fig
%      LISTCURVE, by itself, creates a new LISTCURVE or raises the existing
%      singleton*.
%
%      H = LISTCURVE returns the handle to a new LISTCURVE or the handle to
%      the existing singleton*.
%
%      LISTCURVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LISTCURVE.M with the given input arguments.
%
%      LISTCURVE('Property','Value',...) creates a new LISTCURVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before listcurve_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to listcurve_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help listcurve

% Last Modified by GUIDE v2.5 09-Aug-2016 15:44:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @listcurve_OpeningFcn, ...
                   'gui_OutputFcn',  @listcurve_OutputFcn, ...
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


% --- Executes just before listcurve is made visible.
function listcurve_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to listcurve (see VARARGIN)

% Choose default command line output for listcurve
handles.output = hObject;

cla(handles.q2v,'reset');

handles.tauInTime=getappdata(0,'tau');
handles.g2ValueNormalized=getappdata(0,'g2fit');
handles.g2ValueUnNormalized=getappdata(0,'g2ufit');
handles.tauInFrames=getappdata(0,'tauF');
handles.numqpara=getappdata(0,'numqpara');
handles.displayPlot=getappdata(0,'displayPlot');
handles.loglinear=getappdata(0,'loglinear');

curve_string={};

for k=1:handles.numqpara;
    
    curve_string=[curve_string;{sprintf('Speckle %d',k)}];
    
end

set(handles.curvelist,'String',curve_string);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes listcurve wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = listcurve_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in curvelist.
function curvelist_Callback(hObject, eventdata, handles)
% hObject    handle to curvelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns curvelist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from curvelist

cla(handles.q2v,'reset');

m=get(hObject,'Value');

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')
        
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('handles.g2ValueNormalized','Parent',handles.q2v);

    case('ns')
        
        plot(handles.tauInTime(:,m),handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('handles.g2ValueNormalized','Parent',handles.q2v);
        
    case('uf')
        
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('handles.g2ValueUnNormalized','Parent',handles.q2v);
        
    case('us')        
        
        plot(handles.tauInTime(:,m),handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('handles.g2ValueUnNormalized','Parent',handles.q2v);
        
end

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')
        
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('handles.g2ValueNormalized','Parent',handles.q2v);

    case('ns')
        
        semilogx(handles.tauInTime(:,m),handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('handles.g2ValueNormalized','Parent',handles.q2v);
        
    case('uf')
        
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('handles.g2ValueUnNormalized','Parent',handles.q2v);
        
    case('us')        
        
        semilogx(handles.tauInTime(:,m),handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('handles.g2ValueUnNormalized','Parent',handles.q2v);
        
end

end

handles.m=m;

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function curvelist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curvelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in confirm.
function confirm_Callback(hObject, eventdata, handles)
% hObject    handle to confirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(0,'m',handles.m);

guidata(hObject, handles);

close(listcurve);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

uiresume;

delete(hObject);
