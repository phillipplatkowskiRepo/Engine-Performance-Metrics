%% trade_altitude_expansion.m
% Rocket Engine Performance Map
%
% Calculates rocket engine performance as a function of:
%   1. Nozzle expansion ratio
%   2. Altitude
%
% Uses:
%   rocket_performance.m
%   standard_atmosphere.m
%
% X-axis:
%   Nozzle expansion ratio
%
% Y-axis:
%   Altitude
%
% Z-axis:
%   Performance metric

clear;
clc;
close all;


%% Fixed Engine Parameters

Pc = 10e6;              % Chamber pressure [Pa]
Tc = 3500;              % Chamber temperature [K]
gamma = 1.2;            % Specific heat ratio [-]
R = 355;                % Exhaust gas specific gas constant [J/(kg*K)]

At = 0.01;              % Throat area [m^2]


%% Parameter Ranges

% Expanded range to determine whether the optimum is actually
% within the previous 5-50 range.

expansion_ratios = linspace(5, 200, 200);

altitudes = linspace(0, 100e3, 100);


%% Create Parameter Grid

[EXPANSION, ALTITUDE] = meshgrid( ...
    expansion_ratios, ...
    altitudes);


%% Preallocate Atmospheric Arrays

ambient_pressure = zeros(size(ALTITUDE));
temperature = zeros(size(ALTITUDE));
density = zeros(size(ALTITUDE));


%% Preallocate Performance Arrays

mdot = zeros(size(ALTITUDE));
cstar = zeros(size(ALTITUDE));
Me = zeros(size(ALTITUDE));
Te = zeros(size(ALTITUDE));
Pe = zeros(size(ALTITUDE));
Ve = zeros(size(ALTITUDE));
thrust = zeros(size(ALTITUDE));
Isp = zeros(size(ALTITUDE));
Cf = zeros(size(ALTITUDE));
Ae = zeros(size(ALTITUDE));


%% Calculate Atmospheric Conditions

for i = 1:length(altitudes)

    h = altitudes(i);

    [T, P, rho] = standard_atmosphere(h);

    temperature(i,:) = T;
    ambient_pressure(i,:) = P;
    density(i,:) = rho;

end


%% Run Propulsion Model Across Parameter Grid

for i = 1:length(altitudes)

    for j = 1:length(expansion_ratios)

        Pa = ambient_pressure(i,j);

        expansion_ratio = EXPANSION(i,j);

        performance = rocket_performance( ...
            Pc, Tc, gamma, R, At, expansion_ratio, Pa);


        % Store results

        mdot(i,j) = performance.mdot;
        cstar(i,j) = performance.cstar;
        Me(i,j) = performance.Me;
        Te(i,j) = performance.Te;
        Pe(i,j) = performance.Pe;
        Ve(i,j) = performance.Ve;
        thrust(i,j) = performance.F;
        Isp(i,j) = performance.Isp;
        Cf(i,j) = performance.Cf;
        Ae(i,j) = performance.Ae;

    end

end


%% Convert Units for Plotting

altitude_km = ALTITUDE / 1000;

thrust_kN = thrust / 1000;

Pe_kPa = Pe / 1000;

ambient_pressure_kPa = ambient_pressure / 1000;


%% Plot 1: Thrust

figure;

surf(EXPANSION, altitude_km, thrust_kN);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Altitude [km]');
zlabel('Thrust [kN]');

title('Thrust vs. Expansion Ratio and Altitude');

colorbar;
grid on;


%% Plot 2: Specific Impulse

figure;

surf(EXPANSION, altitude_km, Isp);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Altitude [km]');
zlabel('Specific Impulse [s]');

title('Specific Impulse vs. Expansion Ratio and Altitude');

colorbar;
grid on;


%% Plot 3: Exit Mach Number

figure;

surf(EXPANSION, altitude_km, Me);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Altitude [km]');
zlabel('Exit Mach Number [-]');

title('Exit Mach Number vs. Expansion Ratio and Altitude');

colorbar;
grid on;


%% Plot 4: Exit Pressure

figure;

surf(EXPANSION, altitude_km, Pe_kPa);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Altitude [km]');
zlabel('Exit Pressure [kPa]');

title('Exit Pressure vs. Expansion Ratio and Altitude');

colorbar;
grid on;


%% Plot 5: Exhaust Velocity

figure;

surf(EXPANSION, altitude_km, Ve);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Altitude [km]');
zlabel('Exhaust Velocity [m/s]');

title('Exhaust Velocity vs. Expansion Ratio and Altitude');

colorbar;
grid on;


%% Plot 6: Thrust Coefficient

figure;

surf(EXPANSION, altitude_km, Cf);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Altitude [km]');
zlabel('Thrust Coefficient [-]');

title('Thrust Coefficient vs. Expansion Ratio and Altitude');

colorbar;
grid on;


