%% Spectral Analysis
% Oscillations in human brain recordings
% Source : Mike Cohen
%% "Static" Power Spectrum
% Load the data
load EEGrestingState.mat

npnts = length(eegdata);

% Cector of frequencies
hz = linspace(0,srate/2,floor(npnts/2)+1);

% Compute signal power
sigpower = abs(fft(eegdata)/npnts).^2;

% Plot the power spectrum
figure(1)
subplot(211)
plot(hz,sigpower(1:length(hz)),'k','linew',2)
set(gca,'xlim',[0 30])
xlabel('Frequency (Hz)'), ylabel('Power')
title('Power spectrum from FFT')

%% Welch's Method
% Window length in time points
winlength = 4*srate;

% Window onset times
winonsets = round(linspace(1,npnts-winlength,50));

hzW = linspace(0,srate/2,floor(winlength/2)+1);

% Initialize the power matrix
sigpower2 = zeros(length(winonsets),length(hzW));

% Loop over frequencies
for wi=1:length(winonsets)
    
    % Get a chunk of data from this time window
    datachunk = eegdata(winonsets(wi):winonsets(wi)+winlength);
    
    % Compute its power
    tmppow = abs(fft(datachunk)/winlength).^2;
    
    % Update the matrix
    sigpower2(wi,:) = tmppow(1:length(hzW));
end

% Plot the power spectrum
subplot(212), cla
plot(hzW,mean(sigpower2,1),'k','linew',2)
set(gca,'xlim',[0 30])
xlabel('Frequency (Hz)'), ylabel('Power')
title('Power spectrum from Welch''s method')

%% end