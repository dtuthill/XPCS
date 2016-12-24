function varargout = fitui(varargin)
% FITUI MATLAB code for fitui.fig
%      FITUI, by itself, creates var1 new FITUI or raises the existing
%      singleton*.
%
%      H = FITUI returns the handle to var1 new FITUI or the handle to
%      the existing singleton*.
%
%      FITUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FITUI.M with the given input arguments.
%
%      FITUI('Property','Value',...) creates var1 new FITUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fitui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fitui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fitui

% Last Modified by GUIDE v2.5 09-Aug-2016 16:10:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fitui_OpeningFcn, ...
                   'gui_OutputFcn',  @fitui_OutputFcn, ...
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


% --- Executes just before fitui is made visible.
function fitui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fitui (see VARARGIN)

% Choose default command line output for fitui
handles.output = hObject;

% UIWAIT makes fitui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

cla(handles.q2v,'reset');

set(handles.formula,'String','');
set(handles.text1,'String','');
set(handles.text2,'String','');
set(handles.text3,'String','');
set(handles.text4,'String','');

handles.tauInTime=getappdata(0,'tau');
handles.g2ValueNormalized=getappdata(0,'g2fit');
handles.g2ValueUnNormalized=getappdata(0,'g2ufit');
handles.tauInFrames=getappdata(0,'tauF');
handles.numqpara=getappdata(0,'numqpara');
handles.displayPlot=getappdata(0,'displayPlot');
handles.loglinear=getappdata(0,'loglinear');

legendfitMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendfitMatrix(n+n-1)={sprintf('Speckle %d',n)};
    legendfitMatrix(n+n)={sprintf('Fit %d',n)};
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')
        
        hold on;
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        hold on;
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        hold on;
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        hold on;
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')
        
        hold on;
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        hold on;
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        hold on;
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        hold on;
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

end

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = fitui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in fpoly1.
function fpoly1_Callback(hObject, eventdata, handles)
% hObject    handle to fpoly1 (see GCBO)
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fpoly1

set(handles.formula,'String','f(x)=p1*x+p2');
set(handles.text1,'String','p1:');
set(handles.text2,'String','p2:');
set(handles.text3,'String','');
set(handles.text4,'String','');
set(handles.var1,'String','');
set(handles.var2,'String','');
set(handles.var3,'String','');
set(handles.var4,'String','');

cla(handles.q2v,'reset');

legendfitMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendfitMatrix(n+n-1)={sprintf('Speckle %d',n)};
    legendfitMatrix(n+n)={sprintf('Fit %d',n)};
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'poly1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'poly1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'poly1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'poly1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'poly1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'poly1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'poly1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'poly1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);

end

cv='null';
dv='null';

setappdata(0,'aval',av);
setappdata(0,'bval',bv);
setappdata(0,'cval',cv);
setappdata(0,'dval',dv);

setappdata(0,'formula',get(handles.formula,'String'));

guidata(hObject, handles);


% --- Executes on button press in fpoly2.
function fpoly2_Callback(hObject, eventdata, handles)
% hObject    handle to fpoly2 (see GCBO)
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fpoly2

set(handles.formula,'String','f(x)=p1*x^3+p2*x^2+p3');
set(handles.text1,'String','p1:');
set(handles.text2,'String','p2:');
set(handles.text3,'String','p3:');
set(handles.text4,'String','');
set(handles.var1,'String','');
set(handles.var2,'String','');
set(handles.var3,'String','');
set(handles.var4,'String','');

cla(handles.q2v,'reset');

legendfitMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendfitMatrix(n+n-1)={sprintf('Speckle %d',n)};
    legendfitMatrix(n+n)={sprintf('Fit %d',n)};
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'poly2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'poly2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'poly2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'poly2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'poly2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'poly2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'poly2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'poly2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);

end

dv='null';

setappdata(0,'aval',av);
setappdata(0,'bval',bv);
setappdata(0,'cval',cv);
setappdata(0,'dval',dv);

setappdata(0,'formula',get(handles.formula,'String'));

guidata(hObject, handles);


% --- Executes on button press in fpoly3.
function fpoly3_Callback(hObject, eventdata, handles)
% hObject    handle to fpoly3 (see GCBO)
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fpoly3

