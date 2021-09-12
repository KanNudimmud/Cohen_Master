%% Cleaning Univariate Time Series
% Polynomial fitting to remove drifts
%% Create a Signal
% Parameters
n = 10000;
t = (1:n)';
k = 10; % number of poles for random amplitudes

% Original signal is a slow interpolated set of points
slowdrift = interp1(100*randn(k,1),linspace(1,k,n),'pchip')';

% Add noise to signal
signal = slowdrift + 20*randn(n,1);

%% Determine the Optimal Polynomial Order
orders = (5:40)'; % possible orders
sse1 = zeros(length(orders),1); % sum of squared errors(SSE)

% loop over orders
for ri=1:length(orders)
    
    % compute the polynomial
    yHat = polyval(polyfit(t,signal,orders(ri)),t);
    
    % compute SSE for this order
    sse1(ri) = sum((yHat-signal).^2);
end

% Bayes information criteria
bic = n*log(sse1) + orders*log(n);

% Best parameter has lowest BIC
[bestP,idx] = min(bic);

% Plot BIC for all orders, and put a red circle on the best one
figure(1)
plot(orders,bic,'s--'), hold on
plot(orders(idx),bestP,'ro','markersize',10,'markerfacecolor','r')
zoom on

%% Fitting and Filtering the Signal
% Polynomial fit
polycoefs = polyfit(t,signal,orders(idx));

% Extract estimated data based on the coefficients
yHat = polyval(polycoefs,t);

% The filtered signal is the difference of original and fitted 
filtsig = signal - yHat;

% Plot the original signal
figure(2), hold on
h = plot(t,signal);
set(h,'color',[1 1 1]*.6)

% Plot the polynomial fit
plot(t,yHat,'r','linew',2)

% Plot the filtered signal
plot(t,filtsig,'k')
set(gca,'xlim',t([1 end]))
legend({'Original';'Polynomial fit';'Filtered'})

%% end