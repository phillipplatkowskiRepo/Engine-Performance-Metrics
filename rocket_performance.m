function performance = rocket_performance(Pc, Tc, gamma, R, At, expansion_ratio, Pa)
% ROCKET_PERFORMANCE
% Calculates ideal rocket nozzle performance.
%
% Inputs:
%   Pc               Chamber pressure [Pa]
%   Tc               Chamber temperature [K]
%   gamma            Specific heat ratio [-]
%   R                Specific gas constant [J/(kg*K)]
%   At               Throat area [m^2]
%   expansion_ratio  Nozzle expansion ratio Ae/At [-]
%   Pa               Ambient pressure [Pa]
%
% Output:
%   performance      Structure containing calculated performance values


%% Constants

g0 = 9.80665;       % Standard gravitational acceleration [m/s^2]


%% Geometry

Ae = expansion_ratio * At;


%% Characteristic Velocity

cstar = sqrt(R * Tc / gamma) / ...
    (2 / (gamma + 1))^((gamma + 1) / (2 * (gamma - 1)));


%% Mass Flow Rate

mdot = Pc * At / sqrt(Tc) * sqrt(gamma / R) * ...
    (2 / (gamma + 1))^((gamma + 1) / (2 * (gamma - 1)));


%% Exit Mach Number

area_ratio_function = @(M) ...
    (1 / M) * ...
    ((2 / (gamma + 1)) * ...
    (1 + (gamma - 1) / 2 * M^2))^...
    ((gamma + 1) / (2 * (gamma - 1))) ...
    - expansion_ratio;

Me = fzero(area_ratio_function, 3);


%% Exit Temperature

Te = Tc / ...
    (1 + (gamma - 1) / 2 * Me^2);


%% Exit Pressure

Pe = Pc * ...
    (1 + (gamma - 1) / 2 * Me^2)^...
    (-gamma / (gamma - 1));


%% Exit Velocity

ae = sqrt(gamma * R * Te);

Ve = Me * ae;


%% Thrust

momentum_thrust = mdot * Ve;

pressure_thrust = (Pe - Pa) * Ae;

F = momentum_thrust + pressure_thrust;


%% Specific Impulse

Isp = F / (mdot * g0);


%% Thrust Coefficient

Cf = F / (Pc * At);


%% Store Results

performance.cstar = cstar;
performance.mdot = mdot;
performance.Me = Me;
performance.Te = Te;
performance.Pe = Pe;
performance.Ve = Ve;
performance.momentum_thrust = momentum_thrust;
performance.pressure_thrust = pressure_thrust;
performance.F = F;
performance.Isp = Isp;
performance.Cf = Cf;
performance.Ae = Ae;

end