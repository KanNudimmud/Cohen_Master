%% Time Series Analysis
% High-pass FIR filter
%% Create a Signal and Filter
% Signal parameters
srate = 1000;
t     = 0:1/srate:10; % 10 seconds
n     = length(t);

% Create a signal which is Brownian
signal = cumsum( randn(n,1));

% Filter parameters
loweredge  = 10; % hz
transwidth = .15; % proportion

% Define filter shape 
filtershape = [0 0 1 1];

% Define filter frequencies and normalize to Nyquist
filterfrex  = [0 loweredge loweredge+loweredge*transwidth srate/2] / (srate/2);
filterorder = 40*loweredge;

% Create filter kernel
filterkernel = firls(filterorder,filterfrex,filtershape);

% Apply kernel to filter
filterTS = filtfilt(filterkernel,1,signal);

% Compute the power spectrum of the filter kernel
filtpow = abs(fft(filterkernel)).^2;
% Compute the frequencies vector and remove negative frequencies
hz      = linspace(0,srate/2,floor(filterorder/2)+1);
filtpow = filtpow(1:length(hz));

%% Visualize Signals, Kernel and Power Spectrum
% Plot original and filtered signal
figure(1)
subplot(211)
plot(t,signal,t,filterTS,'linew',2)
xlabel('Time (sec.)'), ylabel('Amplitude')
title('Time domain')
legend({'Original';'Filtered'})

% Plot filter kernel in the time domain
subplot(234)
plot(filterkernel,'linew',2)
xlabel('Time points')
title('Filter kernel')
set(gca,'xlim',[0 filterorder+1])

% Plot amplitude spectrum of the filter kernel
subplot(235), hold on
plot(hz,filtpow,'ks-','linew',2,'markerfacecolor','w')

% Plot the "ideal" filter specified above
plot(filterfrex*srate/2,filtershape,'ro-','linew',2,'markerfacecolor','w')

% Plot lower edge of the filter cut-off
plot([1 1]*loweredge,get(gca,'ylim'),'k:')

set(gca,'xlim',[0 loweredge*4],'ylim',[-.05 1.05])
xlabel('Frequency (Hz)'), ylabel('Filter gain')
legend({'Actual';'Ideal'})
title('Frequency response of filter')

% Replot the filter gain in decibel units
subplot(236), hold on
plot(hz,10*log10(filtpow),'ks-','linew',2,'markersize',10,'markerfacecolor','w')

% Plot filter edge
plot([1 1]*loweredge,get(gca,'ylim'),'k:')

set(gca,'xlim',[0 loweredge*4])
xlabel('Frequency (Hz)'), ylabel('Filter gain (dB)')
title('Frequency response of filter')

%% end