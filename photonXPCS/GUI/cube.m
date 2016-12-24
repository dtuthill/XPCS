function varargout = cube(varargin)
% CUBE MATLAB code for cube.fig
%      CUBE, by itself, creates a new CUBE or raises the existing
%      singleton*.
%
%      H = CUBE returns the handle to a new CUBE or the handle to
%      the existing singleton*.
%
%      CUBE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CUBE.M with the given input arguments.
%
%      CUBE('Property','Value',...) creates a new CUBE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cube_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cube_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cube

% Last Modified by GUIDE v2.5 27-Jun-2016 12:15:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cube_OpeningFcn, ...
                   'gui_OutputFcn',  @cube_OutputFcn, ...
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


% --- Executes just before cube is made visible.
function cube_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cube (see VARARGIN)

% Choose default command line output for cube
handles.output = hObject;

set(handles.xstring,'String','');
set(handles.ystring,'String','');
set(handles.zstring,'String','');

handles.discreteQvalue=getappdata(0,'discreteQvalue');
handles.numqpara=getappdata(0,'numqpara');
handles.rescaleData=getappdata(0,'rescaleData');
handles.data=getappdata(0,'data');
handles.TimeperFrame=getappdata(0,'timeperframe');
handles.qparaValue=getappdata(0,'qparaValue');
handles.sumIntensityQbins=getappdata(0,'sumIntensityQbins');
handles.qpara=getappdata(0,'qpara');
handles.g2ValueNormalized=getappdata(0,'g2normalization');
handles.g2ValueUnNormalized=getappdata(0,'g2unnormalization');

set(handles.xslice,'enable','on');
set(handles.xss,'enable','off');
set(handles.xstart,'enable','off');
set(handles.xend,'enable','off');
set(handles.xst,'enable','off');
set(handles.xse,'enable','off');
set(handles.xsi,'enable','off');
set(handles.xint,'Value',0);

set(handles.yslice,'enable','on');
set(handles.yss,'enable','off');
set(handles.ystart,'enable','off');
set(handles.yend,'enable','off');
set(handles.yst,'enable','off');
set(handles.yse,'enable','off');
set(handles.ysi,'enable','off');
set(handles.yint,'Value',0);

set(handles.zslice,'enable','on');
set(handles.zss,'enable','off');
set(handles.zstart,'enable','off');
set(handles.zend,'enable','off');
set(handles.zst,'enable','off');
set(handles.zse,'enable','off');
set(handles.zsi,'enable','off');
set(handles.zint,'Value',0);

handles.xx=str2num(get(handles.xslice,'String'));
handles.yy=str2num(get(handles.yslice,'String'));
handles.zz=str2num(get(handles.zslice,'String'));
handles.xvstart=str2num(get(handles.xstart,'String'));
handles.xvss=str2num(get(handles.xss,'String'));
handles.xvend=str2num(get(handles.xend,'String'));
handles.yvstart=str2num(get(handles.ystart,'String'));
handles.yvss=str2num(get(handles.yss,'String'));
handles.yvend=str2num(get(handles.yend,'String'));
handles.zvstart=str2num(get(handles.zstart,'String'));
handles.zvss=str2num(get(handles.zss,'String'));
handles.zvend=str2num(get(handles.zend,'String'));

contents=cellstr(get(handles.g2normv,'String'));
choices=contents{get(handles.g2normv,'Value')};

if (strcmp(choices,'Symmetric'));
    handles.g2normvalue='symm';
    
elseif (strcmp(choices,'Normal'));
    handles.g2normvalue='norm';

