%% Case study 2: Circuits as Resonators, Sensors, and Filters
% *ESE 105* 
%
% *Name:  Derek Nester & Riley Panaligan*
%
% function myFilterCircuit(Vin,h) receives a time-series voltage sequence
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

function V_out = myFilterCircuit(Vin, h)
    % myFilterCircuit: Simulates an RLC bandpass filter to remove
    % 60 Hz hum and high-frequency hiss from a music file.
    % V_in: input voltage sound vector
    % h: sampling interval
    % V_out: output voltage (V_R) vector

    % 1. Define Target Passband (based on handel.mat spectrum)
    f_low = 200;  % Low end of music
    f_high = 2000; % High end of music
    
    % 2. Calculate Center Frequency (f0)
    % We use the geometric mean for the center frequency.
    f_target = sqrt(f_low * f_high); % about 775 Hz

    % 3. Choose L and C to set the center frequency
    % Formula: f0 = 1 / (2*pi*sqrt(L*C))
    % We fix C and solve for L:  L = 1 / ( (2*pi*f0)^2 * C )
    C_base = 0.1e-6; % 0.1 uF (a good standard value)
    L_base = 1 / ( (2*pi*f_target)^2 * C_base );

    % 4. Choose R to set the bandwidth
    % Bandwidth (delta_f) = f_high - f_low = 2800 Hz
    % Formula: delta_f = R / (2*pi*L)
    % We solve for R: R = delta_f * 2*pi*L
    delta_f = f_high - f_low;
    R_base = delta_f * 2*pi * L_base; % This will be a large R
    
    % 5. Build A and B matrices
    A = [1, h/C_base; -h/L_base, (1 - h*R_base/L_base)];
    B = [0; h/L_base];


    x0 = [0; 0];
    % 7. Simulate the circuit using our existing function
    % The output V_out is the voltage across the resistor, V_R
    [~, V_out] = simRLC(Vin, x0, A, B, R_base);
end