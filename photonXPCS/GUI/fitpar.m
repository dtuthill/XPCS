function varargout = fitpar(varargin)
% FITPAR MATLAB code for fitpar.fig
%      FITPAR, by itself, creates a new FITPAR or raises the existing
%      singleton*.
%
%      H = FITPAR returns the handle to a new FITPAR or the handle to
%      the existing singleton*.
%
%      FITPAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FITPAR.M with the given input arguments.
%
%      FITPAR('Property','Value',...) creates a new FITPAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fitpar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fitpar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fitpar

% Last Modified by GUIDE v2.5 09-Aug-2016 15:57:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fitpar_OpeningFcn, ...
                   'gui_OutputFcn',  @fitpar_OutputFcn, ...
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


% --- Executes just before fitpar is made visible.
function fitpar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fitpar (see VARARGIN)

% Choose default command line output for fitpar
handles.output = hObject;

cla(handles.q2v,'reset');

handles.tauInTime=getappdata(0,'tau');
handles.g2ValueNormalized=getappdata(0,'g2fit');
handles.g2ValueUnNormalized=getappdata(0,'g2ufit');
handles.tauInFrames=getappdata(0,'tauF');
handles.numqpara=getappdata(0,'numqpara');
handles.displayPlot=getappdata(0,'displayPlot');
handles.loglinear=getappdata(0,'loglinear');
handles.curvenumber=getappdata(0,'m');
handles.fittype=getappdata(0,'fittype');
handles.par1=getappdata(0,'aval');
handles.par2=getappdata(0,'bval');
handles.par3=getappdata(0,'cval');
handles.par4=getappdata(0,'dval');
set(handles.formula,'String',getappdata(0,'formula'));

m=handles.curvenumber;

try
if handles.par1=='null';
    set(handles.text1,'String','');
    set(handles.var1string,'String','');
    set(handles.var1string,'Enable','off');
end
catch
    set(handles.var1string,'String',handles.par1{m});
end

try
if handles.par2=='null';
    set(handles.text2,'String','');
    set(handles.var2string,'String','');
    set(handles.var2string,'Enable','off');
end
catch
    set(handles.var2string,'String',handles.par2{m});
end

try
if handles.par3=='null';
    set(handles.text3,'String','');
    set(handles.var3string,'String','');
    set(handles.var3string,'Enable','off');
end
catch
    set(handles.var3string,'String',handles.par3{m});
end

try
if handles.par4=='null';
    set(handles.text4,'String','');
    set(handles.var4string,'String','');
    set(handles.var4string,'Enable','off');
end
catch
    set(handles.var4string,'String',handles.par4{m});
end

a=str2num(get(handles.var1string,'String'));
b=str2num(get(handles.var2string,'String'));
c=str2num(get(handles.var3string,'String'));
d=str2num(get(handles.var4string,'String'));

cla(handles.q2v,'reset');

clear f(x);

syms f(x)

if strcmp(handles.fittype,'poly1');
    
    f(x)=a*x+b;
    
elseif strcmp(handles.fittype,'poly2');
    
    f(x)=a*x^2+b*x+c;
    
elseif strcmp(handles.fittype,'poly3');

    f(x)=a*x^3+b*x^2+c*x+d;
    
elseif strcmp(handles.fittype,'exp1');
    
    f(x)=a*exp(b*x);
    
elseif strcmp(handles.fittype,'exp2');
    
    f(x)=a*exp(b*x)+c*exp(d*x);
    
elseif strcmp(handles.fittype,'fourier1');

    f(x)=a+b*cos(x*d)+c*sin(x*d);
    
