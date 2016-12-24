function varargout = GUIxpcs(varargin)
% GUIXPCS MATLAB code for GUIxpcs.fig
%      GUIXPCS, by itself, creates a new GUIXPCS or raises the existing
%      singleton*.
%
%      H = GUIXPCS returns the handle to a new GUIXPCS or the handle to
%      the existing singleton*.
%
%      GUIXPCS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIXPCS.M with the given input arguments.
%
%      GUIXPCS('Property','Value',...) creates a new GUIXPCS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIxpcs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIxpcs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIxpcs

% Last Modified by GUIDE v2.5 15-Aug-2016 16:01:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIxpcs_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIxpcs_OutputFcn, ...
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


% --- Executes just before GUIxpcs is made visible.
function GUIxpcs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIxpcs (see VARARGIN)

% Choose default command line output for GUIxpcs
handles.output = hObject;

cla(handles.qsumint);
cla(handles.q2v);

handles.discreteQvalue=getappdata(0,'discreteQvalue');
handles.numqpara=getappdata(0,'numqpara');
handles.rescaleData=getappdata(0,'rescaleData');
handles.numImages=getappdata(0,'numImages');
handles.TimeperFrame=getappdata(0,'timeperframe');
handles.qparaValue=getappdata(0,'qparaValue');
handles.sumIntensityQbins=getappdata(0,'sumIntensityQbins');
handles.qpara=getappdata(0,'qpara');

set(handles.progress,'String','');

contents=cellstr(get(handles.g2normalization,'String'));
choices=contents{get(handles.g2normalization,'Value')};

if (strcmp(choices,'Symmetric'));
    handles.vg2normalization='symm';
    
elseif (strcmp(choices,'Normal'));
    handles.vg2normalization='norm';

end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIxpcs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIxpcs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in goxpcs.
function goxpcs_Callback(hObject, eventdata, handles)
% hObject    handle to goxpcs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.progress,'String','');

cla(handles.qsumint);
cla(handles.q2v);

switch(handles.discreteQvalue);
    
    case(1)

% Preallocating all matrices 
sumInt = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numqpara);       %preallocating sumInt
avnormFactor = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numqpara); %preallocating normFactor
tauInFrames = zeros(handles.numImages,1);                                       % preallocating tauInFrames
tauInTime = zeros(length(tauInFrames),handles.numqpara);                        %preallocating tau
g2Numerator = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numImages,handles.numqpara); %preallocating g2Numerator
g2ValueNormalized = zeros(length(tauInFrames),handles.numqpara);                % preallocating g2Normalized
g2ValueUnNormalized = zeros(length(tauInFrames),handles.numqpara);              % preallocating g2UnNormalized

% Define tau in number of frames
     
tauInFrames(1)= 0;
tauInFrames(2:handles.numImages) =  1:(handles.numImages-1);

switch(handles.vg2normalization)
    case 'norm'
        h = waitbar(0,'Calculating normalization matrix....');
            for k=1:handles.numqpara    % i is row and j is col, index k will run from 1 to numqpara
                for i=1:(handles.numImages)
                    sumInt(:,:,k) =  sumInt(:,:,k) + handles.rescaleData(:,:,i,k);
                    waitbar(i/handles.numImages)
                end
                avnormFactor(:,:,k) = (sumInt(:,:,k) ./ handles.numImages) .* (sumInt(:,:,k) ./ handles.numImages);
            end
        close(h)
        
    case 'symm'

        %preallocating sumInt and avInt matrices
        sumInt1 = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numImages,handles.numqpara);
        sumInt2 = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numImages,handles.numqpara);
        avsumInt1 = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numImages,handles.numqpara);
        avsumInt2 = zeros(size(handles.rescaleData,1),size(handles.rescaleData,2),handles.numImages,handles.numqpara);

        clear j;

       h = waitbar(0,'Calculating normalization matrix....');
        
        for k = 1:handles.numqpara

            for i = 1:(length(tauInFrames))   % Note that length(tauInFrames) and numImages are equal


                    sumInt1(:,:,i,k) = sum(handles.rescaleData(:,:,1: (handles.numImages-tauInFrames(i)),k),3);
                    sumInt2(:,:,i,k) = sum(handles.rescaleData(:,:,handles.numImages:-1: (1+tauInFrames(i)),k),3);
                    
                avsumInt1(:,:,i,k) = (sumInt1(:,:,i,k)) ./ (handles.numImages-tauInFrames(i));
                avsumInt2(:,:,i,k) = (sumInt2(:,:,i,k)) ./ (handles.numImages-tauInFrames(i));
                avnormFactor(:,:,i,k) = avsumInt1(:,:,i,k) .* avsumInt2(:,:,i,k);
                waitbar(i/handles.numImages)

            end

        end
        
        close(h)
        
