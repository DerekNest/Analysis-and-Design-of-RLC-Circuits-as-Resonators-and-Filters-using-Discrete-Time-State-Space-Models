%% Lab Case Study 2 Practice
% *ESE 105*
%
% *DUE on Sunday 10/26 11:59pm to Canvas
%
% 20 pts. total: 10 for programming and correct responses, 5 for
% programming style, 5 for presentation
%
% *Name: Derek Nester and Riley*
%
set(0, 'defaultFigureColor', 'w');    % Set figure background to white
set(0, 'defaultAxesColor', 'none');   % Set axes background to transparent
set(0, 'defaultAxesXColor', 'k');   % Set all axis lines/ticks to black
set(0, 'defaultAxesYColor', 'k');
set(0, 'defaultAxesZColor', 'k');
set(0, 'defaultTextColor', 'k');    % Set all text (labels, title) to black%%%

%% Instructions
% Run the |Lab CS2.m| script. Follow the instructions inside the "TODO: *****"
% labels below to complete each part: either write code or write your
% response to the question. For example:

% TODO: *************************************************************
% (Replace this comment with code)
% (Add response here)
% *******************************************************************

%%%
%
% *To turn in your assignment:*
%
% * Run the command |publish('Lab_CS2.m','pdf')| in the _Command Window_
% to generate a PDF of your solution |Lab CS2.pdf|. 
% * Submit _both_ the code (|.m| file) and the published output (|.pdf|
% file) to Canvas.
%
clear;
close all;  % uncomment this line if you do not want all figure windows to close when running this code


%% Part 1: Step Equations

%%%
% Implement Equations (8) and (10) in MATLAB to simulate circuit A (Figure
% 1) with R = 1 kΩ and C = 1 µF. Simulate charging the capacitor using a
% step input: set V_C = 0 V at t = 0 and V_in = 1 V for t > 0. Choose a
% suitable h to model the charging process accurately. Plot V_in and V_C
% vs. time to show the charging of the capacitor. You should observe a
% charging curve similar to the Figure 2 in CS2. 
%%%
% Set up simulation parameters:

% TODO: *************************************************************
R = 1e3;        % 1 kOhm
C = 1e-6;        % 1 uF
tau = R * C;     % RC time constant (1 ms)

% A good h should be much smaller than the time constant.
h_good = 0.1 * tau; % 1e-4 seconds (0.1 ms)

% We need to simulate long enough to see the charging.
% 5*tau is 99.3% charged. Let's simulate for 8*tau.
t_end = 8 * tau; % 8 ms
t_good = 0:h_good:t_end; % Time vector

% Set up step input
V_C0 = 0;       % Initial capacitor voltage
V_in_val = 1;   % 1 Volt step
V_in_good = V_in_val * ones(size(t_good)); % V_in = 1V for all t
% *******************************************************************

%%%
% Simulate with small h: 
% (please finish the function 'simRCvoltages' in the end and use it here.)

% TODO: *************************************************************
[V_C_good, V_R_good] = simRCvoltages(V_in_good, V_C0, R, C, h_good);
% *******************************************************************

%%%
% Plot the figure:

% TODO: *************************************************************
figure;
plot(t_good, V_in_good, 'b--', 'LineWidth', 2);
hold on;
plot(t_good, V_C_good, 'r-', 'LineWidth', 2);
hold off;
title('Part 1: RC Circuit Step Response (h = 0.1 ms)');
xlabel('Time (s)');
ylabel('Voltage (V)');
legend('V_{in}', 'V_C');
grid on;

set(gca, 'FontSize', 14)
exportgraphics(gcf, 'rc_step_response.png', 'BackgroundColor', 'white');


% The RC time constant indicates the time it takes for the capacitor to charge to approximately 63.2% of the input voltage. 
% It is a critical parameter in determining the speed of the circuit's response to changes in voltage.


%For the bad choice of h, the simulation becomes inherently unstable. WE
%can see this by its overshooting and then continued oscillations with
%a dampened amplitude for each successive iteration. Looking this up, we can see that the Euler method
%update of V_C[k+1] = V_C[k] + (h/tau) * (V_in[k] - V_C[k]) is only stable 
% for this problem when h/tau < 2. Our choice of h = 1.5*tau is stable
% (it converges to 1) but highly inaccurate and oscillatory. If we had
% chosen h = 2.1*tau, it would diverge to infinity.
% *******************************************************************


%% Part 2: Comparison between sampling intervals
% Now, run several versions of your simulation for various temporal sampling intervals h. As h gets
% larger or smaller, how does your simulation's prediction change? Why is this happening? Does
% the charging behavior of a "real" capacitor change as a function of your choice of h?
% Plot the predicted V_out using 
% 1) an "accurate" choice of h and 
% 2) an "inaccurate" choice of h and
% 3) the theoretical charging curve
% V_C(t) = 1 − exp(−t/RC) [Volts]. 
% Discuss what happens for the "inaccurate" choice of h.
% Note: Be careful to compare the three curves using correct time axes.

%%%
% Simulate with large h:

% TODO: *************************************************************
% As h gets larger, the simulation's prediction becomes less accurate,
% because the discrete-time approximation (V_C[k+1] - V_C[k])/h
% becomes a poorer model of the continuous derivative dV_C/dt. The error
% from this approximation accumulates at each step.
% The charging behavior of an actual capacitor is a physical process and
% doesnt change as a function of our choice of h. h determines the models
% accuracy here.

%As an example of a bad h
h_bad = 1.5 * tau; % 1.5 ms
t_bad = 0:h_bad:t_end; % Time vector for inaccurate h
V_in_bad = V_in_val * ones(size(t_bad)); % Step input for inaccurate h

[V_C_bad, ~] = simRCvoltages(V_in_bad, V_C0, R, C, h_bad);
% *******************************************************************

%%%
% Compare charging curves:

% TODO: *************************************************************
% Calculate the theoretical curve. We use t_good for a smooth line.
V_C_theo = V_in_val * (1 - exp(-t_good / tau));
figure;
plot(t_good, V_C_theo, 'k-', 'LineWidth', 2); % Theoretical curve
hold on;
plot(t_good, V_C_good, 'r--', 'LineWidth', 2); % Accurate simulation
plot(t_bad, V_C_bad, 'g:o', 'LineWidth', 2, 'MarkerSize', 4); % Inaccurate simulation
hold off;
title('Part 2: Comparison of Simulation Accuracy');
xlabel('Time (s)');
ylabel('V_C (V)');
legend('Theoretical', 'Accurate (h = 0.1\tau)', 'Inaccurate (h = 1.5\tau)');
grid on;
drawnow;
set(gca, 'FontSize', 14)
exportgraphics(gcf, 'rc_accuracy_comparison.png', 'BackgroundColor', 'white');
pause(1);


% *******************************************************************


%% Part 3: Explanation about the sampling intervals
% Relative to the charging curve of the capacitor V_C (t), how do you interpret the meaning of τ =RC,
% called the RC time constant of the circuit?

% TODO: *************************************************************
% (Replace this comment with code)
% The RC time constant describes how quickly the circuit respons to a
% change in input.

%AFter 5 times consant, the capactior is conisdered more or less fully
%charged, where it has reached 1 - exp(-5) = 99.3 % of its final voltage,
%close enough to 100% where we cna treat it as fully charged.
% *******************************************************************

