%% Fractal Time Series and Images
% Weierstrass functions
%% Create a Signal and Compute Spectra
% Time vector
srate = 5000; % in Hz
t = -3:1/srate:3;

% Beta parameter
b = 5;

% Number of iterations to sum
n = 10;

% Loop over iterations and compute function
f = zeros(size(t));
for i=1:n
    f = f + 2^(-i) * cos(t*b^i);
end

% Compute the amplitude spectrum
hz = linspace(0,srate/2,floor(length(t)/2)+1);
fp = abs(fft(f)/length(f));

% Plot the time-domain signal
figure(1)
subplot(211)
plot(t,f,'k','linew',1)
xlabel('Time (sec.)')
set(gca,'xlim',t([1 end]))
title('Time domain')

% Plot the amplitude spectrum
subplot(212)
plot(hz,fp(1:length(hz)),'k','linew',2)
xlabel('Frequency (Hz)')
title('Frequency domain')
set(gca,'xlim',[0 120])

%% Find Peaks
% Transfrom the amplitude spectrum to z-scored
z = zscore(fp(1:length(hz)));

% Find peaks
peeks = find(diff(sign(diff(z)))<0)+1;

% Eliminate small peaks
peeks(z(peeks)<2) = [];

% Plot spectrum with peaks
figure(2)
subplot(211)
plot(hz,fp(1:length(hz)),'k','linew',2)
hold on
plot(hz(peeks),fp(peeks),'ro','markerfacecolor','r')
xlabel('Frequency (Hz)'), ylabel('Amplitude (z-norm)')


% Plot peak frequencies and relationship to b-parameter
subplot(212)
plot(hz(peeks),'rs-','linew',2,'markersize',18,'markerfacecolor','w')
hold on
plot(b.^(1:length(peeks))/(2*pi),'ks-','linew',2,'markersize',10,'markerfacecolor','y')

xlabel('Peak number')
ylabel('Frequency (Hz)')
set(gca,'xtick',1:length(peeks))
legend({'Empirical';'Analytic (b^i/2\pi)'})

%% end