function [object_new,new_background] = PoissonEditingImport(raw_object,background,background_x,background_y)
%%
%Create a new matrix containing the object
[m n] = find(raw_object>0);
object = zeros(max(m)-min(m)+1+2,max(n)-min(n)+1+2); %keep gaps on 4 edges

for i = min(m):max(m)
    for j = min(n):max(n)
        object(i-min(m)+1+1,j-min(n)+1+1) = raw_object(i,j); %start from the 2nd index
    end
end
%figure,imshow(uint8(object));title('1. object');

%%
%get the mask of the object
object_mask = object;
object_mask(object_mask>0) = 1;
%figure,imshow(uint8(object_mask*255));title('2. object mask');

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
%figure,imshow(uint8(boundary_filter*255));title('3. boundary filter');


%%
%assign background boundary pixel values to new container
boundary = zeros(row,col);
for i = 1:row
    for j = 1:col
        if (boundary_test(object,i,j)==1)  %is a boundary
            boundary(i,j) =  background(double(round(background_y-row/2+i)),double(round(background_x-col/2+j)));
        end
    end
end
%figure,imshow(uint8(boundary));title('5. boundary');

%%
%poisson editing 

%gradience
gradience = zeros(row,col);
gradience_filter = [0 -1 0;
                    -1 4 -1;
                    0 -1 0];
gradience = conv2(double(object),gradience_filter,'same');
gradience = gradience.* object_mask;
gradience = gradience.* (1-boundary_filter);
%tricky place
gradience = gradience + boundary;
%figure,imshow(uint8(gradience));title('6. gradience');

%jacobi calculation
gradience_filter2 = [0 1 0;
                    1 0 1;
                    0 1 0];
                
object_old = double(boundary);
object_new = object_old;

%fast way to go through
region_without_boundary = object_mask - boundary_filter;
%figure,imshow(uint8(region_without_boundary*255));title('region without boundary mask');
for iteration = 1:7000
    Rx = conv2(object_old,gradience_filter2,'same');
    for i = 1:row
        for j = 1:col
            if (region_without_boundary(i,j)>0)  %inside the selection region
                object_new(i,j) = 1/4*(gradience(i,j)+Rx(i,j));
            end
        end
    end
    object_old = object_new;
end
object_new = object_old;
object_new = object_new.* object_mask;
%figure,imshow(uint8(object_new));

%%
%%paste new object to background
    for i = 1:row
        for j = 1:col
            if (object_new(i,j)~=0)
                background(double(round(background_y-row/2+i)),double(round(background_x-col/2+j))) = object_new(i,j);
            end
        end
    end
    new_background = uint8(background);
    %figure,imshow(new_background);title(' final background');