%% Plot 7: Exit Area

figure;

surf(EXPANSION, altitude_km, Ae);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Altitude [km]');
zlabel('Exit Area [m^2]');

title('Exit Area vs. Expansion Ratio and Altitude');

colorbar;
grid on;


%% Plot 8: Exit-to-Ambient Pressure Ratio

pressure_ratio = Pe ./ ambient_pressure;

figure;

surf(EXPANSION, altitude_km, pressure_ratio);

xlabel('Nozzle Expansion Ratio, A_e/A_t [-]');
ylabel('Altitude [km]');
zlabel('P_e/P_a [-]');

title('Exit-to-Ambient Pressure Ratio');

colorbar;
grid on;


%% Find Optimal Expansion Ratio at Each Altitude

optimal_expansion_thrust = zeros(size(altitudes));
maximum_thrust = zeros(size(altitudes));

optimal_expansion_Isp = zeros(size(altitudes));
maximum_Isp = zeros(size(altitudes));


for i = 1:length(altitudes)

    % Maximum thrust

    [maximum_thrust(i), thrust_index] = ...
        max(thrust(i,:));

    optimal_expansion_thrust(i) = ...
        expansion_ratios(thrust_index);


    % Maximum specific impulse

    [maximum_Isp(i), Isp_index] = ...
        max(Isp(i,:));

    optimal_expansion_Isp(i) = ...
        expansion_ratios(Isp_index);

end


%% Check Whether Optimum Is at Search Boundary

thrust_at_upper_boundary = ...
    optimal_expansion_thrust >= max(expansion_ratios);

Isp_at_upper_boundary = ...
    optimal_expansion_Isp >= max(expansion_ratios);


%% Display Optimization Results

fprintf('\n');
fprintf('============================================================\n');
fprintf('       OPTIMAL EXPANSION RATIO ANALYSIS                    \n');
fprintf('============================================================\n');

fprintf('\nExpansion Ratio Search Range:\n');
fprintf('Minimum: %.1f\n', min(expansion_ratios));
fprintf('Maximum: %.1f\n', max(expansion_ratios));


fprintf('\nSelected Altitudes:\n\n');

selected_altitudes = [0 10 20 40 60 80 100];

for k = 1:length(selected_altitudes)

    [~, altitude_index] = ...
        min(abs(altitudes/1000 - selected_altitudes(k)));

    fprintf('Altitude: %6.1f km\n', ...
        altitudes(altitude_index)/1000);

    fprintf('  Maximum-thrust expansion ratio: %.2f\n', ...
        optimal_expansion_thrust(altitude_index));

    fprintf('  Maximum Isp expansion ratio:    %.2f\n', ...
        optimal_expansion_Isp(altitude_index));

    fprintf('  Maximum thrust:                 %.2f kN\n', ...
        maximum_thrust(altitude_index)/1000);

    fprintf('  Maximum Isp:                    %.2f s\n', ...
        maximum_Isp(altitude_index));

    fprintf('\n');

end


%% Boundary Warning

if any(thrust_at_upper_boundary)

    fprintf('WARNING:\n');
    fprintf(['At one or more altitudes, maximum thrust occurred ' ...
             'at the upper expansion-ratio boundary.\n']);

    fprintf(['The true optimum may therefore be greater than ' ...
             '%.1f.\n'], max(expansion_ratios));

end


if any(Isp_at_upper_boundary)

    fprintf('WARNING:\n');
    fprintf(['At one or more altitudes, maximum Isp occurred ' ...
             'at the upper expansion-ratio boundary.\n']);

    fprintf(['The true optimum may therefore be greater than ' ...
             '%.1f.\n'], max(expansion_ratios));

end


fprintf('============================================================\n');


%% Plot 9: Optimal Expansion Ratio for Maximum Thrust

figure;

plot(altitudes / 1000, ...
     optimal_expansion_thrust, ...
     'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Optimal Expansion Ratio, A_e/A_t [-]');

title('Expansion Ratio Producing Maximum Thrust');

grid on;


%% Plot 10: Optimal Expansion Ratio for Maximum Specific Impulse

figure;

plot(altitudes / 1000, ...
     optimal_expansion_Isp, ...
     'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Optimal Expansion Ratio, A_e/A_t [-]');

title('Expansion Ratio Producing Maximum Specific Impulse');

grid on;


%% Plot 11: Compare Optimal Expansion Ratios

figure;

plot(altitudes / 1000, ...
     optimal_expansion_thrust, ...
     'LineWidth', 2);

hold on;

plot(altitudes / 1000, ...
     optimal_expansion_Isp, ...
     '--', ...
     'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Optimal Expansion Ratio, A_e/A_t [-]');

title('Optimal Expansion Ratio vs. Altitude');

legend('Maximum Thrust', ...
       'Maximum I_{sp}', ...
       'Location', 'best');

grid on;

hold off;