%% Case study 2: Circuits as Resonators, Sensors, and Filters
% *ESE 105* 
%
% *Name: Derek Nester & Riley Panaligan*
%
% function myResonatorCircuit(Vin,h) receives a time-series voltage sequence
% sampled with interval h, and returns the output voltage sequence produced
% by a circuit
%
% inputs:
% Vin - time-series vector representing the voltage input to a circuit
% h - scalar representing the sampling interval of the time series in
% seconds
%
% outputs:
% Vout - time-series vector representing the output voltage of a circuit

function V_out = myResonatorCircuit(Vin, h)
    % myResonatorCircuit: Simulates an RLC "tuning fork" resonator.
    % V_in: input voltage sound vector
    % h: sampling interval
    % V_out: output voltage (V_R) vector

    % 1. Define Target Frequency
    % Standard Orchestra tuning note
    f_target = 440; % 440 Hz

    % 2. Choose L and C to set the resonant frequency
    % Formula: f0 = 1 / (2*pi*sqrt(L*C)) 
    % We fix C and solve for L: L = 1 / ( (2*pi*f0)^2 * C )
    C_base = 1.0e-6; % 1.0 uF 
    L_base = 1 / ( (2*pi*f_target)^2 * C_base );

    % 3. Choose R for long-duration ringing
    % To ring for a long time, we need a very small, but numerically stable R where R > h/C
    % We set R to be just 1% above this stability limit.
    R_limit = h / C_base;
    R_base = R_limit * 1.001; % Barely stable = rings for a long time

    % 4. Build A and B matrices using our derived equations
    A = [1, h/C_base; -h/L_base, (1 - h*R_base/L_base)];
    B = [0; h/L_base];

    % 5. Set initial conditions (start from rest)
    x0 = [0; 0];

    % 6. Simulate the circuit using our existing function
    % The output V_out is the voltage across the resistor, V_R
    [~, V_out] = simRLC(Vin, x0, A, B, R_base);
end