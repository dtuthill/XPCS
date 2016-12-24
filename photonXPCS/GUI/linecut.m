% This program displays linecut data from the image array

global data dbXpixel dbYpixel

linect(1:length(data(:,1,1)),1:1)=0;

imageNumber=[1,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,90,110,125,130,135,140,150];   %This is the image number in the kinetic series

for k=1:length(imageNumber)
    for i=1:length(data(:,1,1))
        linect(i,k)=data(i,dbXpixel,imageNumber(k));
    end
end

for i=1:length(linect(:,1))
    avlinect(i)=sum(linect(i,:))/length(linect(1,:));
end

plot(linect(:,:)); % plots all different individual linecuts
hold on;
plot(avlinect,'-o','LineWidth',2,'MarkerEdgeColor','r','MarkerSize',3); %plots average linecut. should be similar to diffuse scattering signal as obtained using incoherent light.