end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cube wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cube_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in render.
function render_Callback(hObject, eventdata, handles)
% hObject    handle to render (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

switch(get(handles.whole,'Value'))
    case(1)
        xslice=[1:1:handles.NumYpixel];
        yslice=[1:1:handles.NumXpixel];
        zslice=[1:1:handles.numImages];
    
    case(0)

switch(get(handles.yint,'Value'))
    case(1)
        xslice=[handles.yvstart:handles.yvss:handles.yvend];
    case(0)
        xslice=[handles.yy];
end

switch(get(handles.xint,'Value'))
    case(1)
        yslice=[handles.xvstart:handles.xvss:handles.xvend];
    case(0)
        yslice=[handles.xx];
end

switch(get(handles.zint,'Value'))
    case(1)
        zslice=[handles.zvstart:handles.zvss:handles.zvend];
    case(0)
        zslice=[handles.zz];
end

end

switch(get(handles.n,'Value'))
    case(1)

figure(3); h=slice(handles.g2ValueNormalized,xslice,yslice,zslice);
set(h,'EdgeColor','interp') %,...
    %'FaceColor','interp','FaceAlpha','interp','AlphaDataMapping','scaled');
% alpha('color');
% colormap hsv
xlabel('Y-Pixels')
ylabel('X-Pixels')
zlabel('Tau (Number of Frames)')
%axis([max(1,min(xslice),'omitnan') min(handles.NumYpixel,max(xslice),'omitnan') max(1,min(yslice),'omitnan') min(handles.NumXpixel,max(yslice),'omitnan') max(1,min(zslice),'omitnan') min(handles.numImages,max(zslice),'omitnan')]);
axis([-Inf Inf -Inf Inf -Inf Inf]);
    case(0)
        
figure(3); h=slice(handles.g2ValueUnNormalized,xslice,yslice,zslice);
set(h,'EdgeColor','interp') %,...
    %'FaceColor','interp','FaceAlpha','interp','AlphaDataMapping','scaled');
% alpha('color');
% colormap hsv
xlabel('Y-Pixels')
ylabel('X-Pixels')
zlabel('Tau (Number of Frames)')
%axis([max(1,min(xslice)) min(handles.NumXpixel,max(xslice)) max(1,min(yslice)) min(handles.NumXpixel,max(yslice)) max(1,min(zslice)) min(handles.numImages,max(zslice))]);
axis([-Inf Inf -Inf Inf -Inf Inf]);
end

guidata(hObject, handles);



function yslice_Callback(hObject, eventdata, handles)
% hObject    handle to yslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yslice as text
%        str2double(get(hObject,'String')) returns contents of yslice as a double

handles.yy=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function yslice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zslice_Callback(hObject, eventdata, handles)
% hObject    handle to zslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zslice as text
%        str2double(get(hObject,'String')) returns contents of zslice as a double

handles.zz=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function zslice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xslice_Callback(hObject, eventdata, handles)
% hObject    handle to xslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xslice as text
%        str2double(get(hObject,'String')) returns contents of xslice as a double

handles.xx=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xslice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in g2calc.
function g2calc_Callback(hObject, eventdata, handles)
% hObject    handle to g2calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

set(handles.xstring,'String','');
set(handles.ystring,'String','');
set(handles.zstring,'String','');

% set(handles.progress,'String','');

handles.numImages = length(handles.data(1,1,:));  % number of images in the movie series
handles.NumYpixel = length(handles.rescaleData(1,:,1)); % pixels in y-direction
handles.NumXpixel = length(handles.rescaleData(:,1,1)); % pixels in x-direction

set(handles.xstring,'String',num2str(handles.NumXpixel));
set(handles.ystring,'String',num2str(handles.NumYpixel));
set(handles.zstring,'String',num2str(handles.numImages));

handles.tauInFrames = zeros(handles.numImages,1);                                       % preallocating tauInFrames
handles.tauInTime = zeros(handles.numImages,1);
%preallocating tau

% Define tau in number of frames
     
handles.tauInFrames(1)= 0;
handles.tauInFrames(2:handles.numImages) =  1:(handles.numImages-1);

% Calculate tau in seconds  

for i = 1:length(handles.tauInFrames)
    handles.tauInTime(i) = handles.tauInFrames(i).* handles.TimeperFrame;
