%% Finding Closest Point
%% When the point is close but not exact
% Create a list 
list = logspace( log10(1),log10(6),48 );

% Choose a point
searchnum = 2;

% Check if there is an exact match
find( list==searchnum )

% Option 1: Run each line at a time and examine graph)
figure(1)
subplot(211)
plot(abs(list-searchnum),'s-')

% Find the closest Euclidean distance
[val,idx] = min(sqrt((list-searchnum).^2));

% Plot the desired value on the plot
hold on
plot(idx,list(idx),'ro','markersize',10,'markerfacecolor','r')

% Arrange the location of the point and draw a dashed line to specifiy
% desired value
subplot(212)
plot(list,'s-')
hold on
plot(idx,list(idx),'ro','markersize',10,'markerfacecolor','r')
plot(get(gca,'xlim'),[1 1]*searchnum,'k--')
zoom on

%% finding matrix indices
% matrix sizes for reshaping the vector into a matrix
m = 4;
n = 8;

% Reshape into a matrix
matr = reshape( list(1:m*n) ,[m n]);

% Vectorize the matrix to find location of the closest point
idx = dsearchn(matr(:),searchnum);

% Convert vector to matrix indices
[xi,yi] = ind2sub(size(matr),idx);

% Show the closest point in the matrix
matr(xi,yi)
%% end