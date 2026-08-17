%% trade_altitude.m
% Rocket Engine Performance vs. Altitude
%
% Calculates rocket engine performance from sea level to 100 km
% using a piecewise standard atmosphere model.
%
% Uses:
%   rocket_performance.m
%   standard_atmosphere.m


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


%% Altitude Range

altitude = linspace(0, 100e3, 200);    % 0-100 km [m]


%% Preallocate Arrays

temperature = zeros(size(altitude));
ambient_pressure = zeros(size(altitude));
density = zeros(size(altitude));

thrust = zeros(size(altitude));
Isp = zeros(size(altitude));
exit_pressure = zeros(size(altitude));
exhaust_velocity = zeros(size(altitude));


%% Calculate Performance at Each Altitude

for i = 1:length(altitude)

    h = altitude(i);


    % Atmospheric conditions

    [temperature(i), ambient_pressure(i), density(i)] = ...
        standard_atmosphere(h);


    % Rocket performance

    performance = rocket_performance( ...
        Pc, Tc, gamma, R, At, expansion_ratio, ...
        ambient_pressure(i));


    % Store performance results

    thrust(i) = performance.F;

    Isp(i) = performance.Isp;

    exit_pressure(i) = performance.Pe;

    exhaust_velocity(i) = performance.Ve;

end


%% Plot 1: Atmospheric Pressure vs. Altitude

figure;

plot(altitude / 1000, ambient_pressure / 1000, ...
    'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Ambient Pressure [kPa]');
title('Atmospheric Pressure vs. Altitude');

grid on;


%% Plot 2: Atmospheric Temperature vs. Altitude

figure;

plot(altitude / 1000, temperature, ...
    'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Temperature [K]');
title('Atmospheric Temperature vs. Altitude');

grid on;


%% Plot 3: Atmospheric Density vs. Altitude

figure;

plot(altitude / 1000, density, ...
    'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Density [kg/m^3]');
title('Atmospheric Density vs. Altitude');

grid on;


%% Plot 4: Thrust vs. Altitude

figure;

plot(altitude / 1000, thrust / 1000, ...
    'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Thrust [kN]');
title('Rocket Engine Thrust vs. Altitude');

grid on;


%% Plot 5: Specific Impulse vs. Altitude

figure;

plot(altitude / 1000, Isp, ...
    'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Specific Impulse [s]');
title('Rocket Engine Specific Impulse vs. Altitude');

grid on;


%% Plot 6: Exit Pressure vs. Ambient Pressure

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


%% Plot 7: Exhaust Velocity vs. Altitude

figure;

plot(altitude / 1000, exhaust_velocity, ...
    'LineWidth', 2);

xlabel('Altitude [km]');
ylabel('Exhaust Velocity [m/s]');
title('Exhaust Velocity vs. Altitude');

grid on;