end

handles.g2normalization='norm';

% Preallocating all matrices 
sumInt = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numImages);       %preallocating sumInt
handles.avnormFactor = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2)); %preallocating normFactor
handles.g2Numerator = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numImages); %preallocating g2Numerator
handles.g2ValueNormalized = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),length(handles.tauInFrames));                % preallocating g2Normalized
handles.g2ValueUnNormalized = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),length(handles.tauInFrames));              % preallocating g2UnNormalized

clear j; clear k; clear i;
switch(handles.g2normvalue)
    case 'norm'
        h=waitbar(0,'Calculating g2normalization...');
        for j=1:handles.NumXpixel
            for k=1:handles.NumYpixel
                for i=1:(handles.numImages)
                    sumInt(j,k) =  sumInt(j,k) + handles.rescaleData(j,k,i);
                end
                handles.avnormFactor(j,k) = (sumInt(j,k) ./ handles.numImages) .* (sumInt(j,k) ./ handles.numImages);
            end
            waitbar(j/handles.NumXpixel)
        end
        close(h);
        
    case 'symm'

        %preallocating sumInt and avInt matrices
        sumInt1 = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numImages);
        sumInt2 = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numImages);
        avsumInt1 = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numImages);
        avsumInt2 = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numImages);


        
    h=waitbar(0,'Calculating g2normalization...');
    for j=1:handles.NumXpixel
        for k=1:handles.NumYpixel
            for i = 1:(handles.numImages)   % Note that length(tauInFrames) and numImages are equal


                    sumInt1(j,k,i) = sum(handles.rescaleData(j,k,1: (handles.numImages-handles.tauInFrames(i))),3);
                    sumInt2(j,k,i) = sum(handles.rescaleData(j,k,handles.numImages:-1: (1+handles.tauInFrames(i))),3);
                    
                avsumInt1(j,k,i) = (sumInt1(j,k,i)) ./ (handles.numImages-handles.tauInFrames(i));
                avsumInt2(j,k,i) = (sumInt2(j,k,i)) ./ (handles.numImages-handles.tauInFrames(i));
                handles.avnormFactor(j,k,i) = avsumInt1(j,k,i) .* avsumInt2(j,k,i);
                
            end
        end
        waitbar(j/handles.NumXpixel)
    end
    close(h);

        
        
end

% set(handles.progress,'String','Average normfactor calculated. Starting g2Matrix...');

%Calculate numerator of g2

clear j; clear k; clear i;
% i is row and j is col
h=waitbar(0,'Calculating g2 numerator');
for j=1:handles.NumXpixel
    for k=1:handles.NumYpixel
        for i = 1:length(handles.tauInFrames)   % Note that length(tauInFrames) and numImages are equal
            handles.g2Numerator(j,k,i) = mean((handles.rescaleData(j,k,1: handles.numImages-handles.tauInFrames(i))).*(handles.rescaleData(j,k,1+handles.tauInFrames(i): handles.numImages)),3);
        end
    end
    waitbar(j/handles.NumXpixel)
end
close(h)

% Calculating Normalized g2 
 
clear j; clear k; clear i;

switch (handles.g2normvalue)
    
    case 'norm'
        h=waitbar(0,'Calculating g2normalized...');
    for j=1:handles.NumXpixel
        for k=1:handles.NumYpixel
            for i=1:length(handles.tauInFrames)
                handles.g2ValueNormalized(j,k,i) = handles.g2Numerator(j,k,i) ./ handles.avnormFactor(j,k);  % normalization step
            end
        end
        waitbar(j/handles.NumXpixel)
    end
    close(h)
        
    case 'symm'
        h=waitbar(0,'Calculating g2normalized...');
    for j=1:handles.NumXpixel
        for k=1:handles.NumYpixel
            for i=1:length(handles.tauInFrames)
                handles.g2ValueNormalized(j,k,i)= handles.g2Numerator(j,k,i) ./ handles.avnormFactor(j,k,i);  % normalization step 
            end
        end
        waitbar(j/handles.NumXpixel)
    end
    close(h)
