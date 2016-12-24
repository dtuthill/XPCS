function varargout = linegraph(varargin)
% LINEGRAPH MATLAB code for linegraph.fig
%      LINEGRAPH, by itself, creates a new LINEGRAPH or raises the existing
%      singleton*.
%
%      H = LINEGRAPH returns the handle to a new LINEGRAPH or the handle to
%      the existing singleton*.
%
%      LINEGRAPH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LINEGRAPH.M with the given input arguments.
%
%      LINEGRAPH('Property','Value',...) creates a new LINEGRAPH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before linegraph_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to linegraph_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help linegraph

% Last Modified by GUIDE v2.5 07-Jul-2016 16:39:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @linegraph_OpeningFcn, ...
                   'gui_OutputFcn',  @linegraph_OutputFcn, ...
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


% --- Executes just before linegraph is made visible.
function linegraph_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to linegraph (see VARARGIN)

% Choose default command line output for linegraph
handles.output = hObject;

handles.g2ValueNormalized=getappdata(0,'g2normalization');
handles.g2ValueUnNormalized=getappdata(0,'g2unnormalization');
handles.tauInFrames=getappdata(0,'tauInFrames');
handles.tauInTime=getappdata(0,'tauInTime');

handles.xv=str2num(get(handles.x,'String'));
handles.xv=str2num(get(handles.y,'String'));


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes linegraph wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = linegraph_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in graph.
function graph_Callback(hObject, eventdata, handles)
% hObject    handle to graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.q2v);

g2ValueNormalized=squeeze(handles.g2ValueNormalized(handles.xv,handles.yv,:));
g2ValueUnNormalized=squeeze(handles.g2ValueUnNormalized(handles.xv,handles.yv,:));

displayPlot='';

switch(get(handles.n,'Value'))
    case 1
        switch(get(handles.s,'Value'))
            case 1
                displayPlot='ns';
            case 0
                displayPlot='nf';
        end
    case 0
        switch(get(handles.s,'Value'))
            case 1
                displayPlot='us';
            case 0
                displayPlot='uf';
        end
end

clear legendMatrix;

switch(displayPlot)
    
    case('nf')
        
        switch(get(handles.li,'Value'))
            
            case(1)

        plot(handles.tauInFrames,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        
            case(0)
                
        semilogx(handles.tauInFrames,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        
        end

    case('ns')
        
        switch(get(handles.li,'Value'))
            
            case(1)
        
        plot(handles.tauInTime,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);   
        
            case(0)
                
        semilogx(handles.tauInTime,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        
        end
        
    case('uf')
        
        switch(get(handles.li,'Value'))
            
            case(1)
        
        plot(handles.tauInFrames,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        
            case(0)
                
        semilogx(handles.tauInFrames,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        
        end
        
    case('us')
        
        switch(get(handles.li,'Value'))
            
            case(1)
        
        plot(handles.tauInTime,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);    
        
            case(0)
        
        semilogx(handles.tauInTime,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);   
        
        end
        
end

handles.numqpara=1;
handles.displayPlot=displayPlot;

setappdata(0,'tau',handles.tauInTime);
setappdata(0,'g2fit',g2ValueNormalized);
setappdata(0,'g2ufit',g2ValueUnNormalized);
setappdata(0,'tauF',handles.tauInFrames);
setappdata(0,'numqpara',handles.numqpara);
setappdata(0,'displayPlot',handles.displayPlot);
setappdata(0,'loglinear',get(handles.li,'Value'));





function y_Callback(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y as text
%        str2double(get(hObject,'String')) returns contents of y as a double

handles.yv=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_Callback(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x as text
%        str2double(get(hObject,'String')) returns contents of x as a double

handles.xv=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fitgui.
function fitgui_Callback(hObject, eventdata, handles)
% hObject    handle to fitgui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fitui
