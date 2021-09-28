%% Nonparametric Statistics
% Bootstrapping to define confidence intervals
%%
% Create data
N = 30;
data = randn(N,1).^3;

% Extract the mean of the data
datamean = mean(data);

% Number of bootstraps
nstraps = 1000;

% Show a histogram of the data
figure(1), clf
subplot(5,1,1:4)
hist(data)

ylim = get(gca,'ylim');
xlim = get(gca,'xlim');

% Vertical line for the observed mean
hold on
plot([1 1]*datamean,ylim,'m--','linew',3)

% Initialize bootstrap distribution
bootmean = zeros(nstraps,1);

% The loop which does bootstrapping
for booti=1:nstraps
    % Pick values with replacement
    vals2samples = randsample(N,N,1);
    vals2samples = ceil(N*rand(N,1)); %  without statistic toolbox
    
    % Compute mean of that sample
    bootmean(booti) = mean( data(vals2samples) );
end

% Show a histogram of the bootstrapped mean values
subplot(515)
hist(bootmean,50)
xlabel('Values')
set(gca,'xlim',xlim)

% Get confidence intervals
bootsort = sort( bootmean );
ni95 = bootsort(dsearchn( linspace(0,100,nstraps)',[2.5 97.5]' ));

% Add lines for the sample mean and confidence intervals
subplot(5,1,1:4)
plot([1 1]*ni95(1),ylim,'g--','linew',3)
plot([1 1]*ni95(2),ylim,'g--','linew',3)
ylabel('Count')
legend({'data';'Mean';'95% CI'})

%% end