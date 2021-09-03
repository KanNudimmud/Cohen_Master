%% Compute measures of central tendency (mean, median, mode)
%% Create a dataset
data = round( exp(2+randn(101,1)/2) );

% Display the data in a histogram
figure(1), clf
histogram(data,20)

%% Compute the mean
% Extract the number of elements
n = numel(data);

% Write down the formula
dataMean = sum(data)/n;

% Compare with built-in(MATLAB) function
dataMean_M = mean(data);
diffMean   = abs(dataMean-dataMean_M);

%% Compute the median
% Firstly, sort the data
sortedData = sort(data);

% Find the middle value
dataMedian = sortedData(ceil(n/2));

% Compare with built-in function
dataMedian_M = median(data);
diffMedian   = abs(dataMedian-dataMedian_M);

%% Compute the mode
% Find unique data values
uniqVal = unique(data);

% loop through values and count the number of each value
numVals = zeros(size(uniqVal));
for i=1:length(numVals)
    numVals(i) = sum(data == uniqVal(i));
end

% find the maximum count
[~,maxidx] = max(numVals);

% Extract the mode (seen the most times)
dataMode = uniqVal(maxidx);

% compare with MATLAB function
dataMode_M = mode(data);
diffMode   = abs(dataMode-dataMode_M);

%% Visualize measures of central tendency
hold on
plot([1 1]*dataMean,get(gca,'ylim'),'k--','linew',4)
plot([1 1]*dataMedian,get(gca,'ylim'),'g--','linew',4)
plot([1 1]*dataMode,get(gca,'ylim'),'r--','linew',4)

legend({'Data';'mean';'median';'mode'})
xlabel('Value'), ylabel('Count')

%% end