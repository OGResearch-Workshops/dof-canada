%% Simulate permanent change in inflation target
%
% Simulate a permanent change in the inflation target, calculate the
% sacrifice ratio, and run a simple parameter sensitivity exercise using
% model objects with multiple parameterizations.
%

%% Clear workspace
%
% Clear workspace, close all graphics figures, clear command window, and
% check the IRIS version.

close all
clear
%#ok<*NASGU>
%#ok<*NOPTS>

 
%% Load solved model object
%
% Load the solved model object built in <read_model.html read_model>. Run
% `read_model` at least once before running this m-file.

load mat/createModel.mat m


%% Define dates

startDate = qq(2021,1);
endDate = startDate + 39;


%% Create model with higher steady state inflation
%
% Set the steady-state rate of inflation to 3 pct, and solve for the new
% steady state of nominal variables. Real variables remain unchanged, so
% they can be fixed here.

m1 = m;
m1.pi = 1.01^(1/4);
m1 = steady(m1, fixLevel=["A", "P"]);

checkSteady(m1, "equationSwitch", "steady");
chksstate(m1, "equationSwitch", "dynamic");
m1 = solve(m1)

ss = access(m, "steady-level");
ss1 = access(m1, "steady-level");
databank.merge("horzcat", ss, ss1)

table([m, m1], ["steadyLevel", "steadyChange", "form", "description"]);


%% Simulate disinflation
%
% Simulate the low-inflation model, `m`, starting from the steady state of
% the high-inflation model, `m1`.

d1 = steadydb(m1, startDate-3:endDate+100);
s = simulate(m, d1, startDate:endDate, "prependInput", true);
s = databank.minusControl(m, s, d1);

ch = databank.Chartpack();
ch.Range = startDate-5 : startDate+19;
ch.Transform = @(x) 100*(x-1);
ch.Round = 8;

ch < "Inflation, Q/Q PA // Pp Deviations: dP^4 ";
ch < "Policy rate, PA // Pp Deviations: R^4 ";
ch < "Output // Pct Level Deviations: Y ";
ch < "Hours Worked // Pct Level Deviations: N ";
ch < "Real Wage // Pct Level Deviations: W/P ";
ch < "Capital Price // Pct Level Deviations: Pk"; 

draw(ch, s);

visual.heading("Disinflation");


%% Sacrifice ratio
%
% Sacrifice ratio is the cumulative output loss after a 1% PA disinflation.
% Divide by 4 to get an annualised figure (reported in the literature).

sacRat = -cumsum(100*(s.Y-1))/4


%% Change price and wage stickiness and compare to baseline
%
% Create a model object with 8 parameterisations, and assign a range of
% values to the price stickiness parameter.

m = alter(m, 8);
m.xip = [60, 80, 100, 120, 140, 160, 180, 200];
m = solve(m)

s = simulate(m, d1, startDate:endDate, "prependInput", true);
s = databank.minusControl(m, s, d1);

draw(ch, s);
visual.heading("Disinflation with different degree of price stickiness")

disp("Cumulative output gap (sacrifice ratio):")
sacRat = -cumsum(100*(s.Y-1))/4

figure();
plot(sacRat);
grid("on");
title("Sacrifice ratio");
leg = {};
for i = 1 : countVariants(m)
    leg{end+1} = "\xi_p=" + string(m(i).xip);
end

legend(leg{:}, "location", "northWest");
sacRat{startDate:endDate}


