%% trade_chamber_pressure.m
% Rocket Engine Chamber Pressure Trade Study
%
% Varies chamber pressure while holding all other engine parameters
% constant and evaluates the effect on rocket engine performance.
%
% Uses:
%   rocket_performance.m
%
% Outputs:
%   - Mass flow rate
%   - Characteristic velocity
%   - Exit Mach number
%   - Exit temperature
%   - Exit pressure
%   - Exhaust velocity
%   - Thrust
%   - Specific impulse
%   - Thrust coefficient

clear;
clc;
close all;


%% Fixed Engine Parameters

Tc = 3500;              % Chamber temperature [K]
gamma = 1.2;            % Specific heat ratio [-]
R = 355;                % Specific gas constant [J/(kg*K)]

At = 0.01;              % Throat area [m^2]
expansion_ratio = 20;   % Nozzle expansion ratio [-]

Pa = 101325;            % Ambient pressure [Pa]


%% Chamber Pressure Sweep

Pc_range = linspace(1e6, 20e6, 100);    % 1-20 MPa


%% Preallocate Output Arrays

mdot = zeros(size(Pc_range));
cstar = zeros(size(Pc_range));
Me = zeros(size(Pc_range));
Te = zeros(size(Pc_range));
Pe = zeros(size(Pc_range));
Ve = zeros(size(Pc_range));
F = zeros(size(Pc_range));
Isp = zeros(size(Pc_range));
Cf = zeros(size(Pc_range));


%% Run Propulsion Model

for i = 1:length(Pc_range)

    Pc = Pc_range(i);

    performance = rocket_performance( ...
        Pc, Tc, gamma, R, At, expansion_ratio, Pa);


    % Store outputs from propulsion model

    mdot(i) = performance.mdot;
    cstar(i) = performance.cstar;
    Me(i) = performance.Me;
    Te(i) = performance.Te;
    Pe(i) = performance.Pe;
    Ve(i) = performance.Ve;
    F(i) = performance.F;
    Isp(i) = performance.Isp;
    Cf(i) = performance.Cf;

end


%% Find Baseline Case

% Find the point closest to 10 MPa
[~, baseline_index] = min(abs(Pc_range - 10e6));


%% Display Baseline Results

fprintf('\n');
fprintf('====================================================\n');
fprintf('       ROCKET ENGINE PERFORMANCE TRADE STUDY       \n');
fprintf('====================================================\n');

fprintf('\nTrade Study:\n');
fprintf('Chamber Pressure: 1 - 20 MPa\n');

fprintf('\nFixed Parameters:\n');
fprintf('Chamber Temperature:       %.1f K\n', Tc);
fprintf('Specific Heat Ratio:       %.3f\n', gamma);
fprintf('Specific Gas Constant:     %.1f J/(kg*K)\n', R);
fprintf('Throat Area:               %.4f m^2\n', At);
fprintf('Expansion Ratio:           %.1f\n', expansion_ratio);
fprintf('Ambient Pressure:          %.1f kPa\n', Pa / 1000);

fprintf('\nBaseline Case:\n');
fprintf('Chamber Pressure:           %.2f MPa\n', ...
    Pc_range(baseline_index) / 1e6);

fprintf('Mass Flow Rate:              %.3f kg/s\n', ...
    mdot(baseline_index));

fprintf('Characteristic Velocity:     %.2f m/s\n', ...
    cstar(baseline_index));

fprintf('Exit Mach Number:             %.3f\n', ...
    Me(baseline_index));

fprintf('Exit Temperature:             %.2f K\n', ...
    Te(baseline_index));

fprintf('Exit Pressure:                %.2f kPa\n', ...
    Pe(baseline_index) / 1000);

fprintf('Exhaust Velocity:              %.2f m/s\n', ...
    Ve(baseline_index));

fprintf('Thrust:                        %.2f kN\n', ...
    F(baseline_index) / 1000);

fprintf('Specific Impulse:              %.2f s\n', ...
    Isp(baseline_index));

fprintf('Thrust Coefficient:            %.4f\n', ...
    Cf(baseline_index));

fprintf('\n====================================================\n');


%% Plot 1: Thrust vs Chamber Pressure

figure;

plot(Pc_range / 1e6, F / 1000, 'LineWidth', 2);

xlabel('Chamber Pressure [MPa]');
ylabel('Thrust [kN]');
title('Thrust vs. Chamber Pressure');

grid on;


%% Plot 2: Specific Impulse vs Chamber Pressure

figure;

plot(Pc_range / 1e6, Isp, 'LineWidth', 2);

xlabel('Chamber Pressure [MPa]');
ylabel('Specific Impulse [s]');
title('Specific Impulse vs. Chamber Pressure');

grid on;


%% Plot 3: Mass Flow Rate vs Chamber Pressure

figure;

plot(Pc_range / 1e6, mdot, 'LineWidth', 2);

xlabel('Chamber Pressure [MPa]');
ylabel('Mass Flow Rate [kg/s]');
title('Mass Flow Rate vs. Chamber Pressure');

grid on;


%% Plot 4: Characteristic Velocity vs Chamber Pressure

figure;

plot(Pc_range / 1e6, cstar, 'LineWidth', 2);

xlabel('Chamber Pressure [MPa]');
ylabel('Characteristic Velocity [m/s]');
title('Characteristic Velocity vs. Chamber Pressure');

grid on;


%% Plot 5: Thrust Coefficient vs Chamber Pressure

figure;

plot(Pc_range / 1e6, Cf, 'LineWidth', 2);

xlabel('Chamber Pressure [MPa]');
ylabel('Thrust Coefficient [-]');
title('Thrust Coefficient vs. Chamber Pressure');

grid on;


%% Plot 6: Exit Pressure vs Chamber Pressure

figure;

plot(Pc_range / 1e6, Pe / 1000, 'LineWidth', 2);
hold on;

yline(Pa / 1000, '--');

xlabel('Chamber Pressure [MPa]');
ylabel('Exit Pressure [kPa]');
title('Exit Pressure vs. Chamber Pressure');

legend('Exit Pressure', 'Ambient Pressure', ...
    'Location', 'best');

grid on;

hold off;