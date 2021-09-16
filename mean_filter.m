%% Time series analysis
% Frequency-domain mean filter
%% Compare Time-domain vs Frequency-domain on Mean Filter
% Create noisy signal
n      = 10000;
signal = randn(n,1);

% Filter kernel size
k = 30; % actually creates a k*2+1 filter

% Loop over the timing experiment
numIter = 100;
timr    = zeros(numIter,2);
for iter=1:numIter
    % Generate new signal
    signal = randn(n,1);
    
    % Time-domain running-mean filter
    tic; % start timer
    filtsigTD = zeros( size(signal) );
    for ti=k+1:n-k
        filtsigTD(ti) = mean(signal(ti-k:ti+k));
    end
    timr(iter,1) = toc;
    
    % Convolution in Frequency-domain
    tic; % start timer
    kernel = ones(2*k+1,1) / (2*k+1);
    nConv  = n+2*k; % N+M-1
    
    sigX = fft(signal,nConv);
    krnX = fft(kernel,nConv);
    
    filtsigFD    = ifft(sigX .* krnX);
    filtsigFD    = filtsigFD(k+1:end-k); % cut off the "wings" of convolution
    timr(iter,2) = toc; % end timer
    
end

% Plot the signal and filtered signals
figure(1)
subplot(211)
plot(1:n,[signal,filtsigTD,filtsigFD])
zoom on
legend({'Original';'Time-domain filter';'Frequency-domain filter'})
title([ 'Time and frequency domain filtered signals correlate at r=' num2str(corr(filtsigFD,filtsigTD)) ])

% Plot computation time
subplot(212)
bar(mean(timr,1)), hold on
errorbar(mean(timr),std(timr),'.')
set(gca,'xlim',[.5 2.5],'xtick',1:2,'XTickLabel',{'Time';'Freq'})
ylabel('Computation time (s)')

%% end