end

% Calculating UnNormalized g2     

clear j; clear k; clear i;
h=waitbar(0,'Calculating g2 unnormalized...');
 for j=1:handles.NumXpixel
     for k=1:handles.NumYpixel
        for i=1:length(handles.tauInFrames) 
            handles.g2ValueUnNormalized(j,k,i) =mean(handles.g2Numerator(j,k,i));          %second mean may be unnecessary
        end
     end
     waitbar(j/handles.NumXpixel)
 end
 close(h)
 
 setappdata(0,'g2normalization',handles.g2ValueNormalized);
 setappdata(0,'g2unnormalization',handles.g2ValueUnNormalized);
 setappdata(0,'tauInFrames',handles.tauInFrames);
 setappdata(0,'tauInTime',handles.tauInTime);
 setappdata(0,'NumXpixel',handles.NumXpixel);
 setappdata(0,'NumYpixel',handles.NumYpixel);
 setappdata(0,'numImages',handles.numImages);

% set(handles.progress,'String','g2 Value Calculated');

guidata(hObject, handles);


% --- Executes on button press in xint.
function xint_Callback(hObject, eventdata, handles)
% hObject    handle to xint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xint

switch(get(hObject,'Value'));
    case(1)
        set(handles.xslice,'enable','off');
        set(handles.xss,'enable','on');
        set(handles.xstart,'enable','on');
        set(handles.xend,'enable','on');
        set(handles.xst,'enable','on');
        set(handles.xse,'enable','on');
        set(handles.xsi,'enable','on');
        handles.xvstart=str2num(get(handles.xstart,'String'));
        handles.xvend=str2num(get(handles.xend,'String'));
        handles.xvss=str2num(get(handles.xss,'String'));
    case(0)
        set(handles.xslice,'enable','on');
        set(handles.xss,'enable','off');
        set(handles.xstart,'enable','off');
        set(handles.xend,'enable','off');
        set(handles.xst,'enable','off');
        set(handles.xse,'enable','off');
        set(handles.xsi,'enable','off');
        handles.xx=str2num(get(handles.xslice,'String'));
end

guidata(hObject, handles);


% --- Executes on button press in yint.
function yint_Callback(hObject, eventdata, handles)
% hObject    handle to yint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of yint

switch(get(hObject,'Value'));
    case(1)
        set(handles.yslice,'enable','off');
        set(handles.yss,'enable','on');
        set(handles.ystart,'enable','on');
        set(handles.yend,'enable','on');
        set(handles.yst,'enable','on');
        set(handles.yse,'enable','on');
        set(handles.ysi,'enable','on');
        handles.yvstart=str2num(get(handles.ystart,'String'));
        handles.yvend=str2num(get(handles.yend,'String'));
        handles.yvss=str2num(get(handles.yss,'String'));
    case(0)
        set(handles.yslice,'enable','on');
        set(handles.yss,'enable','off');
        set(handles.ystart,'enable','off');
        set(handles.yend,'enable','off');
        set(handles.yst,'enable','off');
        set(handles.yse,'enable','off');
        set(handles.ysi,'enable','off');
        handles.yy=str2num(get(handles.yslice,'String'));
end

guidata(hObject, handles);


% --- Executes on button press in zint.
function zint_Callback(hObject, eventdata, handles)
% hObject    handle to zint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zint

switch(get(hObject,'Value'));
    case(1)
        set(handles.zslice,'enable','off');
        set(handles.zss,'enable','on');
        set(handles.zstart,'enable','on');
        set(handles.zend,'enable','on');
        set(handles.zst,'enable','on');
        set(handles.zse,'enable','on');
        set(handles.zsi,'enable','on');
        handles.zvstart=str2num(get(handles.zstart,'String'));
        handles.zvend=str2num(get(handles.zend,'String'));
        handles.zvss=str2num(get(handles.zss,'String'));
    case(0)
        set(handles.zslice,'enable','on');
        set(handles.zss,'enable','off');
        set(handles.zstart,'enable','off');
        set(handles.zend,'enable','off');
        set(handles.zst,'enable','off');
        set(handles.zse,'enable','off');
        set(handles.zsi,'enable','off');
        handles.zz=str2num(get(handles.zslice,'String'));
