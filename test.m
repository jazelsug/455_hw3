% %something in the background
% string = mat2cell(num2str([1:10*10]'),ones(10*10,1));
% %display the background
% imagesc(I)
% hold on
% %insert the labels
% I = magic(10)
% %generate where each text will go
% [X Y]=meshgrid(1:10,1:10);
% %create the list of text
% text(Y(:)-.5,X(:)+.25,string,'HorizontalAlignment','left')
% %calculte the grid lines
% grid = .5:1:10.5;
% grid1 = [grid;grid];
% grid2 = repmat([.5;10.5],1,length(grid))
% %plot the grid lines
% plot(grid1,grid2,'k')
% plot(grid2,grid1,'k')

%Generate the X and Y grid arrays using the MESHGRID function.
x = [1:6];
y = [1:4];
[X,Y] = meshgrid(x,y)
%Note that size(Z) is the same as size(x) and size(y)
Z = [1 0 -2 1 2 1;2 -2 0 -1 0 1;1 0 0 -2 2 1;1 1 1 1 1 1];
% % create a colormap having RGB values of dark green,
% %light green, white, dark red and light red.
% map2 = [0 1 0; 0 0.8 0;1 1 1;0.6 0 0;1 0 0 ];
% %use the user defined colormap for figure.
% colormap(map2);
%plot the figure
pcolor(X,Y,Z);
% %set the x and y labels
% set(gca,'XTick',[1 2 3 4 5 6],'YTick',[1 2 3 4],'XTicklabel',[' ';'a';'b'; 'c'; 'd';'e'],'YTicklabel',[' ';'f';'g';'h']);
% %set the color limits
% caxis([-2 2])