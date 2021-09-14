%% Time Series Analysis
% Narrow-band filter via frequency-domain Gaussian
%% Create a Signal and Filter
% Signal parameters
srate  = 512; % Hz
time   = 0:1/srate:5; % create 5 seconds of data using this sampling rate
npnts  = length(time);

% Generate broadband signal
signal = randn(npnts,1);

% Filter parameters
fwhm  = 4; % full-width at half-maximum, in Hz
peakf = 8; % peak frequency, also in Hz
hz    = linspace(0,srate,npnts)';

% Create Gaussian
s  = fwhm*(2*pi-1)/(4*pi); % normalized width
x  = hz-peakf;             % shifted frequencies
fx = exp(-.5*(x/s).^2);    % gaussian

% Filter the signal via circular convolution
filtdat = 2 * real(ifft(fft(signal).*fx));

%% Compute empirical peak and FWHM
fidx  = dsearchn(hz,8);
fwhmX = [ dsearchn(fx(1:fidx),.5) dsearchn(fx(fidx:end),.5)+fidx-1];

% Empirical FWHM
empfwhm = diff(hz(fwhmX));

% Empirical peak frequency
emppeak = hz(fidx);

%% Visualize signals
figure(1)

% Plot the original and filtered signals
subplot(211), hold on
h = plot(time,signal);
set(h,'color',[1 1 1]*.7)
plot(time,filtdat,'r','linew',2)
xlabel('Time (s)'), ylabel('Amplitude gain')
title('Signals in time domain')

% Plot the spectral response of the filter
subplot(212), hold on
plot(hz,fx,'ko-','markersize',6,'markerfacecolor','y')
set(gca,'xlim',[max(peakf-10,0) peakf+20]);
xlabel('Frequency (Hz)'), ylabel('Amplitude gain')

% Draw a dashed line at 50% gain
plot(hz(fwhmX),fx(fwhmX),'k--')
title([ 'Requested: ' num2str(peakf) ', ' num2str(fwhm) ' Hz; Empirical: ' num2str(emppeak) ', ' num2str(empfwhm) ' Hz' ])

%% end