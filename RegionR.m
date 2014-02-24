%
%The Equation (2) in the paper is simply set delta f as 0. It means in the
%region R we calculate without gradience(or gradience = 0)
%This script simplifies the poisson editing with gradience = 0 in selected region

clc
clear
close all
background = imread('apple.jpg');
background = rgb2gray(background);

%%
%Get the arbitrary shape
roipoly_mask = roipoly(background);
roipoly_mask = double(roipoly_mask);
background = double(background);
raw_object = background.*roipoly_mask;
%figure,imshow(uint8(raw_object));title('raw_object');

%get input coordinate on background
figure,imshow(uint8(background));title('background');
[x,y] = ginput(1); %x,y=col,row
close all
%%
%Create a new matrix containing the object
[m n] = find(raw_object>0);
object = zeros(max(m)-min(m)+1+2,max(n)-min(n)+1+2); %keep gaps on 4 edges

for i = min(m):max(m)
    for j = min(n):max(n)
        object(i-min(m)+1+1,j-min(n)+1+1) = raw_object(i,j); %start from the 2nd index
    end
end

%%
%get the mask of the object
object_mask = object;
object_mask(object_mask>0) = 1;

%%
%get the boundary filter of the object
[row,col] = size(object);
boundary_filter = zeros(row,col);
for i = 1:row
    for j = 1:col
        if(boundary_test(object,i,j)==1) %is a boundary
            boundary_filter(i,j) = 1;
        end
    end
end


%%
%assign background boundary pixel values to new container
boundary = zeros(row,col);
for i = 1:row
    for j = 1:col
        if (boundary_test(object,i,j)==1)  %is a boundary
            boundary(i,j) =  background(double(round(y-row/2+i)),double(round(x-col/2+j)));
        end
    end
end

%%
%poisson editing 

%gradience
gradience = zeros(row,col);
gradience_filter = [0 -1 0;
                    -1 4 -1;
                    0 -1 0];
gradience = conv2(double(object),gradience_filter,'same');
%tricky place
gradience = gradience.* object_mask;
gradience = gradience.* (1-boundary_filter);
gradience = gradience + boundary;

%jacobi calculation
gradience_filter2 = [0 1 0;
                    1 0 1;
                    0 1 0];
                
object_old = double(boundary);
object_new = object_old;

%fast way to go through
region_without_boundary = object_mask - boundary_filter;

for iteration = 1:1000
    Rx = conv2(object_old,gradience_filter2,'same');
    for i = 1:row
        for j = 1:col
            if (region_without_boundary(i,j)>0)  %inside the selection region
                object_new(i,j) = 1/4*(Rx(i,j));
            end
        end
    end
    object_old = object_new;
end
object_new = object_old;
object_new = object_new.* object_mask;

%%
%%paste new object to background
    for i = 1:row
        for j = 1:col
            if (object_new(i,j)~=0)
                background(double(round(y-row/2+i)),double(round(x-col/2+j))) = object_new(i,j);
            end
        end
    end
    new_background = uint8(background);
    figure,imshow(new_background);title(' final background');

