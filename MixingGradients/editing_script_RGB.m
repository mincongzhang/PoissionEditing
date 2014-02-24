clc
clear
close all
object_source = imread('rainbow.jpg');
background = imread('cloud.jpg');
object_source1 = object_source(:,:,1);
object_source2 = object_source(:,:,2);
object_source3 = object_source(:,:,3);
background1 = background(:,:,1);
background2 = background(:,:,2);
background3 = background(:,:,3);

%%
%Get the arbitrary shape
roipoly_mask = roipoly(object_source);
roipoly_mask = double(roipoly_mask);
object_source1 = double(object_source1);
object_source2 = double(object_source2);
object_source3 = double(object_source3);
raw_object1 = object_source1.*roipoly_mask;
raw_object2 = object_source2.*roipoly_mask;
raw_object3 = object_source3.*roipoly_mask;
%figure,imshow(uint8(raw_object));title('raw_object');

%get input coordinate on background
figure,imshow(background);
[background_x,background_y] = ginput(1); %x,y=col,row
close all

%new_background = PoissonEditing(raw_object,background,background_x,background_y);
new_background1 = PoissonEditing(raw_object1,background1,background_x,background_y);
new_background2 = PoissonEditing(raw_object2,background2,background_x,background_y);
new_background3 = PoissonEditing(raw_object3,background3,background_x,background_y);

new_background(:,:,1) = new_background1;
new_background(:,:,2) = new_background2;
new_background(:,:,3) = new_background3;
figure,imshow(new_background)