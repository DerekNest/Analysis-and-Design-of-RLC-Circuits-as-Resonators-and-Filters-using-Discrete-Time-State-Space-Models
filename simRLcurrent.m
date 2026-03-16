function [i_L, V_L] = simRLcurrent(V_in, i_0, R, L, h)
    % Get the number of time steps
    n = length(V_in);
    
    % Pre-allocate output vectors
    i_L = zeros(1, n);
    V_L = zeros(1, n);
    
    % Set initial condition
    i_L(1) = i_0;
    
    % --- Apply discrete-time equations ---
    % Eq (20): i[k+1] = (1 - h*R/L)*i[k] + (h/L)*V_in[k]
    % Eq (18): V_L[k] = V_in[k] - V_R[k]
    % Eq (7):  V_R[k] = i[k] * R
    % Combined: V_L[k] = V_in[k] - i[k]*R
    
    % Calculate first point for V_L
    V_L(1) = V_in(1) - i_L(1) * R;
    
    % Loop through time steps
    for k = 1:(n-1)
        % Calculate i_L at the *next* step (k+1) using Eq (20)
        i_L(k+1) = (1 - h*R/L) * i_L(k) + (h/L) * V_in(k);
        
        % Calculate V_L at the *next* step (k+1) using the combined
        % equations (18) and (7)
        V_L(k+1) = V_in(k+1) - i_L(k+1) * R;
    end
end
% *******************************************************************