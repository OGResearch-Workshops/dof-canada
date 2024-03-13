%% Simulate plain shocks
%
% Simulate a simple shock both as deviations from control and in full
% levels, and report the simulation results.
%


%% Clear workspace
%
% Clear workspace, close all graphics figures, clear command window, and
% check the IrisT version.
%

close all
clear


%% Load solved model object
%
% Load the solved model object built in <read_model.html read_model>. Run
% `read_model` at least once before running this m-file.
%

load mat/createModel.mat m


%% Define dates
%
% Define the start and end dates as plain numbered periods here.
%

startDate = 1;
endDate = 40;


%% Simulate consumption demand shock
%
% Simulate the shock as deviations from control (e.g. from the steady state
% or balanced-growth path). To this end, set the option `Deviation=true`.
% Both the input and output database are then interpreted as deviations
% from control:
%
% * the deviations for linearised variables are defined as 
% $x_t - x_t$: 
% hence, 0 means the variable is on its steady state.
% * the deviations for log-linearised variables are defined as 
% $x_t / \bar x_t$: 
% hence, 1 means the variable is on its steady state, or 1.05 means
% it is 5 % above it.
%
% The function `zerodb( )` finds the maximum lag in the model, and creates
% the input database accordingly so that it includes all necessary initial
% conditions.
%

d0 = databank.forModel(m, startDate:endDate);

d = d0;
d.Eb(startDate:startDate+5) = log(1.02);
[s0, info] = simulate( ...
    m, d, 1:40 ...
    , prependInput=true ...
);
[s, info] = simulate( ...
    m, d, 1:40 ...
    , prependInput=true ...
    , method="stacked" ...
);

smc0 = databank.minusControl(m, s0, d0);
smc = databank.minusControl(m, s, d0);


%% Report simulation results
%
% Use the `databank.Chartpack( )` object to create a quick report of simulation
% results.  Note how we use the `Transform` property to plot percent
% deviations of individual variables.
%

ch = databank.Chartpack();
ch.Range = startDate-1 : startDate+19;
ch.Transform = @(x) 100*(x-1);
ch.Round = 8;

ch + "Inflation, Q/Q PA // Pp Deviations: dP^4 ";
ch + "Policy rate, PA // Pp Deviations: R^4 ";
ch + "Unc policy rate, PA // Pp Deviations: uncR^4 ";
ch + "Con policy rate, PA // Pp Deviations: conR^4 ";
ch + "Output // Pct Level Deviations: Y ";
ch + "Hours Worked // Pct Level Deviations: N ";
ch + "Real Wage // Pct Level Deviations: W/P ";
ch + "Capital Price // Pct Level Deviations: Pk"; 

draw(ch, databank.merge("horzcat", smc0, smc));
visual.heading("Consumption Demand Shock -- Deviations from Control");


