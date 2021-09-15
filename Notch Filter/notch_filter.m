%% Time Series Analysis
% Line noise notch filter
%% Compute Power Spectrum 
% Load dataset
load EEGrestingState.mat

% Convert the data to double for computations
eegdata = double(eegdata);

% Create a time vector
npnts = length(eegdata);
time  = (0:npnts-1)/srate;

% Compute power spectrum
eegpow = abs(fft(eegdata/npnts)).^2;

% Compute vector of frequencies
hz = linspace(0,srate/2,floor(npnts/2)+1);

% Display data and power spectrum
figure(1), clf
subplot(211)
plot(time,eegdata,'k')
xlabel('Time (sec.)'), ylabel('Amplitude (\muV)')

subplot(212)
plot(hz,eegpow(1:length(hz)),'k')
xlabel('Frequency (Hz)'), ylabel('Power (\muV^2)')
zoom on

%% Filtering
% Filter parameters
notchcenter = 50; % Hz
notchwidth  = .5; % Hz on either side

frex2notch = (1:6)*notchcenter;

eegdataF = eegdata;

% Loop over the frequencies to notch out
for fi=1:length(frex2notch)
    % Filter bands, normalized to Nyquist
    bands = [ frex2notch(fi)-notchwidth frex2notch(fi)+notchwidth ]/(srate/2);
    
    % Compute filter kernel
    filtk = fir1(2000,bands,'stop');
    
    % Apply the filter to the data
    eegdataF = filtfilt(filtk,1,eegdataF);  
end

% Compute power spectrum
eegpowF = abs(fft(eegdataF )/npnts ).^2;

% Plot the notch-filtered time series
subplot(211), hold on
plot(time,eegdataF,'r')
xlabel('Time (sec.)'), ylabel('Amplitude (\muV)')
legend({'Original';'Notch-Filtered'})

% Plot the power spectrum
subplot(212), hold on
plot(hz,eegpowF(1:length(hz)),'r')
xlabel('Frequency (Hz)'), ylabel('Power (\muV^2)')
legend({'Original';'Notch-Filtered'})

%%