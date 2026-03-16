% This function simulates the RLC circuit using the state-space model.
% x_hist = history of the state vector [v_C; i]
% V_out = history of the output voltage (V_R = i * R)
function [x_hist, V_out] = simRLC(V_in, x0, A, B, R)
    % Get the number of time steps
    n = length(V_in);
    
    % Pre-allocate output vectors
    % x_hist has 2 rows (v_C and i) and n columns (time steps)
    x_hist = zeros(2, n);
    V_out = zeros(1, n);
    
    % Set initial conditions
    x_hist(:, 1) = x0;
    V_out(1) = x0(2) * R; % V_R[0] = i[0] * R
    
    % Loop through time steps
    for k = 1:(n-1)
        % Get current state and input
        x_k = x_hist(:, k);
        u_k = V_in(k);
        
        x_k_plus_1 = A * x_k + B * u_k;
        
        % Store next state
        x_hist(:, k+1) = x_k_plus_1;
        
        % Calculate output V_R[k+1] = i[k+1] * R
        % i[k+1] is the 2nd element of the new state vector
        V_out(k+1) = x_k_plus_1(2) * R;
    end
end