%% Cleaning Multivariate Time Series
% Effects of averaging on covariance matrices
%% Create signals
% Parameters
N       = 1000; % time points
M       =   20; % channels (sensors)
nTrials = 50; % trials
time       = linspace(0,6*pi,N);

% Initialize datasets
[data1,data2] = deal(zeros(M,N,nTrials));

% Nonlinear relationship across channels
chanrel = sin(linspace(0,2*pi,M))';

% Create dataset per trial
for trial=1:nTrials
    % simulation 1 (phase-locked)
    data1(:,:,trial) = bsxfun(@times,repmat(sin(time),M,1),chanrel) + randn(M,N);
    
    % simulation 2 (non-phase-locked)
    data2(:,:,trial) = bsxfun(@times,repmat(sin(time+rand*2*pi),M,1),chanrel) + randn(M,N);
end

%% Compute Covariance Matrices
% Method 1: trial average
tmpdatA = mean(data1,3);
covA1  = tmpdatA*tmpdatA' / (N-1);

tmpdatA = mean(data2,3);
covA2  = tmpdatA*tmpdatA' / (N-1);

% Method 2: trial vectorized
tmpdatB = reshape(data1,[M N*nTrials]);
covB1  = tmpdatB*tmpdatB' / (N*nTrials -1);

tmpdatB = reshape(data2,[M N*nTrials]);
covB2  = tmpdatB*tmpdatB' / (N*nTrials -1);

% Method 3: trial-unique
[covC1,covC2] = deal( zeros(M) );

for trial=1:nTrials
    tmpdatC = data1(:,:,trial);
    covC1  = covC1 + tmpdatC*tmpdatC' / (N-1);

    tmpdatC = data2(:,:,trial);
    covC2  = covC2 + tmpdatC*tmpdatC' / (N-1);
end

% Divide by N for average
covC1 = covC1/nTrials;
covC2 = covC2/nTrials;

%% Visualize Covariance Matrices
figure(1)

covmethod = 'ABC';
covnames  = { 'Trial average';'Concatenated';'Trial unique' };

for cov=1:length(covnames)
    for datai=1:2
        subplot(2,3,cov+(datai-1)*3)
        eval([ 'imagesc(cov' covmethod(cov) num2str(datai) ')' ])
        axis square
        set(gca,'clim',[-1 1]*.5,'xtick',[],'ytick',[])
        title({ covnames{cov} ['Data ' num2str(datai) ]})
    end
end

%% end