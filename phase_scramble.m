%% Spectral Analysis
% Phase-scramble narrowband time series
%% Create signal
% Parameters
srate = 600;  % sampling rate in Hz
npnts = srate*2; % number of time and frequency points
time  = (0:npnts-1)/srate;% time vector

% Create frequencies vector 
hz = linspace(0,srate,npnts);

% Parameters for frequency-domain Gaussian
fwhm  = 5;  % fwhm in Hz
peakf = 13; % peak frequency of Gaussian, in Hz

% Create Gaussian
s  = fwhm*(2*pi-1)/(4*pi); % normalized width
x  = hz-peakf;             % shifted frequencies
fx = exp(-.5*(x/s).^2);    % the Gaussian

% Signal is ifft of gaussian times random noise
signal = real(ifft(fx.*rand(1,npnts)));

% Compute the Fourier transform of the signal
signalX = fft(signal);

% Shuffle the phases
phases = angle(signalX(randperm(npnts))); 

% Create a new Fourier series as ae^{ip}
shuffdata = abs(signalX) .* exp(1i*phases);

% Reconstruct the signal from the Fourier series
shuffsig = ifft(shuffdata);

% Plot both time series
figure(1), clf
subplot(211), hold on
plot(time,signal,'k','linew',2)
plot(time,real(shuffsig),'r.')
legend({'Original';'Shuffled'})
xlabel('Time (sec.)'), ylabel('Amplitude')
title('Time domain')

%% Power Spectrum
% Compute power spectra
signalPow = abs( fft(signal)/npnts).^2;
shuffPow  = abs( fft(shuffsig)/npnts).^2;

% Cector of frequencies
hz = linspace(0,srate/2,floor(npnts/2)+1);

% Plot the power spectra
subplot(212)
plot(hz,signalPow(1:length(hz)),'k','linew',2), hold on
plot(hz,shuffPow(1:length(hz)),'ro','markerfacecolor','r')
set(gca,'xlim',[0 peakf*2])
xlabel('Frequency (Hz)')
title('Frequency domain')

%% end