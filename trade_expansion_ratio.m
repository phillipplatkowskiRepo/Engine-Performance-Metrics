%% trade_expansion_ratio.m
% Rocket Engine Nozzle Expansion Ratio Trade Study
%
% Varies nozzle expansion ratio while holding chamber conditions,
% throat area, and ambient pressure constant.
%
% Uses:
%   rocket_performance.m
%
% Outputs:
%   - Thrust
%   - Specific impulse
%   - Exit Mach number
%   - Exit pressure
%   - Exit temperature
%   - Exhaust velocity
%   - Thrust coefficient


clear;
clc;
close all;


%% Fixed Engine Parameters

Pc = 10e6;              % Chamber pressure [Pa]
Tc = 3500;              % Chamber temperature [K]
gamma = 1.2;            % Specific heat ratio [-]
R = 355;                % Specific gas constant [J/(kg*K)]

At = 0.01;              % Throat area [m^2]

Pa = 101325;            % Ambient pressure [Pa]


%% Expansion Ratio Sweep

expansion_ratio_range = linspace(5, 50, 100);


%% Preallocate Output Arrays

mdot = zeros(size(expansion_ratio_range));
cstar = zeros(size(expansion_ratio_range));
Me = zeros(size(expansion_ratio_range));
Te = zeros(size(expansion_ratio_range));
Pe = zeros(size(expansion_ratio_range));
Ve = zeros(size(expansion_ratio_range));
F = zeros(size(expansion_ratio_range));
Isp = zeros(size(expansion_ratio_range));
Cf = zeros(size(expansion_ratio_range));
Ae = zeros(size(expansion_ratio_range));


%% Run Propulsion Model

for i = 1:length(expansion_ratio_range)

    expansion_ratio = expansion_ratio_range(i);

    performance = rocket_performance( ...
        Pc, Tc, gamma, R, At, expansion_ratio, Pa);


    % Store outputs

    mdot(i) = performance.mdot;
    cstar(i) = performance.cstar;
    Me(i) = performance.Me;
    Te(i) = performance.Te;
    Pe(i) = performance.Pe;
    Ve(i) = performance.Ve;
    F(i) = performance.F;
    Isp(i) = performance.Isp;
    Cf(i) = performance.Cf;
    Ae(i) = performance.Ae;

end


%% Find Maximum Thrust

[max_thrust, max_thrust_index] = max(F);

optimal_expansion_thrust = ...
    expansion_ratio_range(max_thrust_index);


%% Find Maximum Specific Impulse

[max_Isp, max_Isp_index] = max(Isp);

optimal_expansion_Isp = ...
    expansion_ratio_range(max_Isp_index);


%% Display Results

fprintf('\n');
fprintf('====================================================\n');
fprintf('       NOZZLE EXPANSION RATIO TRADE STUDY          \n');
fprintf('====================================================\n');

fprintf('\nFixed Parameters:\n');
fprintf('Chamber Pressure:           %.2f MPa\n', Pc / 1e6);
fprintf('Chamber Temperature:        %.1f K\n', Tc);
fprintf('Specific Heat Ratio:        %.3f\n', gamma);
fprintf('Specific Gas Constant:      %.1f J/(kg*K)\n', R);
fprintf('Throat Area:                %.4f m^2\n', At);
fprintf('Ambient Pressure:           %.1f kPa\n', Pa / 1000);

fprintf('\nExpansion Ratio Range:\n');
fprintf('Minimum:                    %.1f\n', ...
    min(expansion_ratio_range));

fprintf('Maximum:                    %.1f\n', ...
    max(expansion_ratio_range));


fprintf('\nMaximum Thrust:\n');
fprintf('Expansion Ratio:            %.2f\n', ...
    optimal_expansion_thrust);

fprintf('Thrust:                     %.2f kN\n', ...
    max_thrust / 1000);


fprintf('\nMaximum Specific Impulse:\n');
fprintf('Expansion Ratio:            %.2f\n', ...
    optimal_expansion_Isp);

fprintf('Specific Impulse:           %.2f s\n', ...
    max_Isp);


fprintf('\n====================================================\n');


%% Plot 1: Thrust vs Expansion Ratio

figure;

plot(expansion_ratio_range, F / 1000, 'LineWidth', 2);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Thrust [kN]');
title('Thrust vs. Nozzle Expansion Ratio');

grid on;


%% Plot 2: Specific Impulse vs Expansion Ratio

figure;

plot(expansion_ratio_range, Isp, 'LineWidth', 2);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Specific Impulse [s]');
title('Specific Impulse vs. Nozzle Expansion Ratio');

grid on;


%% Plot 3: Exit Mach Number vs Expansion Ratio

figure;

plot(expansion_ratio_range, Me, 'LineWidth', 2);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Exit Mach Number [-]');
title('Exit Mach Number vs. Nozzle Expansion Ratio');

grid on;


%% Plot 4: Exit Pressure vs Expansion Ratio

figure;

plot(expansion_ratio_range, Pe / 1000, 'LineWidth', 2);
hold on;

yline(Pa / 1000, '--');

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Exit Pressure [kPa]');
title('Exit Pressure vs. Nozzle Expansion Ratio');

legend('Exit Pressure', 'Ambient Pressure', ...
    'Location', 'best');

grid on;

hold off;


%% Plot 5: Exhaust Velocity vs Expansion Ratio

figure;

plot(expansion_ratio_range, Ve, 'LineWidth', 2);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Exhaust Velocity [m/s]');
title('Exhaust Velocity vs. Nozzle Expansion Ratio');

grid on;


%% Plot 6: Thrust Coefficient vs Expansion Ratio

figure;

plot(expansion_ratio_range, Cf, 'LineWidth', 2);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Thrust Coefficient [-]');
title('Thrust Coefficient vs. Nozzle Expansion Ratio');

grid on;


%% Plot 7: Exit Area vs Expansion Ratio

figure;

plot(expansion_ratio_range, Ae, 'LineWidth', 2);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Exit Area [m^2]');
title('Exit Area vs. Nozzle Expansion Ratio');

grid on;