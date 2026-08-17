%% trade_altitude.m
% Rocket Engine Performance vs. Altitude
%
% Calculates rocket engine performance as ambient pressure changes
% with altitude.
%
% Uses:
%   rocket_performance.m

clear;
clc;
close all;


%% Engine Parameters

Pc = 10e6;              % Chamber pressure [Pa]
Tc = 3500;              % Chamber temperature [K]
gamma = 1.2;            % Specific heat ratio [-]
R = 355;                % Exhaust gas specific gas constant [J/(kg*K)]

At = 0.01;              % Throat area [m^2]
expansion_ratio = 20;   % Nozzle expansion ratio [-]


%% Constants

g0 = 9.80665;            % Standard gravity [m/s^2]

R_air = 287.05;          % Air specific gas constant [J/(kg*K)]

T0 = 288.15;             % Sea-level temperature [K]
P0 = 101325;             % Sea-level pressure [Pa]

L = 0.0065;              % Temperature lapse rate [K/m]


%% Altitude Range

altitude = linspace(0, 11000, 100);   % 0-11 km [m]


%% Atmospheric Pressure

temperature_at_altitude = T0 - L .* altitude;

ambient_pressure = P0 .* ...
    (temperature_at_altitude ./ T0) .^ ...
    (g0 / (R_air * L));


%% Preallocate Performance Arrays

thrust = zeros(size(altitude));
Isp = zeros(size(altitude));
exit_pressure = zeros(size(altitude));
exhaust_velocity = zeros(size(altitude));


%% Run Propulsion Model

for i = 1:length(altitude)

    Pa = ambient_pressure(i);

    performance = rocket_performance( ...
        Pc, Tc, gamma, R, At, expansion_ratio, Pa);

    thrust(i) = performance.F;
    Isp(i) = performance.Isp;
    exit_pressure(i) = performance.Pe;
    exhaust_velocity(i) = performance.Ve;

end


%% Plot 1: Ambient Pressure vs. Altitude

figure;

plot(altitude / 1000, ambient_pressure / 1000, ...
    'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Ambient Pressure [kPa]');
title('Atmospheric Pressure vs. Altitude');

grid on;


%% Plot 2: Thrust vs. Altitude

figure;

plot(altitude / 1000, thrust / 1000, ...
    'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Thrust [kN]');
title('Rocket Engine Thrust vs. Altitude');

grid on;


%% Plot 3: Specific Impulse vs. Altitude

figure;

plot(altitude / 1000, Isp, ...
    'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Specific Impulse [s]');
title('Specific Impulse vs. Altitude');

grid on;


%% Plot 4: Exit Pressure vs. Altitude

figure;

plot(altitude / 1000, exit_pressure / 1000, ...
    'LineWidth', 2);

hold on;

plot(altitude / 1000, ambient_pressure / 1000, ...
    '--', 'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Pressure [kPa]');
title('Exit Pressure vs. Ambient Pressure');

legend('Exit Pressure', 'Ambient Pressure', ...
    'Location', 'best');

grid on;

hold off;


%% Plot 5: Exhaust Velocity vs. Altitude

figure;

plot(altitude / 1000, exhaust_velocity, ...
    'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Exhaust Velocity [m/s]');
title('Exhaust Velocity vs. Altitude');

grid on;