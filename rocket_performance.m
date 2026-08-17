clear;
clc;

%% Input values here, current R values in metric, can change.

Pc = 10e6;          % Chamber pressure [Pa]
Tc = 3500;          % Chamber temperature [K]
gamma = 1.2;        % Specific heat ratio
R = 355;            % Specific gas constant [J/(kg*K)]

At = 0.01;          % Throat area [m^2]
expansion_ratio = 20;
Ae = expansion_ratio * At;

Pa = 101325;        % Ambient pressure [Pa]
g0 = 9.80665;       % Standard gravity [m/s^2]


%% Characteristic velocity

cstar = sqrt(R*Tc/gamma) / ...
    (2/(gamma+1))^((gamma+1)/(2*(gamma-1)));


%% Mass flow rate

mdot = Pc * At / sqrt(Tc) * sqrt(gamma/R) * ...
    (2/(gamma+1))^((gamma+1)/(2*(gamma-1)));


%% Exit Mach number

area_ratio_function = @(M) ...
    (1/M) * ...
    ((2/(gamma+1)) * ...
    (1 + (gamma-1)/2 * M^2))^((gamma+1)/(2*(gamma-1))) ...
    - expansion_ratio;

Me = fzero(area_ratio_function, 3);


%% Exit temperature

Te = Tc / (1 + (gamma-1)/2 * Me^2);


%% Exit pressure

Pe = Pc * ...
    (1 + (gamma-1)/2 * Me^2)^(-gamma/(gamma-1));


%% Exit velocity

ae = sqrt(gamma * R * Te);
Ve = Me * ae;


%% Thrust

momentum_thrust = mdot * Ve;
pressure_thrust = (Pe - Pa) * Ae;

F = momentum_thrust + pressure_thrust;


%% Performance parameters

Isp = F / (mdot * g0);

Cf = F / (Pc * At);


%% Output

fprintf('\nRocket Engine Performance Breakdown\n');

fprintf('Characteristic velocity: %.2f m/s\n', cstar);
fprintf('Mass flow rate:          %.3f kg/s\n', mdot);
fprintf('Exit Mach number:        %.3f\n', Me);
fprintf('Exit temperature:        %.2f K\n', Te);
fprintf('Exit pressure:           %.2f kPa\n', Pe/1000);
fprintf('Exhaust velocity:        %.2f m/s\n', Ve);
fprintf('Momentum thrust:         %.2f N\n', momentum_thrust);
fprintf('Pressure thrust:         %.2f N\n', pressure_thrust);
fprintf('Total thrust:            %.2f N\n', F);
fprintf('Specific impulse:         %.2f s\n', Isp);
fprintf('Thrust coefficient:      %.4f\n', Cf);