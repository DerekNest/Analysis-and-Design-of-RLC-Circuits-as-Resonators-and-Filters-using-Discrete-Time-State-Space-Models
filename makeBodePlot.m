% makeBodePlot.m
%
% This script generates a "Bode" magnitude plot for the RLC filter.
% It tests the filter's gain across a wide range of frequencies
% to visually prove how it works.
%
%clear;
%close all;
%clc;
set(0, 'defaultFigureColor', 'w');    % Set figure background to white
set(0, 'defaultAxesColor', 'none');   % Set axes background to transparent
set(0, 'defaultAxesXColor', 'k');   % Set all axis lines/ticks to black
set(0, 'defaultAxesYColor', 'k');
set(0, 'defaultAxesZColor', 'k');
set(0, 'defaultTextColor', 'k');    % Set all text (labels, title) to black%%%

fprintf('--- Generating Bode Plot for Music Filter ---\n');

%% --- 1. Set Up Simulation Parameters ---
h = 1 / (192 * 1000); % The h value specified in the case study 
Fs = 1/h;

% Define the range of frequencies to test
% We test from 10 Hz to 20,000 Hz (logarithmically spaced)
f_test = logspace(1, 4.3, 200); % 10^1=10 Hz, 10^4.3=~20kHz
Gain = zeros(size(f_test)); % Pre-allocate vector to store gain

% How long to simulate each sine wave (in seconds)
sim_duration = 0.5; % 0.5 seconds is long enough for the filter to settle
t = 0:h:sim_duration;

%% --- 2. Run the Simulation Loop ---
% Loop through every frequency, run it through the filter,
% and measure the output amplitude.
fprintf('Simulating %d frequencies...\n', length(f_test));

for i = 1:length(f_test)
    % Get current test frequency
    f = f_test(i);
    
    % Create the input sine wave
    % (Amplitude is 1, so output amplitude = gain)
    V_in_sine = sin(2 * pi * f * t);
    
    % Run the music filter
    V_out = myFilterCircuit(V_in_sine, h);
    
    % Measure the "steady state" amplitude
    % We ignore the first part of the signal to let the
    % filter's ephemeral response die out.
    
    % Look at the last 20% of the signal
    num_samples_to_check = round(length(V_out) * 0.20);
    steady_state_output = V_out(end - num_samples_to_check : end);
    
    % Store the max amplitude (this is the gain)
    Gain(i) = max(abs(steady_state_output));
    
    % print progress
    if mod(i, 20) == 0
        fprintf('...Completed %d/%d (f=%.0f Hz)\n', i, length(f_test), f);
    end
end

fprintf('Simulation complete. Plotting results...\n');

%% --- 3. Plot the Results ---
% Convert the linear gain to decibels (dB)
Gain_dB = 20 * log10(Gain);

figure;
% Plot Frequency (log scale) vs. Gain (dB)
semilogx(f_test, Gain_dB, 'LineWidth', 2);
hold on;

% Red dashed line for the 60 Hz hum we want to cut
xline(60, 'r--', 'LineWidth', 1.5);
% Black dashed lines for our passband (200 Hz and 2000 Hz)
xline(200, 'k--', 'LineWidth', 1.5);
xline(2000, 'k--', 'LineWidth', 1.5);

hold off;
grid on;
title('Frequency Response (Bode Plot) of Music Filter');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
legend('Filter Response', '60 Hz Hum', 'Passband Edge (200Hz)', 'Passband Edge (2000Hz)', 'Location', 'southwest');
axis([10 20000 -60 5]); % Set plot limits (10Hz to 20kHz, -60dB to 5dB)

set(gca, 'FontSize', 14)

exportgraphics(gcf, 'bode_plot.png', 'BackgroundColor', 'white');


