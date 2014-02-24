
clc
clear
close all
object_source = imread('cat.jpg');
background = imread('apple.jpg');
object_source1 = object_source(:,:,1);
object_source2 = object_source(:,:,2);
object_source3 = object_source(:,:,3);
background1 = background(:,:,1);
background2 = background(:,:,2);
background3 = background(:,:,3);

%%
%Get input coordinate of the object
%size
row = 90;
col = 150;
imshow(object_source);
[object_x,object_y] = ginput(1) %x,y=col,row
%%
%get input coordinate on background
imshow(background);title('background');
[background_x,background_y] = ginput(1); %x,y=col,row

new_background1 = PoissonEditing(object_source1,background1,row,col,object_x,object_y,background_x,background_y);
new_background2 = PoissonEditing(object_source2,background2,row,col,object_x,object_y,background_x,background_y);
new_background3 = PoissonEditing(object_source3,background3,row,col,object_x,object_y,background_x,background_y);
new_background(:,:,1) = new_background1;
new_background(:,:,2) = new_background2;
new_background(:,:,3) = new_background3;
imshow(new_background);

