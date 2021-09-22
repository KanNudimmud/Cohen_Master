%% Time Series Analysis
% Time frequency analysis via wavelet convolution
%%  Signal and Morlet Wavelet
% Create signal
srate = 1000;
time  = -3:1/srate:3;
pnts  = length(time);
freqmod = exp(-time.^2)*10+10;
freqmod = freqmod + linspace(0,10,pnts);% add linear trend
signal  = sin(2*pi*(time+cumsum(freqmod)/srate));% compute signal based on instantaneous frequency modulation

% Frequencies for TF analysis
nfrex = 50; % 50 frequencies
frex  = linspace(3,35,nfrex);

% Create complex Morlet wavelet family
[wavelets,tf] = deal( zeros(nfrex,pnts) );

for wi=1:nfrex
    % Width of Gaussian (number of cycles = 13)
    s = 13/(2*pi*frex(wi));
    % Create complex wavelet
    wavelets(wi,:) = exp(1i*2*pi*time*frex(wi)) .* exp(-time.^2/(2*s^2));
end

% Create an image of the wavelets
figure(1)
contourf(time,frex,real(wavelets),40,'linecolor','none')
xlabel('Time (s)'), ylabel('Frequency (Hz)')
title('Real part of wavelets')

%% Convolution
% Parameters for convolution
nConv = 2*pnts-1;
halfk = floor(pnts/2)+1;

% FFT of the signal
sigX = fft(signal,nConv);

% Convolution per frequency
for fi=1:nfrex
    
    % FFT of the wavelet
    waveX = fft(wavelets(fi,:),nConv);
    
    % Normalize the wavelet
    waveX = waveX ./ max(waveX);
    
    % "Manual" convolution
    convres = ifft(waveX .* sigX);
    convres = convres(halfk:end-halfk+1);
      
    % Extract power from complex signal
    tf(fi,:) = abs(convres);
end
    
% Plot the time-domain signal
figure(2)
subplot(411)
plot(time,signal,'linew',1)
xlabel('Time (s)')
title('Time-domain signal')

% Plot the time-frequency response
subplot(4,1,[2 3 4])
contourf(time,frex,tf,40,'linecolor','none')
xlabel('Time (s)'), ylabel('Frequency (Hz)')
title('time-frequency power')

%% end