end

set(handles.progress,'String','Average normfactor calculated. Starting g2Matrix...');

%Calculate numerator of g2
    
clear i; clear j; clear k;

h = waitbar(0,'Calculating g2 Numerator....');

for k=1:handles.numqpara    % i is row and j is col, index k will run from 1 to numqpara

    for i = 1:length(tauInFrames)   % Note that length(tauInFrames) and numImages are equal
        g2Numerator(:,:,i,k) = mean((handles.rescaleData(:,:,1: handles.numImages-tauInFrames(i),k)).*(handles.rescaleData(:,:,1+tauInFrames(i): handles.numImages,k)),3);
        waitbar(i/length(tauInFrames))
    end

end

close(h);

% Calculating Normalized g2 
       
clear i; clear j; clear k;

switch (handles.vg2normalization)
    case 'norm'
        h=waitbar(0,'Calculating normalized g2 Matrix...');
        for k = 1:handles.numqpara
            clear g2Value1; clear g2Value2;
            for i=1:length(tauInFrames)
                clear g2Value1; clear g2Value2;
                g2Value1(:,:) = g2Numerator(:,:,i,k) ./ avnormFactor(:,:,k);  % normalization step 
                g2Value2(:,:) = NAN_mean(g2Value1(:,:));
                g2ValueNormalized(i,k) = NAN_mean(g2Value2(:,:));
                waitbar(i/length(tauInFrames))
            end
        end
        close(h);
        
    case 'symm'
        h=waitbar(0,'Calculating normalized g2 Matrix...');
        clear g2Value1; clear g2Value2;
        for k = 1:handles.numqpara
            for i=1:length(tauInFrames)
                clear g2Value1; clear g2Value2;
                g2Value1(:,:)= g2Numerator(:,:,i,k) ./ avnormFactor(:,:,i,k);  % normalization step 
                g2Value2(:,:) = NAN_mean(g2Value1(:,:));
                g2ValueNormalized(i,k) = NAN_mean(g2Value2(:,:));
                waitbar(i/length(tauInFrames))
            end
        end
        close(h);

end

% Calculating UnNormalized g2     

clear i; clear k;

h=waitbar(0,'Calculating unnormalized g2 Matrix...');
for k = 1:handles.numqpara       
    for i=1:length(tauInFrames)
        clear g2UnValue1; 
        g2UnValue1(:,:) = NAN_mean(g2Numerator(:,:,i,k));
        g2ValueUnNormalized(i,k) = NAN_mean(g2UnValue1(:,:));
        waitbar(i/length(tauInFrames))
    end
end
close(h);

set(handles.progress,'String','g2 Value Calculated');

% Calculate tau in seconds  

for k = 1:handles.numqpara
    for i = 1:length(tauInFrames)
        tauInTime(i,k) = tauInFrames(i)* handles.TimeperFrame;
    end
end

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

legendMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendMatrix(n)={sprintf('Speckle %d',n)};
end

