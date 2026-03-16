%% Case study 2: Circuits as Resonators, Sensors, and Filters
% *ESE 105* 
%
% *Name: Derek Nester & Riley Panaligan*
%
% function mySensorCircuit(Vin,h) receives a time-series voltage sequence
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

function V_out = mySensorCircuit(Vin, h)
    % mySensorCircuit: Simulates an RLC bandpass filter to detect a 
    % specific frequency (84 Hz) from the Mars Ingenuity helicopter.
    % V_in: input voltage sound vector
    % h: sampling interval
    % V_out: output voltage (V_R) vector

    % 1. Define Target Frequency
    f_target = 84; % 84 Hz (Ingenuity rotor) 

    % 2. Choose L and C to set the resonant frequency
    % We're going to use the same formula to find f0 as in
    % myResonatorCircuit
    %  Formula: f0 = 1 / (2*pi*sqrt(L*C))
    % We fix C and solve for L: L = 1 / ( (2*pi*f0)^2 * C )
    C_base = 1.0e-6; % 1.0 uF (a good starting value)
    L_base = 1 / ( (2*pi*f_target)^2 * C_base );

    % 3. Choose R to set the bandwidth --- WE can mess around with this
    % value.
    % A smaller R makes a narrower filter while a a larger R makes a wider filter.
    % 100-200 is a good range.
    R_base = 150; % 150 Ohms 

    % 4. Build A and B matrices
    A = [1, h/C_base; -h/L_base, (1 - h*R_base/L_base)];
    B = [0; h/L_base];

    % 5. Set initial conditions (start from rest)
    x0 = [0; 0];

    % 6. Simulate the circuit using our existing function
    % The output V_out is the voltage across the resistor, V_R
    [~, V_out] = simRLC(Vin, x0, A, B, R_base);
end