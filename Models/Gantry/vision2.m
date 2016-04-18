im = imread('/Users/francispoole/Google Drive/Computer Science With AI/JRA/Models/Gantry/flow.jpg');
im1 = im(:,1:276,:);
im1 = rgb2gray(im1);
im2 = im(:,277:end,:);
im2 = rgb2gray(im2);
[u,v] = LucasKanade(im1,im2,209)
imshow(u);
imshow(v);