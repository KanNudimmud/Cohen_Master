%% Data transformations
%% Transformation of  normally distributed data
% Create log-normal distribution
n = 10000;
data = exp( 2+randn(n,1)/2 );
[y,x] = hist(data,100);

% Apply logarithm transformation
logData = log(data);
[yl,xl] = hist(logData,100);

% Apply square root transformation
sqrData = sqrt(data);
[ys,xs] = hist(sqrData,100);

% Apply rank (order) transformation
rankData = tiedrank(data);
[yr,xr] = hist(rankData,100);

%% Visualize transformations
figure(1), clf, hold on
plot(x,y,'k','linew',2)
plot(xl,yl,'bo','linew',2)
plot(xs,ys,'r--','linew',2)
plot(xr,yr,'ms-','linew',2)

legend({'Original';'Log';'Square root';'Ranked'})
set(gca,'xlim',[0 70])
xlabel('Value'), ylabel('Count')

%% Transformation of  non-normally distributed data to Gaussian
% Create non-normal distribution
dataN = linspace(100,.001,n) .* rand(1,n);

% Step 1: Apply rank (order) transformation
rankDataN = tiedrank(dataN);

% Step 2: Scale values between -1 to 1
rankDataN = rankDataN/n; % scale to maximum of 1
rankDataN = rankDataN*2; % scale to [0 2]
rankDataN = rankDataN-1; % scale to [-1 1]

% Step 3: Apply the inverse hyperbolic tangent
rankDataN = atanh(rankDataN);

%% Visualize data, distribuion and transformation
figure(2), clf
subplot(221)
plot(dataN), title('Data')

subplot(222)
hist(dataN,round(n/20))
title('Data distribution')

subplot(223)
plot(rankDataN)
title('Transformed data')

subplot(224)
hist(rankDataN,round(n/20))
title('Transformed distribution')
%% end