function [qx,qy,qz,q,qpara] = pixelToQconv()

% alphaRad = alpha*pi / 180;  % angle in radians

NumXpixel=getappdata(0,'NumXpixel');
NumYpixel=getappdata(0,'NumYpixel');
handles.dbxpixel=getappdata(0,'dbxpixel');
handles.dbypixel=getappdata(0,'dbypixel');
ImageDirection=getappdata(0,'imagedirection');
handles.alpha=getappdata(0,'alpha');
handles.pixelsize=getappdata(0,'pixelsize');
handles.samplecameradistance=getappdata(0,'samplecameradistance');
lambda=getappdata(0,'lambda');


    qx(1 : NumXpixel, 1 : NumYpixel) = 0;   % initialization of qx, qy and qz
    qz(1 : NumXpixel, 1 : NumYpixel) = 0;
    qy(1 : NumXpixel, 1 : NumYpixel) = 0;
    qxz(1 : NumXpixel, 1 : NumYpixel) = 0;
    q(1 : NumXpixel, 1 : NumYpixel) = 0;
    

    
    betaRad(1 : NumXpixel, 1 : NumYpixel) = 0;
    gammaRad(1 : NumXpixel, 1 : NumYpixel) = 0;
    
    switch(ImageDirection)
        
        case 'vert'

            alphaRad = handles.alpha*pi / 180;  % angle in radians
            betaRad = repmat(atan((([1:NumYpixel]'-handles.dbypixel)*handles.pixelsize)/handles.samplecameradistance),[1,NumXpixel]);
            gammaRad = repmat(atan(((handles.dbxpixel-[1:NumXpixel])*handles.pixelsize)/handles.samplecameradistance),[NumYpixel,1]);
            
            qx = ((2*3.14)/lambda).*(-cos(alphaRad)+cos(alphaRad + betaRad));
            qy = ((2*3.14)/lambda).* sin(gammaRad).*cos(alphaRad); 
            qz = ((2*3.14)/lambda).* (sin(alphaRad)+sin(alphaRad + betaRad));
            q = sqrt(qx.^2 + qy.^2 + qz.^2);
            qpara = sqrt(qx.^2 + qy.^2);
        
        case 'horz'
        
            alphaRad = handles.alpha*pi / 180;  % angle in radians
            gammaRad = repmat(atan((([1:NumXpixel]-handles.dbxpixel)*handles.pixelsize)/handles.samplecameradistance),[NumYpixel,1]);
            betaRad = repmat(atan(((handles.dbypixel-[1:NumYpixel]')*handles.pixelsize)/handles.samplecameradistance),[1,NumXpixel]);
            
            qx = ((2*3.14)/lambda).*(-cos(alphaRad)+cos(alphaRad + betaRad));
            qy = ((2*3.14)/lambda).* sin(gammaRad).*cos(alphaRad); 
            qz = ((2*3.14)/lambda).* (sin(alphaRad)+sin(alphaRad + betaRad));
            q = sqrt(qx.^2 + qy.^2 + qz.^2);
            qpara = sqrt(qx.^2 + qy.^2);
            
        case 'trans'
            
            alphaRad = 0;  % angle in radians
            betaRad = repmat(atan((([1:NumXpixel]-handles.dbxpixel)*handles.pixelsize)/handles.samplecameradistance),[NumYpixel,1]);
            gammaRad = repmat(atan(((handles.dbypixel-[1:NumYpixel]')*handles.pixelsize)/handles.samplecameradistance),[1,NumXpixel]);
            
            qx = ((2*3.14)/lambda).* (sin(alphaRad)+sin(alphaRad + betaRad));
            qy = ((2*3.14)/lambda).* (sin(alphaRad)+sin(alphaRad + gammaRad)); 
            qz = 0.0;
            q = sqrt(qx.^2 + qy.^2 + qz.^2);
            qpara = sqrt(qx.^2 + qy.^2);
    end

end
    
    
        
        
