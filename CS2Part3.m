%% Part 3: Putting it all together in an RLC circuit
h = 1 / (192 * 1000); 
Fs = 1/h;
set(0, 'defaultFigureColor', 'w');    % Set figure background to white
set(0, 'defaultAxesColor', 'none');   % Set axes background to transparent
set(0, 'defaultAxesXColor', 'k');   % Set all axis lines/ticks to black
set(0, 'defaultAxesYColor', 'k');
set(0, 'defaultAxesZColor', 'k');
set(0, 'defaultTextColor', 'k');    % Set all text (labels, title) to black%%%
% Task 3.1: Derive mathematical expressions for the matrix A and vector B
% TODO: *************************************************************
% 1. Find v_C,k+1 (Voltage across Capacitor):
% v_C,k+1 = v_C,k + (h/C) * i_k
% This is equivalent to the following:
% v_C,k+1 = (1)*v_C,k + (h/C)*i_k + (0)*v_in,k
%
% 2. Find i_k+1 (Current in Inductor):
% v_in,k - v_L,k - v_C,k - v_R,k = 0 
%
% We need v_L,k. from (14): v_L,k = L * (i_k+1 - i_k) / h 
% Additonally, v_R,k = i_k * R 
%
% Substitute these into the KVL equation:
% v_in,k - (L * (i_k+1 - i_k) / h) - v_C,k - (i_k * R) = 0
%
% Now, solve for i_k+1:
% L * (i_k+1 - i_k) / h = v_in,k - v_C,k - i_k * R
% i_k+1 - i_k = (h/L) * (v_in,k - v_C,k - i_k * R)
% i_k+1 = i_k + (h/L)*v_in,k - (h/L)*v_C,k - (h*R/L)*i_k
%
% Group the terms by their corresponding state variables 
% i_k+1 = (-h/L)*v_C,k + (1 - h*R/L)*i_k + (h/L)*v_in,k
%
% 3. Assemble the Matrices A and B:
% x_k+1 = [v_C,k+1; i_k+1] = A * [v_C,k; i_k] + B * [v_in,k]
%
% A = [ 1      (h/C)     ]
%     [ (-h/L) (1-h*R/L) ]
%
% B = [   0 ]
%     [ (h/L) ]
%
% *******************************************************************

%%%
%% Task 3.2: Fun with oscillations (Step Response)
% Simulate the response to a step input for different R, L, C values
% to reproduce the behaviors in Figure 6.
%
% TODO: *************************************************************
% Set up simulation parameters
t_sim_end = 0.015; % (15 ms)
t_sim = 0:h:t_sim_end;
n_sim = length(t_sim);
% Step input: v_in = 1V for t > 0
V_in_step = ones(1, n_sim);
V_in_step(1) = 0; % Start at 0
% Initial state: x0 = [v_C(0); i(0)] = [0; 0]
x0 = [0; 0];
% --- Define component values for the three cases ---
% We use L and C to set the frequency, and R to set the damping.
L_base = 10e-3;  % 10 mH
C_base = 0.1e-6; % 0.1 uF
% for quick decay, we need high resistance.
R_quick = 1000; % 1 kOhm

%Rule for stablity is R > h/C
% FOr ringing or to be underdamped R < 2*sqrt(L/c)
% We need R > 52.1 for stability, but R < 632.5 for ringing.
% Let's choose R=300.
R_slow = 55; % 300 Ohms (Stable and underdamped)


% Unstable oscillations happen when R is very small (or zero), which makes the
% discrete-time model unstable, even if the real circuit isn't.
R_unstable = 0.5; % 0.5 Ohms (Very low, < 52.1, so unstable)
% --- Build A and B matrices ---
A_quick = [1, h/C_base; -h/L_base, (1 - h*R_quick/L_base)];
B_quick = [0; h/L_base];
A_slow = [1, h/C_base; -h/L_base, (1 - h*R_slow/L_base)];
B_slow = [0; h/L_base];
A_unstable = [1, h/C_base; -h/L_base, (1 - h*R_unstable/L_base)];
B_unstable = [0; h/L_base];
% --- Simulate all three cases ---
[~, V_out_quick] = simRLC(V_in_step, x0, A_quick, B_quick, R_quick);
[~, V_out_slow] = simRLC(V_in_step, x0, A_slow, B_slow, R_slow);
[~, V_out_unstable] = simRLC(V_in_step, x0, A_unstable, B_unstable, R_unstable);
% --- Plot the results (v_out = v_R) ---
figure(4);
clf; % Clear the figure just in case

% Create the top subplot for the stable signals
subplot(2, 1, 1);
plot(t_sim, V_out_quick, 'r-', 'LineWidth', 1.5);
hold on;
plot(t_sim, V_out_slow, 'y-', 'LineWidth', 1.5);
plot(t_sim, V_in_step, 'b--', 'LineWidth', 1.5);
hold off;
title('Task 3.2: Stable RLC Step Response');
ylabel('Voltage (V)');
legend('Quick Decay (R=1k\Omega)', 'Slow Decay (R=55\Omega)', 'V_{in}');
grid on;
axis([0 t_sim_end -0.4 1.2]); % Force the axis to be readable
set(gca, 'FontSize', 14)

% Create the bottom subplot for the unstable signal
subplot(2, 1, 2);
plot(t_sim, V_out_unstable, 'm-', 'LineWidth', 1.5); % Purple/Magenta
hold on;
plot(t_sim, V_in_step, 'b--', 'LineWidth', 1.5);
hold off;
title('Unstable Response');
xlabel('Time (s)');
ylabel('Voltage (V)');
legend('Unstable (R=0.5\Omega)', 'V_{in}');
grid on;

