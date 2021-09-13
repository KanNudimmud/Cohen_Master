%% Time Series Analysis
% Convolution
%% Create Signal and Kernel
% Number of time points
n = 10000;

% Create a signal which is Brownian motion
signal = cumsum(randn(n,1));

% Create a kernel that is a Gaussian
k = 100;
kernel = exp(-(-k:k).^2/k); % increasing k in denominator supplies smootheness
kernel = kernel' ./ sum(kernel);

% Flip the kernel backwards
kernelB = zeros(2*k+1,1);
for t=0:length(kernel)-1
    kernelB(t+1) = kernel(2*k+1-t);
end    

% Display the kernel
figure(1)
subplot(223)
plot(-k:k,kernel,'m','linew',2)
title('Convolution kernel')
xlabel('Time points'), ylabel('Amplitude')

%% Convolution in Time Domain
convres = zeros(size(signal));
for ti=1+k:n-k
    % Part of the signal
    littlesig = signal(ti-k:ti+k);
    
    % Convolution at this point is the dot product
    convres(ti) = dot(kernelB,littlesig);
end
    
% Display the signal and result of convolution
subplot(211)
plot(1:n,signal, 1:n,convres,'linew',3)
xlabel('Time (a.u.)'), ylabel('Amplitude')
title('Time domain')

%% Convolution in Frequency Domain
% FFTs of signal and kernel
nconv = 2*k+n;
sigX = fft(signal,nconv);
krnX = fft(kernel,nconv);
hz   = linspace(0,1,nconv); % normalized units

% Convolution is inverse of multiplied spectra
convres2 = real(ifft(sigX .* krnX));
convres2 = convres2(k+1:end-k); % cut off "wings"

% Display normalized amplitude spectra
subplot(224)
plot(hz,abs(sigX)./ max(abs(sigX)),'linew',2)
hold on
plot(hz,abs(krnX)./ max(abs(krnX)),'linew',2)
set(gca,'xlim',[0 .2])
legend({'Signal';'Kernel'})
xlabel('Frequency (norm.)'), ylabel('Amplitude (norm.)')
title('Frequency domain')

% Display the result of convolution
subplot(211), hold on
plot(1:n,convres2,'k','linew',2)
legend({'Signal';'Convolution(time)';'Convolution(freq)'})

%% end