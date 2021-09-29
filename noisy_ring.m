%% Nonlinear Model Fitting
% Fit a circle to a noisy ring
%% Create a ring and Fit a Circle
N = 100;

% Circle parameters
th = linspace(0,2*pi,N); % theta (angles)
r  = 3; % radius

% Cartesian coordinates from polar coords.
x = r*cos(th) + randn(1,N)/8;
y = r*sin(th) + randn(1,N)/8;

% Plot the ring
figure(1)
plot(x,y,'s')
axis square

% Initialize radius and setup function min
initParms = 6;
funch = @(initParms) fitCirc(initParms,[x; y]);

% Fit the model using fminsearch
figure(1)
[outparams1,sse1,exitflag1,fmininfo] = fminsearch(funch,initParms);

% Fit the model using lsqnonlin
[outparams2,~,sse2,exitflag2,lsinfo] = lsqnonlin(funch,initParms);

%%  Compare Computation Time and SSE Tests
% Number of repetitions
nreps = 100;

% Initialize time and SSE
[sses,comptime] = deal( zeros(2,nreps) );

% Create a loop for comparing
for repi=1:nreps   
    % Start timer and run fminsearch
    tic
    [outparams1,sse1,exitflag1,fmininfo] = fminsearch(funch,initParms);
    
    % Stop timer and collect data
    comptime(1,repi) = toc;
    sses(1,repi) = sse1;
    
    % Same for lsqnonlin
    tic
    [outparams2,~,sse2,exitflag2,lsinfo] = lsqnonlin(funch,initParms);

    comptime(2,repi) = toc;
    sses(2,repi) = sse2;
end

% Plot the computation times
figure(2)
subplot(121)
plot(repmat([1;2],1,nreps),comptime*1000,'o','markersize',16,'markerfacecolor','k')
set(gca,'xlim',[0 3],'xtick',1:2,'xticklabel',{'fminsearch';'lsqnonlin'})
ylabel('Computation times (ms)')

% Plot the SSEs
subplot(122)
plot(repmat([1;2],1,nreps),sses,'o','markersize',16,'markerfacecolor','k')
set(gca,'xlim',[0 3],'xtick',1:2,'xticklabel',{'fminsearch';'lsqnonlin'})
ylabel('Sum of squared errors')

%% Visualization of Fitting
rs = [1 4];
rotang = [pi/2 pi/11];

x = rs(1)*cos(th+rotang(1)) + randn(1,N)/8;
y = rs(2)*sin(th+rotang(2)) + randn(1,N)/8;

figure(3)
plot(x,y,'o')
axis square

initParms = [ 2 2 pi pi ];
funch = @(initParms) fitOval(initParms,[x; y]);

[outparams1,sse1,exitflag1,fmininfo] = fminsearch(funch,initParms);

%% end