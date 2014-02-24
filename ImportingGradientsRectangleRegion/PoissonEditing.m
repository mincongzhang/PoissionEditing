function new_background = PoissonEditing(object_source,background,row,col,object_x,object_y,background_x,background_y)
%%
%Create a new matrix containing the object
    for i = 1:row
        for j = 1:col
                object(i,j) = object_source(double(round(object_y-row/2))+i,double(round(object_x-col/2))+j);
        end
    end

%%
%create a new object to calculate
boundary = zeros(row,col);
    for i = 1:row
        for j = 1:col
                boundary(i,j) = background(double(round(background_y-row/2+i)),double(round(background_x-col/2+j)));
        end
    end
    
boundary_filter = ones(row,col);
    for i = 2:row-1
        for j = 2:col-1
                boundary_filter(i,j) = 0;
        end
    end

boundary = boundary.* boundary_filter;
%figure,imshow(uint8(boundary));title('boundary');

%gradience
gradience = zeros(row,col);
gradience_filter = [0 -1 0;
                    -1 4 -1;
                    0 -1 0];
gradience = conv2(double(object),gradience_filter,'same');
%tricky place
gradience = gradience.* (1-boundary_filter);
gradience = gradience + boundary;
%figure,imshow(uint8(gradience));title('gradience');

%jacobi calculation
gradience_filter2 = [0 -1 0;
                    -1 0 -1;
                    0 -1 0];
                
object_now = double(boundary);
object_next = object_now;

for iteration = 1:5000
    object_next = 1/4*(gradience-conv2(object_now,gradience_filter2,'same'));
    object_now = object_next;
end
new_object = object_now;
    
%%
%final pasting
    for i = 1:row
        for j = 1:col
                background(double(round(background_y-row/2+i)),double(round(background_x-col/2+j))) = new_object(i,j);
        end
    end
    new_background = uint8(background);
    
end

