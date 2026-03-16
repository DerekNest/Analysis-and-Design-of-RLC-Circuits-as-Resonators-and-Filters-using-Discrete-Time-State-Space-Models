%% Part 2: Model an RL circuit
%%%
% Implement Equation (20) in MATLAB to simulate circuit B (Figure 3) with 
% R = 100 Ω and L = 100 mH. Simulate charging the inductor using a step 
% input: set i = 0 A at t = 0 and vin = 1 V for t > 0. Choose a suitable h.
% Plot the voltage across the inductor vL vs. time.
%%%

set(0, 'defaultFigureColor', 'w');    % Set figure background to white
set(0, 'defaultAxesColor', 'none');   % Set axes background to transparent
set(0, 'defaultAxesXColor', 'k');   % Set all axis lines/ticks to black
set(0, 'defaultAxesYColor', 'k');
set(0, 'defaultAxesZColor', 'k');
set(0, 'defaultTextColor', 'k');    % Set all text (labels, title) to black%%%

% Set up simulation parameters:
% TODO: *************************************************************
R_L = 100;      % 100 Ohms
L = 100e-3;     % 100 mH
tau_L = L / R_L;  % RL time constant (1 ms)

h_L_good = 0.1 * tau_L; % (0.1 ms)

% Simulate for 8*tau to see the full effect
t_L_end = 8 * tau_L; % 8 ms
t_L_good = 0:h_L_good:t_L_end; % Time vector

% Set up step input
i_L0 = 0;

% Same varaibles from part 1
V_C0 = 0;       
V_in_val = 1;   
V_in_good = V_in_val * ones(size(t_L_good));

V_in_L_good = V_in_val * ones(size(t_L_good)); % V_in = 1V for all t
% *******************************************************************

%%%
% TODO: *************************************************************
[i_L_good, V_L_good] = simRLcurrent(V_in_L_good, i_L0, R_L, L, h_L_good);
% *******************************************************************

%%%
% Plot the figure:
% TODO: *************************************************************
figure(3);
plot(t_L_good, V_in_L_good, 'b--', 'LineWidth', 2);
hold on;
plot(t_L_good, V_L_good, 'r-', 'LineWidth', 2);
hold off;
title('Part 2: RL Circuit Step Response (h = 0.1 ms)');
xlabel('Time (s)');
ylabel('Voltage (V)');
legend('V_{in}', 'V_L');
grid on;
set(gca, 'FontSize', 14)
exportgraphics(gcf, 'rl_step_response.png', 'BackgroundColor', 'white');
% *******************************************************************

%%%
% Task 2.2: Capacitors and inductors exhibit complementary characteristics.
% Use your MATLAB simulations to demonstrate this.
% What is the steady-state voltage across the capacitor after it is
% fully-charged? How about that of the inductor?
% Similarly, what is the steady-state current through the capacitor after 
% it is fully-charged? How about that of the inductor?
% TODO: *************************************************************
% We can find the steady-state (SS) values by looking at the *last* % element in our simulation vectors.

% 1. Steady-State Voltages:
V_C_ss = V_C_good(end); % From Part 1
V_L_ss = V_L_good(end); % From Part 2

fprintf('Steady-state V_C: %.2f V\n', V_C_ss);
fprintf('Steady-state V_L: %.2f V\n', V_L_ss);

% 2. Steady-State Currents:
% For the RC circuit, the current is i_C = V_R / R
% V_R_good was calculated in Part 1.
i_C_ss = V_R_good(end) / R; 
i_L_ss = i_L_good(end); % From Part 2

fprintf('Steady-state i_C: %.2f A\n', i_C_ss);
fprintf('Steady-state i_L: %.2f A\n', i_L_ss);

% Discussion:
% The simulation data demonstrates the opposite behavior as part 1.
%
% Capacitor: In steady state, V_C = 1 V and i_C = 0 A.
% The capacitor voltage matches the source, so V_R = V_in - V_C = 0.
% With 0 V across the resistor, no current flows.
% The fully-charged capacitor acts merely acts as an open circuit.
%
% Inductor: In steady state, V_L = 0 V and i_L = .01 A.
% The inductor voltage goes to zero. This means the full source
% voltage is across the resistor (V_R = V_in - V_L = 1V).
% The current is limited only by the resistor: i_L = V_R / R_L = 1V / 100Ω = 0.01 A.
% The (approximately) fully charged inductor acts like a wire or a short circuit.
% *******************************************************************