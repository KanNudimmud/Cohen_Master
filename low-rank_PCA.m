%% Matrix Analysis
% PCA of low-rank space-time data
%% Create a Low-rank Data
% Forward model with 3 projections
[X,Y] = meshgrid(-1:.2:1);
Z = exp( -(X.^2+Y.^2) );
n = length(Z);

% Show each of the projections
figure(1)

% Projection X (vertical linear)
subplot(231), imagesc(X);
set(gca,'xtick',[],'ytick',[])
axis square

% Projection Y (horizontal linear)
subplot(232), imagesc(Y);
set(gca,'xtick',[],'ytick',[])
axis square

% Projection Z (the Gaussian)
subplot(233), imagesc(Z);
set(gca,'xtick',[],'ytick',[])
axis square

% Sum of all projections
subplot(212)
h = imagesc(X+Y+Z); % create image handle for later updating
set(gca,'xtick',[],'ytick',[])
axis square

% Generate random time series data
N = 3000; % time points
sourcedata = randn(N,3); % uncorrelated source data

% Dataset is time by "sensors"
data = reshape(sourcedata * [X(:) Y(:) Z(:)]',[N n n]);

% Show a movie over time of some data
for i=1:100
    set(h,'CData',squeeze(data(i,:,:)));
    pause(.1)
end

%% PCA
% Reshape to 2D and mean-center
data2d = reshape(data,N,[]);
data2d = bsxfun(@minus,data2d,mean(data2d,1));

% Compute the covariance matrix
covmat = data2d' * data2d / (N-1);

% Covariance matrices usually look pretty:
figure(2)
imagesc(covmat)
set(gca,'xtick',[],'ytick',[])
axis square
title([ 'Covariance matrix of sensor array (rank=' num2str(rank(covmat)) ')' ])

% PCA is eigendecomposition of covariance
[evecs,evals] = eig(covmat);

% Sort eigenvalues and eigenvectors according to eigenvalue magnitude
[evals,sidx] = sort(diag(evals),'descend');
evecs = evecs(:,sidx);

% Plot the eigenspectrum
figure(3)
subplot(211)
plot(evals,'ks-','markersize',10,'markerfacecolor','w')
xlabel('Sorted component order')
ylabel('\lambda')
set(gca,'xlim',[0 20])

% Image the eigenvectors
for i=1:3
    subplot(2,3,3+i)
    imagesc(reshape(evecs(:,i),[n n]))
    set(gca,'xtick',[],'ytick',[])
    axis square
    title([ 'Component ' num2str(i) ])
end

%% end