elseif strcmp(handles.fittype,'sin1');
    
    f(x)=a*sin(b*x+c);
    
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')
        
        h=waitbar(0,'Initializing Parameters');
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInFrames(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        close(h)

    case('ns')
        
        h=waitbar(0,'Initializing Parameters');
        plot(handles.tauInTime(:,m),handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInTime(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        close(h)
        
    case('uf')
        
        h=waitbar(0,'Initializing Parameters');
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInFrames(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        close(h)
        
    case('us')        
        
        h=waitbar(0,'Initializing Parameters');
        plot(handles.tauInTime(:,m),handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInTime(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        close(h)
        
end

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')
        
        h=waitbar(0,'Initializing Parameters');
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInFrames(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        close(h)

    case('ns')
        
        h=waitbar(0,'Initializing Parameters');
        semilogx(handles.tauInTime(:,m),handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInTime(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        close(h)
        
    case('uf')
        
        h=waitbar(0,'Initializing Parameters');
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInFrames(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        close(h)
        
    case('us')        
        
        h=waitbar(0,'Initializing Parameters');
        semilogx(handles.tauInTime(:,m),handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInTime(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        close(h)
        
end

end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fitpar wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fitpar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in fitgo.
function fitgo_Callback(hObject, eventdata, handles)
% hObject    handle to fitgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a=str2num(get(handles.var1string,'String'));
b=str2num(get(handles.var2string,'String'));
c=str2num(get(handles.var3string,'String'));
d=str2num(get(handles.var4string,'String'));

m=handles.curvenumber;

cla(handles.q2v,'reset');

clear f(x);

syms f(x)

if strcmp(handles.fittype,'poly1');
    
    f(x)=a*x+b;
    
elseif strcmp(handles.fittype,'poly2');
    
    f(x)=a*x^2+b*x+c;
    
elseif strcmp(handles.fittype,'poly3');

    f(x)=a*x^3+b*x^2+c*x+d;
    
elseif strcmp(handles.fittype,'exp1');
    
    f(x)=a*exp(b*x);
    
elseif strcmp(handles.fittype,'exp2');
    
    f(x)=a*exp(b*x)+c*exp(d*x);
    
elseif strcmp(handles.fittype,'fourier1');

    f(x)=a+b*cos(x*d)+c*sin(x*d);
    
elseif strcmp(handles.fittype,'sin1');
    
    f(x)=a*sin(b*x+c);
    
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')
        
        h=waitbar(0,'Adjusting Parameters');
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInFrames(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        close(h)

    case('ns')
        
        h=waitbar(0,'Adjusting Parameters');
        plot(handles.tauInTime(:,m),handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInTime(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        close(h)
        
    case('uf')
        
        h=waitbar(0,'Adjusting Parameters');
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInFrames(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        close(h)
        
    case('us')        
        
        h=waitbar(0,'Adjusting Parameters');
        plot(handles.tauInTime(:,m),handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInTime(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        close(h)
        
end

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')
        
        h=waitbar(0,'Adjusting Parameters');
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInFrames(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        close(h)

    case('ns')
        
        h=waitbar(0,'Adjusting Parameters');
        semilogx(handles.tauInTime(:,m),handles.g2ValueNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInTime(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        close(h)
        
    case('uf')
        
        h=waitbar(0,'Adjusting Parameters');
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInFrames(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        close(h)
        
    case('us')        
        
        h=waitbar(0,'Adjusting Parameters');
        semilogx(handles.tauInTime(:,m),handles.g2ValueUnNormalized(:,m),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        hold(handles.q2v,'on');
        fplot(f,[0 max(handles.tauInTime(:,1))],'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        close(h)
        
end

end

guidata(hObject, handles);



function var1string_Callback(hObject, eventdata, handles)
% hObject    handle to var1string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var1string as text
%        str2double(get(hObject,'String')) returns contents of var1string as a double


% --- Executes during object creation, after setting all properties.
function var1string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var1string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function var2string_Callback(hObject, eventdata, handles)
% hObject    handle to var2string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var2string as text
%        str2double(get(hObject,'String')) returns contents of var2string as a double


% --- Executes during object creation, after setting all properties.
function var2string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var2string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function var3string_Callback(hObject, eventdata, handles)
% hObject    handle to var3string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var3string as text
%        str2double(get(hObject,'String')) returns contents of var3string as a double


% --- Executes during object creation, after setting all properties.
function var3string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var3string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function var4string_Callback(hObject, eventdata, handles)
% hObject    handle to var4string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var4string as text
%        str2double(get(hObject,'String')) returns contents of var4string as a double


% --- Executes during object creation, after setting all properties.
function var4string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var4string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
