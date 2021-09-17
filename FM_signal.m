%% Time Series Analysis 
% Create a "chirp" (FM signal)
%% Dipolar Frequency
% Parameters
srate = 1000;
time  = 0:1/srate:5;
pnts  = length(time);
hz    = linspace(0,srate/2,floor(pnts/2)-1);

% Frequency range for dipolar chirp
f  = [5 15]; % in Hz

% Dipolar frequency formula
ff = f(1) + (mean(f)-f(1))*(0:pnts-1)/pnts;
signal = sin(2*pi*ff.*time);

% Compute power spectrum
chirppow = abs(fft(signal)/pnts).^2;

% Compute instantaneous frequency
phaseangles = angle(hilbert(signal));
instfreq = diff(unwrap(phaseangles)) / (2*pi/srate);

% Plot signal
figure(1), clf
subplot(311)
plot(time,signal,'linew',2)
xlabel('Time (s)'), ylabel('Amplitude')
title('Chirp signal')

% Plot power spectrum
subplot(312)
plot(hz,chirppow(1:length(hz)),'s-','linew',2)
set(gca,'xlim',[0 f(2)+5])
xlabel('Frequency (Hz)'), ylabel('Power')
title('Power spectrum of chirp')

% Plot the theoretical instantaneous frequency
subplot(313), hold on
plot(time([1 end]),f,'r','linew',2)

% Plot the empirical instantaneous frequency
plot(time(1:end-1),instfreq,'linew',2)
xlabel('Time (sec.)'), ylabel('Frequency (Hz)')
title('Frequency time series (FM)')
legend({'Specified';'Empirical'})

%% Multipolar Frequency
% Multipolar frequency formula
freqmod = exp(-(time-mean(time)).^2)*10+10;
signal  = sin(2*pi*(time + cumsum(freqmod)/srate));

% Compute power spectrum
chirppow = abs(fft(signal)/pnts).^2;

% Compute instantaneous frequency
phaseangles = angle(hilbert(signal));
instfreq = diff(unwrap(phaseangles)) / (2*pi/srate);

% Plot signal
figure(2), clf
subplot(311)
plot(time,signal,'linew',2)
xlabel('Time (s)'), ylabel('Amplitude')
title('Chirp signal')

% Plot power spectrum
subplot(312)
plot(hz,chirppow(1:length(hz)),'s-','linew',2)
set(gca,'xlim',[0 f(2)+10])
xlabel('Frequency (Hz)'), ylabel('Power')
title('Power spectrum of chirp')

% Plot instantaneous frequency
subplot(313), hold on
plot(time,freqmod,'r','linew',2)
plot(time(1:end-1),instfreq,'linew',2)
set(gca,'ylim',[0 max(freqmod)+10])
xlabel('Time (sec.)'), ylabel('Frequency (Hz)')
title('Frequency time series (FM)')
legend({'Specified';'Empirical'})

%% end