set(gca, 'FontSize', 14)
exportgraphics(gcf, 'step_response_plots.png', 'BackgroundColor', 'white');


% We don't set the axis here, so we can see it blow up
% --- Listen to the responses ---
% NOTE: 15ms is too short to hear as a tone.
% We will re-run the simulation for 2 seconds *just* for the audio.
fprintf('Setting up 2-second simulation for audio...\n');
t_sound_end = 2.0; % Simulate for 2 seconds
t_sound = 0:h:t_sound_end;
n_sound = length(t_sound);
V_in_sound_step = ones(1, n_sound);
V_in_sound_step(1) = 0; % Start at 0

% Re-simulate with the long time vector
[~, V_out_quick_sound] = simRLC(V_in_sound_step, x0, A_quick, B_quick, R_quick);
[~, V_out_slow_sound] = simRLC(V_in_sound_step, x0, A_slow, B_slow, R_slow);
[~, V_out_unstable_sound] = simRLC(V_in_sound_step, x0, A_unstable, B_unstable, R_unstable);

fprintf('Playing quick decay (overdamped)...\n');
soundsc(V_out_quick_sound, Fs);
pause(3); % Pause for 3 seconds
fprintf('Playing slow decay (ringing)...\n');
soundsc(V_out_slow_sound, Fs);
pause(3);
fprintf('Playing unstable (growing)...\n');
soundsc(V_out_unstable_sound, Fs);
pause(3);
% Discussion of sounds: 
% The quicker decay (overdamped) sounds like a dull 'click' or 'thud'. 
% This matches the plot, which shows a single spike that decays with 
% no oscillation.
%
% The slow decay (underdamped) sounds like a high-pitched 'ping' or 'ring' 
% that fades away. This corresponds to the oscillating signal
% in the plot. The high pitch is from the high natural frequency.
%
% The unstable sound is just a 'pop' or 'click' followed by silence. 
% This is because the simulation values immediately blow up to Inf,
% and soundsc cannot play this invalid data (as confirmed by the
% Inf/NaN warnings in the console).
% *******************************************************************

%%%
% Task 3.3: Sinusoidal response
% Explore sending sinusoidal voltages at various frequencies
%
% TODO: *************************************************************
R_33 = 100;
L_33 = 100e-3;
C_33 = 0.1e-6;

% Build A and B matrices
A_33 = [1, h/C_33; -h/L_33, (1 - h*R_33/L_33)];
B_33 = [0; h/L_33];

% Calculate the resonant frequency
f0 = 1 / (2*pi*sqrt(L_33 * C_33));
fprintf('Resonant frequency is approx. %.1f Hz\n', f0);

% 1. Low frequency (f << f0)
% 2. Resonant frequency (f ≈ f0)
% 3. High frequency (f >> f0)
f_low = 100;  % 100 Hz
f_res = f0;   % ~1591.5 Hz
f_high = 10000; % 10 kHz

% Generate time vector and sine waves
t_sine = 0:h:0.1; % 100 ms simulation
V_in_low = sin(2 * pi * f_low * t_sine);
V_in_res = sin(2 * pi * f_res * t_sine);
V_in_high = sin(2 * pi * f_high * t_sine);

% Simulate all three cases
[~, V_out_low] = simRLC(V_in_low, x0, A_33, B_33, R_33);
[~, V_out_res] = simRLC(V_in_res, x0, A_33, B_33, R_33);
[~, V_out_high] = simRLC(V_in_high, x0, A_33, B_33, R_33);

% --- Plot the responses ---
% Smaller time window so we can see the discrete waves
plot_window = (t_sine >= 0.05 & t_sine <= 0.06); % 10ms window

figure(5);
subplot(3,1,1);
plot(t_sine(plot_window), V_in_low(plot_window), 'b--');
hold on;
plot(t_sine(plot_window), V_out_low(plot_window), 'r-');
hold off;
title('Low Frequency (100 Hz)');
legend('V_{in}', 'V_{out} (V_R)');
ylabel('Voltage (V)');
set(gca, 'FontSize', 14)

subplot(3,1,2);
plot(t_sine(plot_window), V_in_res(plot_window), 'b--');
hold on;
plot(t_sine(plot_window), V_out_res(plot_window), 'r-');
hold off;
title('Resonant Frequency (~1591 Hz)');
legend('V_{in}', 'V_{out} (V_R)');
ylabel('Voltage (V)');
set(gca, 'FontSize', 14)

subplot(3,1,3);
plot(t_sine(plot_window), V_in_high(plot_window), 'b--');
hold on;
plot(t_sine(plot_window), V_out_high(plot_window), 'r-');
hold off;
title('High Frequency (10 kHz)');
legend('V_{in}', 'V_{out} (V_R)');
xlabel('Time (s)');
ylabel('Voltage (V)');

set(gca, 'FontSize', 14)
exportgraphics(gcf, 'sinusoidal_response.png', 'BackgroundColor', 'white');

% Discussion:
% The output signals all look like sinusoids but their amplitudes are way
% different.
%
% At low (100 Hz) and high (10 kHz) frequencies, the output
% amplitude V_R is much smaller than the input.
%
% At the resonant frequency, the output amplitude is about the same as the
% input amplitude.
%
% This circuit passes frequencies near its resonant frequency
% and rejects frequencies that are low or high.
% Therefore, this is considered a BANDPASS filter
%
% Listening to the sounds:
% Small amplitudes (low/high f) sound very quiet.
% Large amplitude (resonant f) sounds loud.
% Small, medium, and large frequencies sound like low,
% medium, and high-pitched notes.
% *******************************************************************