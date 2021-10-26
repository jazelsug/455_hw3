%something in the background
string = mat2cell(num2str([1:10*10]'),ones(10*10,1));
%display the background
imagesc(I)
hold on
%insert the labels
I = magic(10)
%generate where each text will go
[X Y]=meshgrid(1:10,1:10);
%create the list of text
text(Y(:)-.5,X(:)+.25,string,'HorizontalAlignment','left')
%calculte the grid lines
grid = .5:1:10.5;
grid1 = [grid;grid];
grid2 = repmat([.5;10.5],1,length(grid))
%plot the grid lines
plot(grid1,grid2,'k')
plot(grid2,grid1,'k')