set(handles.formula,'String','f(x)=p1*x^3+p2*x^2+p3*x+p4');
set(handles.text1,'String','p1:');
set(handles.text2,'String','p2:');
set(handles.text3,'String','p3:');
set(handles.text4,'String','p4:');
set(handles.var1,'String','');
set(handles.var2,'String','');
set(handles.var3,'String','');
set(handles.var4,'String','');

cla(handles.q2v,'reset');

legendfitMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendfitMatrix(n+n-1)={sprintf('Speckle %d',n)};
    legendfitMatrix(n+n)={sprintf('Fit %d',n)};
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'poly3');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        dv(k)={num2str(f2.p4)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'poly3');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        dv(k)={num2str(f2.p4)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'poly3');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        dv(k)={num2str(f2.p4)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'poly3');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        dv(k)={num2str(f2.p4)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);
set(handles.var4,'String',dv);

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'poly3');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        dv(k)={num2str(f2.p4)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'poly3');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        dv(k)={num2str(f2.p4)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'poly3');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        dv(k)={num2str(f2.p4)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'poly3');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.p1)};
        bv(k)={num2str(f2.p2)};
        cv(k)={num2str(f2.p3)};
        dv(k)={num2str(f2.p4)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);
set(handles.var4,'String',dv);

end

setappdata(0,'aval',av);
setappdata(0,'bval',bv);
setappdata(0,'cval',cv);
setappdata(0,'dval',dv);
setappdata(0,'formula',get(handles.formula,'String'));

guidata(hObject, handles);


% --- Executes on button press in fexp1.
function fexp1_Callback(hObject, eventdata, handles)
% hObject    handle to fexp1 (see GCBO)
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fexp1

set(handles.formula,'String','f(x)=a*exp(b*x)');
set(handles.text1,'String','a:');
set(handles.text2,'String','b:');
set(handles.text3,'String','');
set(handles.text4,'String','');
set(handles.var1,'String','');
set(handles.var2,'String','');
set(handles.var3,'String','');
set(handles.var4,'String','');

cla(handles.q2v,'reset');

legendfitMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendfitMatrix(n+n-1)={sprintf('Speckle %d',n)};
    legendfitMatrix(n+n)={sprintf('Fit %d',n)};
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'exp1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'exp1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'exp1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'exp1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'exp1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'exp1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'exp1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'exp1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);

end

cv='null';
dv='null';

setappdata(0,'aval',av);
setappdata(0,'bval',bv);
setappdata(0,'cval',cv);
setappdata(0,'dval',dv);

setappdata(0,'formula',get(handles.formula,'String'));

guidata(hObject, handles);




% --- Executes on button press in fexp2.
function fexp2_Callback(hObject, eventdata, handles)
% hObject    handle to fexp2 (see GCBO)
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fexp2

set(handles.formula,'String','f(x)=a*exp(b*x)+c*exp(d*x)');
set(handles.text1,'String','a:');
set(handles.text2,'String','b:');
set(handles.text3,'String','c:');
set(handles.text4,'String','d:');
set(handles.var1,'String','');
set(handles.var2,'String','');
set(handles.var3,'String','');
set(handles.var4,'String','');

cla(handles.q2v,'reset');

legendfitMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendfitMatrix(n+n-1)={sprintf('Speckle %d',n)};
    legendfitMatrix(n+n)={sprintf('Fit %d',n)};
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'exp2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        dv(k)={num2str(f2.d)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'exp2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        dv(k)={num2str(f2.d)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'exp2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        dv(k)={num2str(f2.d)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'exp2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        dv(k)={num2str(f2.d)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);
set(handles.var4,'String',dv);

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'exp2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        dv(k)={num2str(f2.d)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'exp2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        dv(k)={num2str(f2.d)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'exp2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        dv(k)={num2str(f2.d)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'exp2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        dv(k)={num2str(f2.d)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);
set(handles.var4,'String',dv);

end

setappdata(0,'aval',av);
setappdata(0,'bval',bv);
setappdata(0,'cval',cv);
setappdata(0,'dval',dv);

setappdata(0,'formula',get(handles.formula,'String'));

guidata(hObject, handles);


% --- Executes on button press in ffourier.
function ffourier_Callback(hObject, eventdata, handles)
% hObject    handle to ffourier (see GCBO)
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ffourier

set(handles.formula,'String','f(x)=a0+a1*cos(x*p)+b1*sin(x*p)');
set(handles.text1,'String','a0:');
set(handles.text2,'String','a1:');
set(handles.text3,'String','b1:');
set(handles.text4,'String','p:');
set(handles.var1,'String','');
set(handles.var2,'String','');
set(handles.var3,'String','');
set(handles.var4,'String','');

cla(handles.q2v,'reset');

legendfitMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendfitMatrix(n+n-1)={sprintf('Speckle %d',n)};
    legendfitMatrix(n+n)={sprintf('Fit %d',n)};
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'fourier1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a0)};
        bv(k)={num2str(f2.a1)};
        cv(k)={num2str(f2.b1)};
        dv(k)={num2str(f2.w)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'fourier1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a0)};
        bv(k)={num2str(f2.a1)};
        cv(k)={num2str(f2.b1)};
        dv(k)={num2str(f2.w)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'fourier1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a0)};
        bv(k)={num2str(f2.a1)};
        cv(k)={num2str(f2.b1)};
        dv(k)={num2str(f2.w)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'fourier1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a0)};
        bv(k)={num2str(f2.a1)};
        cv(k)={num2str(f2.b1)};
        dv(k)={num2str(f2.w)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);
set(handles.var4,'String',dv);

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'fourier1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a0)};
        bv(k)={num2str(f2.a1)};
        cv(k)={num2str(f2.b1)};
        dv(k)={num2str(f2.w)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'fourier1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a0)};
        bv(k)={num2str(f2.a1)};
        cv(k)={num2str(f2.b1)};
        dv(k)={num2str(f2.w)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'fourier1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a0)};
        bv(k)={num2str(f2.a1)};
        cv(k)={num2str(f2.b1)};
        dv(k)={num2str(f2.w)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'fourier1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a0)};
        bv(k)={num2str(f2.a1)};
        cv(k)={num2str(f2.b1)};
        dv(k)={num2str(f2.w)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);
set(handles.var4,'String',dv);

end

setappdata(0,'aval',av);
setappdata(0,'bval',bv);
setappdata(0,'cval',cv);
setappdata(0,'dval',dv);

setappdata(0,'formula',get(handles.formula,'String'));

guidata(hObject, handles);


% --- Executes on button press in fgauss.
function fgauss_Callback(hObject, eventdata, handles)
% hObject    handle to fgauss (see GCBO)
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fgauss

set(handles.formula,'String','f(x)=a1*exp(-((x-b1)/c1)^2)');
set(handles.text1,'String','a1:');
set(handles.text2,'String','b1:');
set(handles.text3,'String','c1:');
set(handles.text4,'String','');
set(handles.var1,'String','');
set(handles.var2,'String','');
set(handles.var3,'String','');
set(handles.var4,'String','');

cla(handles.q2v,'reset');

legendfitMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendfitMatrix(n+n-1)={sprintf('Speckle %d',n)};
    legendfitMatrix(n+n)={sprintf('Fit %d',n)};
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'gauss1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'gauss1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'gauss1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'gauss1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'gauss1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'gauss1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'gauss1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'gauss1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);

end

dv='null';

setappdata(0,'aval',av);
setappdata(0,'bval',bv);
setappdata(0,'cval',cv);
setappdata(0,'dval',dv);

setappdata(0,'formula',get(handles.formula,'String'));

guidata(hObject, handles);


% --- Executes on button press in fpower1.
function fpower1_Callback(hObject, eventdata, handles)
% hObject    handle to fpower1 (see GCBO)
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fpower1

set(handles.formula,'String','f(x)=a*x^b');
set(handles.text1,'String','a:');
set(handles.text2,'String','b:');
set(handles.text3,'String','');
set(handles.text4,'String','');
set(handles.var1,'String','');
set(handles.var2,'String','');
set(handles.var3,'String','');
set(handles.var4,'String','');

cla(handles.q2v,'reset');

legendfitMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendfitMatrix(n+n-1)={sprintf('Speckle %d',n)};
    legendfitMatrix(n+n)={sprintf('Fit %d',n)};
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'power1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'power1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'power1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'power1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'power1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'power1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'power1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'power1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);

end

cv='null';
dv='null';

setappdata(0,'aval',av);
setappdata(0,'bval',bv);
setappdata(0,'cval',cv);
setappdata(0,'dval',dv);

setappdata(0,'formula',get(handles.formula,'String'));

guidata(hObject, handles);


% --- Executes on button press in fpower2.
function fpower2_Callback(hObject, eventdata, handles)
% hObject    handle to fpower2 (see GCBO)
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fpower2

set(handles.formula,'String','f(x)=a*x^b+c');
set(handles.text1,'String','a:');
set(handles.text2,'String','b:');
set(handles.text3,'String','c:');
set(handles.text4,'String','');
set(handles.var1,'String','');
set(handles.var2,'String','');
set(handles.var3,'String','');
set(handles.var4,'String','');

cla(handles.q2v,'reset');

legendfitMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendfitMatrix(n+n-1)={sprintf('Speckle %d',n)};
    legendfitMatrix(n+n)={sprintf('Fit %d',n)};
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'power2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'power2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'power2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'power2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'power2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'power2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'power2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'power2');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a)};
        bv(k)={num2str(f2.b)};
        cv(k)={num2str(f2.c)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);

end

dv='null';

setappdata(0,'aval',av);
setappdata(0,'bval',bv);
setappdata(0,'cval',cv);
setappdata(0,'dval',dv);

setappdata(0,'formula',get(handles.formula,'String'));

guidata(hObject, handles);


% --- Executes on button press in fsin.
function fsin_Callback(hObject, eventdata, handles)
% hObject    handle to fsin (see GCBO)
% eventdata  reserved - to be defined in var1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fsin

set(handles.formula,'String','f(x)=a1*sin(b1*x+c1)');
set(handles.text1,'String','a1:');
set(handles.text2,'String','b1:');
set(handles.text3,'String','c1:');
set(handles.text4,'String','');
set(handles.var1,'String','');
set(handles.var2,'String','');
set(handles.var3,'String','');
set(handles.var4,'String','');

cla(handles.q2v,'reset');

legendfitMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendfitMatrix(n+n-1)={sprintf('Speckle %d',n)};
    legendfitMatrix(n+n)={sprintf('Fit %d',n)};
end

switch(handles.loglinear)
    
    case(1)
        
set(handles.q2v, 'XScale', 'linear', 'YScale', 'linear');

        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'sin1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'sin1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        plot(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'sin1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        plot(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'sin1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);

    case(0)
        
set(handles.q2v, 'XScale', 'log', 'YScale', 'linear');
        
switch(handles.displayPlot)
    
    case('nf')

        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueNormalized(:,k),'sin1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);

    case('ns')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueNormalized(:,k),'sin1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('uf')
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInFrames,handles.g2ValueUnNormalized(:,k),'sin1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};
        end
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
    case('us')        
        
        for k=1:handles.numqpara;
        semilogx(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        hold on;
        f2=fit(handles.tauInTime(:,k),handles.g2ValueUnNormalized(:,k),'sin1');
        p=plot(f2);
        set(p,'Color',rand(1,3));
        hold on;
        av(k)={num2str(f2.a1)};
        bv(k)={num2str(f2.b1)};
        cv(k)={num2str(f2.c1)};3
        end
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendfitMatrix);
        
end

set(handles.var1,'String',av);
set(handles.var2,'String',bv);
set(handles.var3,'String',cv);

end

dv='null';

setappdata(0,'aval',av);
setappdata(0,'bval',bv);
setappdata(0,'cval',cv);
setappdata(0,'dval',dv);

setappdata(0,'formula',get(handles.formula,'String'));

guidata(hObject, handles);


% --- Executes on button press in adjustpar.
function adjustpar_Callback(hObject, eventdata, handles)
% hObject    handle to adjustpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.fpoly1,'Value')==1;
    fittype='poly1';
end

if get(handles.fpoly2,'Value')==1;
    fittype='poly2';
end

if get(handles.fpoly3,'Value')==1;
    fittype='poly3';
end

if get(handles.fexp1,'Value')==1;
    fittype='exp1';
end

if get(handles.fexp2,'Value')==1;
    fittype='exp2';
end

if get(handles.ffourier,'Value')==1;
    fittype='fourier1';
end

if get(handles.fsin,'Value')==1;
    fittype='sin1';
end

setappdata(0,'fittype',fittype);

listcurve;

uiwait;

fitpar;

guidata(hObject, handles);