end

guidata(hObject, handles);



function xstart_Callback(hObject, eventdata, handles)
% hObject    handle to xstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xstart as text
%        str2double(get(hObject,'String')) returns contents of xstart as a double

handles.xvstart=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xend_Callback(hObject, eventdata, handles)
% hObject    handle to xend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xend as text
%        str2double(get(hObject,'String')) returns contents of xend as a double

handles.xvend=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xss_Callback(hObject, eventdata, handles)
% hObject    handle to xss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xss as text
%        str2double(get(hObject,'String')) returns contents of xss as a double

handles.xvss=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ystart_Callback(hObject, eventdata, handles)
% hObject    handle to ystart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ystart as text
%        str2double(get(hObject,'String')) returns contents of ystart as a double

handles.yvstart=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ystart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ystart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yend_Callback(hObject, eventdata, handles)
% hObject    handle to yend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yend as text
%        str2double(get(hObject,'String')) returns contents of yend as a double

handles.yvend=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function yend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yss_Callback(hObject, eventdata, handles)
% hObject    handle to yss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yss as text
%        str2double(get(hObject,'String')) returns contents of yss as a double

handles.yvss=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function yss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zstart_Callback(hObject, eventdata, handles)
% hObject    handle to zstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zstart as text
%        str2double(get(hObject,'String')) returns contents of zstart as a double

handles.zvstart=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function zstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zend_Callback(hObject, eventdata, handles)
% hObject    handle to zend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zend as text
%        str2double(get(hObject,'String')) returns contents of zend as a double

handles.zvend=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function zend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zss_Callback(hObject, eventdata, handles)
% hObject    handle to zss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zss as text
%        str2double(get(hObject,'String')) returns contents of zss as a double

handles.zvss=str2num(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function zss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clearx.
function clearx_Callback(hObject, eventdata, handles)
% hObject    handle to clearx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.xslice,'String','');
set(handles.xstart,'String','');
set(handles.xend,'String','');
set(handles.xss,'String','');

handles.xvstart=str2num(get(handles.xstart,'String'));
handles.xvend=str2num(get(handles.xend,'String'));
handles.xvss=str2num(get(handles.xss,'String'));
handles.xx=str2num(get(handles.xslice,'String'));

guidata(hObject, handles);


% --- Executes on button press in cleary.
function cleary_Callback(hObject, eventdata, handles)
% hObject    handle to cleary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.yslice,'String','');
set(handles.ystart,'String','');
set(handles.yend,'String','');
set(handles.yss,'String','');

handles.yvstart=str2num(get(handles.ystart,'String'));
handles.yvend=str2num(get(handles.yend,'String'));
handles.yvss=str2num(get(handles.yss,'String'));
handles.yy=str2num(get(handles.yslice,'String'));

guidata(hObject, handles);


% --- Executes on button press in clearz.
function clearz_Callback(hObject, eventdata, handles)
% hObject    handle to clearz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.zslice,'String','');
set(handles.zstart,'String','');
set(handles.zend,'String','');
set(handles.zss,'String','');

handles.zvstart=str2num(get(handles.zstart,'String'));
handles.zvend=str2num(get(handles.zend,'String'));
handles.zvss=str2num(get(handles.zss,'String'));
handles.zz=str2num(get(handles.zslice,'String'));

guidata(hObject, handles);


% --- Executes on selection change in g2normv.
function g2normv_Callback(hObject, eventdata, handles)
% hObject    handle to g2normv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns g2normv contents as cell array
%        contents{get(hObject,'Value')} returns selected item from g2normv

