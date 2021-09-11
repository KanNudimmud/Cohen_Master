%% Cleaning univariate time series
% Median filtering with threshold
%% Create signal and noise
% Define signal parameters
srate = 769; % Hz
t     = 0:1/srate:3;
n     = length(t);

% Proportion of time points to replace with noise
prop = .05;

% Create noise points 
noise = randperm(n);

% Find noise points 
noise = noise(1:round(prop*n));

% Generate a signal and replace points with noise
signal        = sin(2*pi*5*t);
signal(noise) = rand(size(noise))*100 + 50;

%% Thresholding
% Data-driven threshold based on derivative of sorted values
ss        = sort(signal);
ds        = diff(ss);
[~,idx]   = max(ds);
thres     = ss(idx+1)-1;

% Find data values above the threshold
suprath = find(signal >thres);

%% Median Filter
% Initialize filtered signal
filtsig = signal;

% Loop through suprathreshold points and set to median of k
k = 20; % actual window is k*2+1
for i=1:length(suprath)
    
    lowbnd = max(1,suprath(i)-k);
    uppbnd = min(suprath(i)+k,n);
    
    % Compute median of surrounding points
    filtsig(suprath(i)) = median(signal(lowbnd:uppbnd));
end

% Plot the original and filtered signal
figure(1)
plot(t,signal, t,filtsig, 'linew',2)
legend({'Original';'Median-Filtered'})
zoom on

%% end