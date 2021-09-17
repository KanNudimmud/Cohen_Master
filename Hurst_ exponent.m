%% Time Series Analysis
% Detrended fluctuation analysis
%% Create and Display the Data
% Create data with DFA=.5
N = 3001;
signal1 = randn(N,1);

% Create data with "long-term memory" (1/f power spectrum)
as = rand(1,floor(N/2)-1) .* exp(-(1:floor(N/2)-1)/50);
as = [as(1) as 0 0 as(:,end:-1:1)];
fc = as .* exp(1i*2*pi*rand(size(as)));
signal2 = real(ifft(fc)*N);

% Setup parameters and initialize
nScales = 20;
ranges  = round([.01 .2]*N);
scales  = ceil(logspace(log10(ranges(1)),log10(ranges(2)),nScales));
rmses   = zeros(2,nScales);

% Plot  two signals
figure(1), clf
subplot(221)
plot(1:N,signal1)
title('Signal 1: white noise')
xlabel('Time (a.u.)')

subplot(222)
plot(1:N,signal2)
title('Signal 2: pink noise')
xlabel('Time (a.u.)')

% Integrate and mean-center the signals
signal1 = cumsum(signal1-mean(signal1));
signal2 = cumsum(signal2-mean(signal2));

% Show those time series for comparison
subplot(223)
plot(1:N,signal1)
title('Integrated noise')

subplot(224)
plot(1:N,signal2)
title('Integrated noise')
%% Compare Hurst Exponent of Noises
% Compute RMS over different time scales
for scalei = 1:nScales
    % Number of epochs for this scale
    n = floor(N/scales(scalei));
    
    % Compute RMS for signal1
    epochs  = reshape( signal1(1:scales(scalei)*n) ,scales(scalei),n);
    depochs = detrend(epochs);% detrend
    
    % Root mean square computation
    rmses(1,scalei) = mean(sqrt(mean(depochs.^2,1)));
    
    % Repeat for signal2
    epochs  = reshape( signal2(1:scales(scalei)*n) ,scales(scalei),n);
    depochs = detrend(epochs);
    rmses(2,scalei) = mean(sqrt(mean(depochs.^2,1)));
end

% Fit a linear model to quantify scaling exponent
A = [ ones(nScales,1) log10(scales)' ];  % linear model
dfa1 = (A'*A) \ (A'*log10(rmses(1,:))'); % fit to signal1
dfa2 = (A'*A) \ (A'*log10(rmses(2,:))'); % fit to signal2

% Plot the 'linear' fit (in log-log space)
figure(2), clf, hold on

% Plot results for white noise
plot(log10(scales),log10(rmses(1,:)),'rs','linew',2,'markerfacecolor','w','markersize',10)
plot(log10(scales),dfa1(1)+dfa1(2)*log10(scales),'r--','linew',2)

% Plot results for pink noise
plot(log10(scales),log10(rmses(2,:)),'bs','linew',2,'markerfacecolor','w','markersize',10)
plot(log10(scales),dfa2(1)+dfa2(2)*log10(scales),'b--','linew',2)

legend({'Data (S1)';[ 'Fit (DFA m=' num2str(dfa1(2)) ')' ]; ...
        'Data (S2)';[ 'Fit (DFA m=' num2str(dfa2(2)) ')' ] })
xlabel('Data scale (log)'), ylabel('RMS (log)')
title('Comparison of Hurst exponent for different noises')
axis square

%% end