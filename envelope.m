%% Time Series Analysis
% Find envelop over peaky, noisy signal
%% Generate a Noisy Signal and Compute Z-scored Signal
% Create peaky, noisy signal
npnts      = 5000; % signal length in points
propSpikes = .01; % proportion of points with spikes
numSpikes  = round(npnts*propSpikes); % actual number of peaks

% Select points for spikes
points2use = randperm(npnts);
points2use = points2use(1:numSpikes);

% Generate random noise and add spikes
signal             = 2*randn(npnts,1);
signal(points2use) = 2+100*rand(numSpikes,1);

% Compute the z-scored signal
zsignal = (signal-mean(signal)) / std(signal);

% Display the original signal
figure(1)
subplot(211)
plot(1:npnts,signal,'linew',2)
xlabel('Time'), ylabel('Amplitude')
title('Original Signal')

% Display the z-scored signal
subplot(212)
plot(1:npnts,zsignal,'s-')
xlabel('Time'), ylabel('Amplitude(z-normalized)')
title('Z-normalized Signal')

% Choose a threshold based on visual inspection
bestThresh = 1;

%% Determine the optimal threshold
% Loop over possible thresholds 
threshs  = linspace(.5,3,50);
numpeaks = zeros(size(threshs));
for i=1:length(threshs)
    % Determine the number of peaks for this threshold
    numpeaks(i) = sum(zsignal>threshs(i));
end

% Plot the number of peaks as a function of the thresholds
figure(2)
plot(threshs,numpeaks,'ks-','linew',2,'markerfacecolor','w')
xlabel('Threshold (z)'), ylabel('Number of peaks identified')

% Find the threshold closest to the known number of peaks
bestThresh = threshs(dsearchn(numpeaks',numSpikes));

%% Envelope Signal
% Use the best threshold to find peaks
peaktimes = find(zsignal > bestThresh);
peakvals  = signal(peaktimes);

% Interpolate across the peaks
interpsig = interp1(peaktimes,peakvals,1:npnts,'pchip','extrap');

% Display the interpolated signal on top of the original signal
figure(1)
subplot(211), hold on
plot(peaktimes,peakvals,'ro','markersize',10,'markerfacecolor','r')
plot(1:npnts,interpsig,'r')
set(gca,'ylim',[min(signal) max(signal)])
zoom on

% Display only the envelope signal
subplot(212)
plot(1:npnts,interpsig,'r')
xlabel('Time (a.u.)')

%% end