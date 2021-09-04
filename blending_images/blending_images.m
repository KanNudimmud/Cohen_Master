%% Blending Images with Averaging and Transparency
%% Alpha (transparency) Maps
M = [1 2 3;
     4 5 6];

% Use alphadata to control the invisibility
alphdat = [  0 .5 1;
             0 .5 1];

figure(1), clf
subplot(131)
imagesc(M), axis square
title('Image, no alpha')

subplot(132)
imagesc(alphdat), axis square
title('Alpha (transparency) map')

subplot(133)
imagesc(M,'AlphaData',alphdat), axis square
title('Image with alpha')

%% Prepare Images
% Import images
carN = imread('new_car.jpg'); 
carO = imread('old_car.jpg'); 

% Reduce to 2D 
carN = mean(carN,3);
carO = mean(carO,3);

% Extract the size of car image
carsize = size(carN);

% Display images
figure(2), clf
subplot(121), imagesc(carN)
axis image

subplot(122), imagesc(carO)
axis image
colormap gray

% Resample the tape so the two images are the same size
RcarO = imresize(carO,size(carN));

%% Image Blending
% Method 1 : Averaging
figure(3), clf
imagesc((carN+RcarO)/2) 
axis image, colormap gray

% Method 2 : Using Transparency
figure(4), clf
imagesc(carN,'AlphaData',1/2)
hold on
imagesc(RcarO,'AlphaData',.5)
colormap gray, axis image

% Try a different alpha data
alphaLat = linspace(0,1,carsize(2));

figure(5), clf
h1 = imagesc(carN,'AlphaData',repmat(alphaLat,carsize(1),1));
hold on
h2 = imagesc(RcarO,'AlphaData',repmat(1-alphaLat,carsize(1),1));
colormap gray
axis image

%% old-school movie wipe
x = linspace(-2,2,carsize(2));

for ti=logspace(log10(.01),log10(100),20)
    
    % create sigmoid alpha curve
    sigmoid = 1./(1+ti*exp(-x));
    
    % set alpha data for image handle
    set(h2,'AlphaData',repmat(sigmoid,carsize(1),1));
    pause(.0025)
end
%% end