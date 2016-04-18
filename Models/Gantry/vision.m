clc
close all
clear all

dt = 1;

sizeX = 500;
sizeY = 500;

tic
image1 = getImage(sizeX,sizeY);
image1 = image1<0.2;
s = sum(image1,1);
[C,i1] = max(s);
i1
while (toc < dt)
   %do nothing 
end

image2 = getImage(sizeX,sizeY);

image2 = image2<0.2;
s = sum(image2,1);
[C,i2] = max(s);
i2


velocity = (i1 - i2)/dt






imshow(image1);
pause(1)
imshow(image2);