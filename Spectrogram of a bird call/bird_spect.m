%% Spectral Analysis
% Spectrogram of bird call (Citrine Canary-flycatcher)
% Source: https://www.xeno-canto.org/89586
%% Compute Power Spectrum
% Load the  birdcall
[bc,fs] = audioread('XC89586.mp3');

soundsc(bc,fs)

% Create a time vector based on the data sampling rate
n = length(bc);
timevec = (0:n-1)/fs;

% Plot the data from the two channels
figure(1)
subplot(211)
plot(timevec,bsxfun(@plus,bc,[0 .2]))
xlabel('Time (sec.)')
title('Time domain')
set(gca,'ytick',[],'xlim',timevec([1 end]))

% Compute the power spectrum
hz = linspace(0,fs/2,floor(n/2)+1);
bcpow = abs(fft( detrend(bc(:,2)) )/n).^2;

% Plot the power spectrum
subplot(212)
plot(hz,bcpow(1:length(hz)),'linew',2)
xlabel('Frequency (Hz)')
title('Frequency domain')
set(gca,'xlim',[0 8000])

%% Time-frequency Analysis
% Use MATLAB's spectrogram function
[powspect,frex,time] = spectrogram(detrend(bc(:,2)),hann(1000),100,[],fs);

% Show the time-frequency power plot
figure(2)
imagesc(time,frex,log(abs(powspect).^2))
axis xy
set(gca,'clim',[-1 1]*5,'ylim',frex([1 dsearchn(frex,15000)]),'xlim',time([1 end]))
xlabel('Time (sec.)'), ylabel('Frequency (Hz)')
colormap hot

%% Compare Static and Dynamic Spectra
% Compare spectra from FFT vs. summed spectrogram (Welch's method)
figure(3),clf
subplot(211), hold on
plot(hz,bcpow(1:length(hz)),'linew',2)
plot(frex,10*sum(abs(powspect/n).^2,2),'r','linew',3)
xlabel('Frequency (Hz)')
title('Frequency domain')
set(gca,'xlim',[0 8000])
legend({'FFT power';'\Sigma spectrogram'})

% Compare root-mean-square vs. summed spectrogram (spectral energy)
subplot(212), hold on
plot(timevec,sqrt(mean(bc.^2,2)))
plot(time,.05+sum(abs(powspect).^2,1)/1000,'linew',3)
xlabel('Time (sec.)')
title('Time domain')
set(gca,'xlim',time([1 end]))
legend({'RMS';'\Sigma spectrogram'})

%%