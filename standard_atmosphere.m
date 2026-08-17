function [T, P, rho] = standard_atmosphere(h)
% STANDARD_ATMOSPHERE
% Calculates atmospheric temperature, pressure, and density
% using the U.S. Standard Atmosphere 1976 model from 0-100 km.
%
% Input:
%   h       Geometric altitude [m]
%
% Outputs:
%   T       Atmospheric temperature [K]
%   P       Atmospheric pressure [Pa]
%   rho     Atmospheric density [kg/m^3]
%
% Valid altitude range:
%   0 <= h <= 100 km


%% Constants

g0 = 9.80665;           % Standard gravitational acceleration [m/s^2]
R = 287.05287;          % Specific gas constant for air [J/(kg*K)]


%% Atmospheric Layers
%
% Base altitude [m]
% Base temperature [K]
% Temperature lapse rate [K/m]

h_base = [ ...
     0
    11e3
    20e3
    32e3
    47e3
    51e3
    71e3
    86e3
];

T_base = [ ...
    288.15
    216.65
    216.65
    228.65
    270.65
    270.65
    214.65
    186.946
];

L = [ ...
   -0.0065
    0
    0.001
    0.0028
    0
   -0.0028
   -0.002
];


%% Sea-Level Conditions

P0 = 101325;            % Sea-level pressure [Pa]


%% Check Altitude

if h < 0 || h > 100e3
    error('Altitude must be between 0 and 100 km.');
end


%% Determine Atmospheric Layer

layer = find(h >= h_base, 1, 'last');

% Prevent indexing beyond available lapse-rate data
if layer > length(L)
    layer = length(L);
end


%% Calculate Temperature and Pressure

hb = h_base(layer);
Tb = T_base(layer);
Lb = L(layer);


if Lb == 0

    % Isothermal layer

    T = Tb;

    P = P0;  % Temporary value; replaced below

else

    % Gradient layer

    T = Tb + Lb * (h - hb);

    P = P0;  % Temporary value; replaced below

end


%% Calculate Base Pressure for Selected Layer

P_base = 101325;

for i = 1:(layer - 1)

    h1 = h_base(i);
    h2 = h_base(i + 1);

    T1 = T_base(i);
    L1 = L(i);

    if L1 == 0

        P_base = P_base * ...
            exp(-g0 * (h2 - h1) / (R * T1));

    else

        T2 = T1 + L1 * (h2 - h1);

        P_base = P_base * ...
            (T2 / T1)^(-g0 / (R * L1));

    end

end


%% Pressure Within Current Layer

if Lb == 0

    P = P_base * ...
        exp(-g0 * (h - hb) / (R * Tb));

else

    P = P_base * ...
        (T / Tb)^(-g0 / (R * Lb));

end


%% Density

rho = P / (R * T);

end