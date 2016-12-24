function [rescaleData] = imageSelect()

discreteQvalue=getappdata(0,'discreteQvalue');
startPixelX=getappdata(0,'startpixelX');
endPixelX=getappdata(0,'endpixelX');
startPixelY=getappdata(0,'startpixelY');
endPixelY=getappdata(0,'endpixelY');
numqpara=getappdata(0,'numqpara');
numImages=getappdata(0,'numImages');
data=getappdata(0,'data');
qpara=getappdata(0,'qpara');
qparaValue=getappdata(0,'qparaValue');
qparaTol=getappdata(0,'qparaTol');


if isequal(discreteQvalue,1)
 
h=waitbar(0,'Rescaling Data...');
    for k = 1:numImages
        for m=1:numqpara
            for i=1:(endPixelX(m)-startPixelX(m))
                for j=1:(endPixelY(m)-startPixelY(m))
                   rescaleData(i,j,k,m)=data(startPixelX(m)+i,startPixelY(m)+j,k);
                end
            end
        end
        waitbar(k/numImages);
    end
    close(h);

else
h=waitbar(0,'Rescaling Data...');
    for k =1:numImages
        for s=1:numqpara
            [m,n]=find(qpara>(qparaValue(s)-qparaTol(s))& qpara<(qparaValue(s)+qparaTol(s)));
            for p=1:length(m)
                rescaleData(p,k,s)= data(m(p),n(p),k);
            end
            sumIntensityQbins(k,s)=sum(rescaleData(:,k,s));
            clear m; clear n; 
        end
        waitbar(k/numImages);
    end
    setappdata(0,'sumIntensityQbins',sumIntensityQbins);
close(h);
end