contents=cellstr(get(hObject,'String'));
choices=contents{get(hObject,'Value')};

if (strcmp(choices,'Symmetric'));
    handles.g2normvalue='symm';
    
elseif (strcmp(choices,'Normal'));
    handles.g2normvalue='norm';

end
    
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function g2normv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g2normv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savenorm.
function savenorm_Callback(hObject, eventdata, handles)
% hObject    handle to savenorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

g2ValueNormalized=handles.g2ValueNormalized;

header='g2 Values Normalized';
        [filename,pathname]=uiputfile('g2ValuesNormalized.txt','Select Save Location');
        dlmwrite(filename,header,'delimiter','');
        dlmwrite(filename,g2ValueNormalized,'-append','delimiter','\t','newline','pc','roffset',1);


% --- Executes on button press in saveunnorm.
function saveunnorm_Callback(hObject, eventdata, handles)
% hObject    handle to saveunnorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

g2ValueUnNormalized=handles.g2ValueUnNormalized;

header='g2 Values UnNormalized';
        [filename,pathname]=uiputfile('g2ValuesUnNormalized.txt','Select Save Location');
        dlmwrite(filename,header,'delimiter','');
        dlmwrite(filename,g2ValueUnNormalized,'-append','delimiter','\t','newline','pc','roffset',1);


% --- Executes on button press in plinegraph.
function plinegraph_Callback(hObject, eventdata, handles)
% hObject    handle to plinegraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

linegraph


% --- Executes on button press in whole.
function whole_Callback(hObject, eventdata, handles)
% hObject    handle to whole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of whole

switch(get(hObject,'Value'));
    case(1)
        set(findall(handles.uipanel1, '-property', 'enable'), 'enable', 'off');
    case(0)
        set(findall(handles.uipanel1, '-property', 'enable'), 'enable', 'on');

switch(get(handles.xint,'Value'));
    case(1)
        set(handles.xslice,'enable','off');
        set(handles.xss,'enable','on');
        set(handles.xstart,'enable','on');
        set(handles.xend,'enable','on');
        set(handles.xst,'enable','on');
        set(handles.xse,'enable','on');
        set(handles.xsi,'enable','on');
    case(0)
        set(handles.xslice,'enable','on');
        set(handles.xss,'enable','off');
        set(handles.xstart,'enable','off');
        set(handles.xend,'enable','off');
        set(handles.xst,'enable','off');
        set(handles.xse,'enable','off');
        set(handles.xsi,'enable','off');
end    

switch(get(handles.yint,'Value'));
    case(1)
        set(handles.yslice,'enable','off');
        set(handles.yss,'enable','on');
        set(handles.ystart,'enable','on');
        set(handles.yend,'enable','on');
        set(handles.yst,'enable','on');
        set(handles.yse,'enable','on');
        set(handles.ysi,'enable','on');
    case(0)
        set(handles.yslice,'enable','on');
        set(handles.yss,'enable','off');
        set(handles.ystart,'enable','off');
        set(handles.yend,'enable','off');
        set(handles.yst,'enable','off');
        set(handles.yse,'enable','off');
        set(handles.ysi,'enable','off');
end
        
switch(get(handles.zint,'Value'));
    case(1)
        set(handles.zslice,'enable','off');
        set(handles.zss,'enable','on');
        set(handles.zstart,'enable','on');
        set(handles.zend,'enable','on');
        set(handles.zst,'enable','on');
        set(handles.zse,'enable','on');
        set(handles.zsi,'enable','on');
    case(0)
        set(handles.zslice,'enable','on');
        set(handles.zss,'enable','off');
        set(handles.zstart,'enable','off');
        set(handles.zend,'enable','off');
        set(handles.zst,'enable','off');
        set(handles.zse,'enable','off');
        set(handles.zsi,'enable','off');
end

end

guidata(hObject, handles);
