function [V_C, V_R] = simRCvoltages(V_in, V_C0, R, C, h)
    % Get the number of time steps from the input vector
    n = length(V_in);
    
    % initially set output vectors for efficiency
    V_C = zeros(1, n);
    V_R = zeros(1, n);
    

    V_C(1) = V_C0;
    

    tau = R * C;
    
    % Eq (8): V_R[k] = V_in[k] - V_C[k]
    % Eq (10): V_C[k+1] = V_C[k] + (h/tau) * (V_in[k] - V_C[k])
    
    %first point
    V_R(1) = V_in(1) - V_C(1);
    
    % Loop through all time steps to calculate the next state
    for k = 1:(n-1)

        %Calculate V_C at the next time using equation 10 by using the
        %vlaues of the current time step k.
        V_C(k+1) = V_C(k) + (h / tau) * (V_in(k) - V_C(k));
        
       %Calculate V_r using the next time step with equation 8
        % This uses the V_in and newly-calculated V_C 
        V_R(k+1) = V_in(k+1) - V_C(k+1);
    end
end
% *******************************************************************