switch(displayPlot)
    
    case('nf')
        
        switch(get(handles.li,'Value'))

            case(1)

        plot(tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);

        plot(tauInFrames,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
                
        plot(tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);

        semilogx(tauInFrames,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
        end

    case('ns')
        
        switch(get(handles.li,'Value'))

            case(1)
        
        plot(tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        plot(tauInTime,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
        
        plot(tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        semilogx(tauInTime,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
        end
        
    case('uf')
        
        switch(get(handles.li,'Value'))

            case(1)
        
        plot(tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        plot(tauInFrames,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
        
        plot(tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        semilogx(tauInFrames,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
        end
        
    case('us')
        
        switch(get(handles.li,'Value'))
            
            case(1)
        
        plot(tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        plot(tauInTime,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
        
        plot(tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        semilogx(tauInTime,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
        end
        
end

    case(0)
        
        % Preallocating all matrices 
sumInt = zeros(size(handles.rescaleData,1),handles.numqpara);       %preallocating sumInt
avnormFactor = zeros(size(handles.rescaleData,1),handles.numqpara); %preallocating normFactor
tauInFrames = zeros(handles.numImages,1);                                       % preallocating tauInFrames
tauInTime = zeros(length(tauInFrames),handles.numqpara);                        %preallocating tau
g2Numerator = zeros(size(handles.rescaleData,1),handles.numImages,handles.numqpara); %preallocating g2Numerator
g2ValueNormalized = zeros(length(tauInFrames),handles.numqpara);                % preallocating g2Normalized
g2ValueUnNormalized = zeros(length(tauInFrames),handles.numqpara);              % preallocating g2UnNormalized

% Define tau in number of frames
     
tauInFrames(1)= 0;
tauInFrames(2:handles.numImages) =  1:(handles.numImages-1);

switch(handles.vg2normalization)
    case 'norm'
        h = waitbar(0,'Calculating normalization matrix....');
            for k=1:handles.numqpara    % i is row and j is col, index k will run from 1 to numqpara
                for i=1:(handles.numImages)
                    sumInt(:,k) =  sumInt(:,k) + handles.rescaleData(:,i,k);
                    waitbar(i/handles.numImages)
                end
                avnormFactor(:,k) = (sumInt(:,k) ./ handles.numImages) .* (sumInt(:,k) ./ handles.numImages);
            end
        close(h)
        
    case 'symm'

        %preallocating sumInt and avInt matrices
        sumInt1 = zeros(size(handles.rescaleData,1),handles.numImages,handles.numqpara);
        sumInt2 = zeros(size(handles.rescaleData,1),handles.numImages,handles.numqpara);
        avsumInt1 = zeros(size(handles.rescaleData,1),handles.numImages,handles.numqpara);
        avsumInt2 = zeros(size(handles.rescaleData,1),handles.numImages,handles.numqpara);

        clear j;

        h = waitbar(0,'Calculating normalization matrix....');
        
        for k = 1:handles.numqpara

            for i = 1:(length(tauInFrames))   % Note that length(tauInFrames) and numImages are equal


                    sumInt1(:,i,k) = sum(handles.rescaleData(:,1: (handles.numImages-tauInFrames(i)),k),2);
                    sumInt2(:,i,k) = sum(handles.rescaleData(:,handles.numImages:-1: (1+tauInFrames(i)),k),2);
                    
                avsumInt1(:,i,k) = (sumInt1(:,i,k)) ./ (handles.numImages-tauInFrames(i));
                avsumInt2(:,i,k) = (sumInt2(:,i,k)) ./ (handles.numImages-tauInFrames(i));
                avnormFactor(:,i,k) = avsumInt1(:,i,k) .* avsumInt2(:,i,k);
                waitbar(i/handles.numImages)

            end

        end
        
        close(h)
        
end

set(handles.progress,'String','Average normfactor calculated. Starting g2Matrix...');

%Calculate numerator of g2
    
clear i; clear j; clear k;

h = waitbar(0,'Calculating g2 Numerator....');

for k=1:handles.numqpara    % i is row and j is col, index k will run from 1 to numqpara

    for i = 1:length(tauInFrames)   % Note that length(tauInFrames) and numImages are equal
        g2Numerator(:,i,k) = NAN_mean((handles.rescaleData(:,1: handles.numImages-tauInFrames(i),k)).*(handles.rescaleData(:,1+tauInFrames(i): handles.numImages,k)),2);
        waitbar(i/length(tauInFrames));
    end
    
end

close(h);

size(g2Numerator)
size(avnormFactor)

% Calculating Normalized g2 
       
clear i; clear j; clear k;

switch (handles.vg2normalization)
    case 'norm'
        h=waitbar(0,'Calculating normalized g2 Matrix...');
        for k = 1:handles.numqpara
            clear g2Value1;
            for i=1:length(tauInFrames)
                clear g2Value1;
                g2Value1(:,i,k) = g2Numerator(:,i,k) ./ avnormFactor(:,k);  % normalization step 
                g2ValueNormalized(i,k)=NAN_mean(g2Value1(:,i,k));
                waitbar(i/length(tauInFrames))
            end
        end
        close(h);
        
    case 'symm'
        h=waitbar(0,'Calculating normalized g2 Matrix...');
        clear g2Value1;
        for k = 1:handles.numqpara
            for i=1:length(tauInFrames)
                clear g2Value1;
                g2Value1(:,i,k)= g2Numerator(:,i,k) ./ avnormFactor(:,i,k);  % normalization step 
                g2ValueNormalized(i,k)=NAN_mean(g2Value1(:,i,k));
                waitbar(i/length(tauInFrames))
            end
        end
        close(h);

end

% Calculating UnNormalized g2     

clear i; clear k;

h=waitbar(0,'Calculating unnormalized g2 Matrix...');
for k = 1:handles.numqpara       
    for i=1:length(tauInFrames)
        g2ValueUnNormalized(i,k) = NAN_mean(g2Numerator(:,i,k));
        waitbar(i/length(tauInFrames))
    end
end
close(h);

set(handles.progress,'String','g2 Value Calculated');

% Calculate tau in seconds  

for k = 1:handles.numqpara
    for i = 1:length(tauInFrames)
        tauInTime(i,k) = tauInFrames(i)* handles.TimeperFrame;
    end
end

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

legendMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendMatrix(n)={sprintf('Speckle %d',n)};
end

switch(displayPlot)
    
    case('nf')
        
        switch(get(handles.li,'Value'))

            case(1)

        plot(tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);

        plot(tauInFrames,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
                
        plot(tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);

        semilogx(tauInFrames,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
        end

    case('ns')
        
        switch(get(handles.li,'Value'))

            case(1)
        
        plot(tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        plot(tauInTime,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
        
        plot(tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        semilogx(tauInTime,g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
        end
        
    case('uf')
        
        switch(get(handles.li,'Value'))
            
            case(1)
        
        plot(tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        plot(tauInFrames,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
        
        plot(tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        semilogx(tauInFrames,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
        end
        
        
    case('us')
        
        switch(get(handles.li,'Value'))
            
            case(1)
        
        plot(tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        plot(tauInTime,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
                
        plot(tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        plot(tauInTime,g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
        end    
        
end
        
end

handles.g2ValueNormalized=g2ValueNormalized;
handles.g2ValueUnNormalized=g2ValueUnNormalized;
handles.tauInTime=tauInTime;
handles.tauInFrames=tauInFrames;
handles.displayPlot=displayPlot;

setappdata(0,'tau',handles.tauInTime);
setappdata(0,'g2fit',handles.g2ValueNormalized);
setappdata(0,'g2ufit',handles.g2ValueUnNormalized);
setappdata(0,'tauF',handles.tauInFrames);
setappdata(0,'numqpara',handles.numqpara);
setappdata(0,'displayPlot',handles.displayPlot);
setappdata(0,'loglinear',get(handles.li,'Value'));

set(handles.progress,'String','XPCS complete');

guidata(hObject, handles);


% --- Executes on button press in n.
function n_Callback(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of n

handles.n=get(hObject,'Value');
handles.u=get(handles.u,'Value');



% --- Executes on button press in u.
function u_Callback(hObject, eventdata, handles)
% hObject    handle to u (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u

handles.u=get(hObject,'Value');
handles.n=get(handles.n,'Value');

% --- Executes on button press in f.
function f_Callback(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of f

handles.f=get(hObject,'Value');
handles.s=get(handles.s,'Value');


% --- Executes on button press in s.
function s_Callback(hObject, eventdata, handles)
% hObject    handle to s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s

handles.s=get(hObject,'Value');
handles.f=get(handles.f,'Value');


% --- Executes on selection change in g2normalization.
function g2normalization_Callback(hObject, eventdata, handles)
% hObject    handle to g2normalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns g2normalization contents as cell array
%        contents{get(hObject,'Value')} returns selected item from g2normalization

contents=cellstr(get(hObject,'String'));
choices=contents{get(hObject,'Value')};

if (strcmp(choices,'Symmetric'));
    handles.vg2normalization='symm';
    
elseif (strcmp(choices,'Normal'));
    handles.vg2normalization='norm';

end
    
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function g2normalization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g2normalization (see GCBO)
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
qpara=handles.qpara;
tauInTime=handles.tauInTime;
tauInFrames=handles.tauInFrames;

switch(get(handles.saves,'Value'))
    case 1
        header='g2 Value Normalized, Q Value, Tau in Seconds';
        [filename,pathname]=uiputfile('g2ValueNormalized.txt','Select Save Location');
        dlmwrite(filename,header,'delimiter','');
        dlmwrite(filename,g2ValueNormalized,'-append','delimiter','\t','newline','pc','roffset',1);
        dlmwrite(filename,qpara,'-append','delimiter','\t','newline','pc','roffset',1);
        dlmwrite(filename,tauInTime,'-append','delimiter','\t','newline','pc','roffset',1);
    case 0
        header='g2 Value Normalized, Q Value, Tau in Frames';
        [filename,pathname]=uiputfile('g2ValueNormalized.txt','Select Save Location');
        dlmwrite(filename,header,'delimiter','');
        dlmwrite(filename,g2ValueNormalized,'-append','delimiter','\t','newline','pc','roffset',1);
        dlmwrite(filename,qpara,'-append','delimiter','\t','newline','pc','roffset',1);
        dlmwrite(filename,tauInFrames,'-append','delimiter','\t','newline','pc','roffset',1);
end

guidata(hObject, handles);



% --- Executes on button press in saveunnorm.
function saveunnorm_Callback(hObject, eventdata, handles)
% hObject    handle to saveunnorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

g2ValueUnNormalized=handles.g2ValueUnNormalized;
qpara=handles.qpara;
tauInTime=handles.tauInTime;
tauInFrames=handles.tauInFrames;

switch(get(handles.saves,'Value'))
    case 1
        header='g2 Value UnNormalized, Q Value, Tau in Seconds';
        [filename,pathname]=uiputfile('g2ValueUnNormalized.txt','Select Save Location');
        dlmwrite(filename,header,'delimiter','');
        dlmwrite(filename,g2ValueUnNormalized,'-append','delimiter','\t','newline','pc','roffset',1);
        dlmwrite(filename,qpara,'-append','delimiter','\t','newline','pc','roffset',1);
        dlmwrite(filename,tauInTime,'-append','delimiter','\t','newline','pc','roffset',1);
    case 0
        header='g2 Value UnNormalized, Q Value, Tau in Frames';
        [filename,pathname]=uiputfile('g2ValueUnNormalized.txt','Select Save Location');
        dlmwrite(filename,header,'delimiter','');
        dlmwrite(filename,g2ValueUnNormalized,'-append','delimiter','\t','newline','pc','roffset',1);
        dlmwrite(filename,qpara,'-append','delimiter','\t','newline','pc','roffset',1);
        dlmwrite(filename,tauInFrames,'-append','delimiter','\t','newline','pc','roffset',1);
end

guidata(hObject, handles);


% --- Executes on button press in s.
function saves_Callback(hObject, eventdata, handles)
% hObject    handle to s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s

handles.saves=get(hObject,'Value');
handles.savef=get(handles.savef,'Value');

guidata(hObject, handles);


% --- Executes on button press in s.
function savef_Callback(hObject, eventdata, handles)
% hObject    handle to s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s

handles.savef=get(hObject,'Value');
handles.saves=get(handles.saves,'Value');

guidata(hObject, handles);



% --- Executes on button press in fitgui.
function fitgui_Callback(hObject, eventdata, handles)
% hObject    handle to fitgui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fitui


% --- Executes on button press in graphb.
function graphb_Callback(hObject, eventdata, handles)
% hObject    handle to graphb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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

legendMatrix={};
clear n;

for n=1:(handles.numqpara)
    legendMatrix(n)={sprintf('Speckle %d',n)};
end

switch(displayPlot)
    
    case('nf')
        
        switch(get(handles.li,'Value'))
            
            case(1)

        plot(handles.tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);

        plot(handles.tauInFrames,handles.g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
                
        plot(handles.tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);

        semilogx(handles.tauInFrames,handles.g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            end
                

    case('ns')
        
        switch(get(handles.li,'Value'))
            
            case(1)
        
        plot(handles.tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        plot(handles.tauInTime,handles.g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
                
        plot(handles.tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        semilogx(handles.tauInTime,handles.g2ValueNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
        end
        
    case('uf')
        
        switch(get(handles.li,'Value'))
            
            case(1)
        
        plot(handles.tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        plot(handles.tauInFrames,handles.g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
                
        plot(handles.tauInFrames,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        semilogx(handles.tauInFrames,handles.g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInFrames(:,1)) -Inf Inf])
        xlabel('Tau in Frames','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
        end
        
    case('us')
        
        switch(get(handles.li,'Value'))
            
            case(1)
        
        plot(handles.tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        plot(handles.tauInTime,handles.g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
            case(0)
                
        plot(handles.tauInTime,handles.sumIntensityQbins,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.qsumint);
        legend(handles.qsumint,legendMatrix);
        xlabel('Tau in Frames','Parent',handles.qsumint);
        ylabel('sumIntensity in q-bins','Parent',handles.qsumint);
        
        semilogx(handles.tauInTime,handles.g2ValueUnNormalized,'-o','LineWidth',2,'MarkerSize',1,'Parent',handles.q2v);
        axis([0 max(handles.tauInTime(:,1)) -Inf Inf])
        xlabel('Tau in seconds','Parent',handles.q2v);
        ylabel('g2ValueUnNormalized','Parent',handles.q2v);
        legend(handles.q2v,legendMatrix);
        
        end
        
end

handles.displayPlot=displayPlot;
setappdata(0,'displayPlot',handles.displayPlot);
setappdata(0,'loglinear',get(handles.li,'Value'));

guidata(hObject, handles);
