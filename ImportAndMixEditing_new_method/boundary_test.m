function judgement = boundary_test(matrix,i,j)
% In this function:
%judgement == -1 means the certain pixel on matrix(i,j) is outside the selection region
%judgement == 0 means the certain pixel on matrix(i,j) is outside the selection region
%judgement == 1 means the certain pixel on matrix(i,j) is a boundary within the selection region
%judgement == 2 means the certain pixel on matrix(i,j) is inside the selection region

[m n] = size(matrix);

if ((i-1>=1) && (i+1<=m) && (j-1>=1) && (j+1<=n)) %make sure current pixel is not on the edge of the matrix
    
    judgement = 2; %initialjudgement: suppose certain pixel on matrix(i,j) is inside of the selection region
    
	if(matrix(i,j)~=0)
       %(1)
       if(matrix(i+1,j)==0)
           judgement = 1;
       end
       %(2)
       if(matrix(i-1,j)==0)
           judgement = 1;
       end
       %(3)
       if(matrix(i,j+1)==0)
           judgement = 1;
       end
       %(4)
       if(matrix(i,j-1)==0)
           judgement = 1;
       end
    else
       judgement = 0;
    end
else
    judgement = -1;
end

end