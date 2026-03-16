function plotPowerSpectrum(y, Fs, titleText, saveFilename)
    set(0, 'defaultFigureColor', 'w');    % Set figure background to white
    set(0, 'defaultAxesColor', 'none');   % Set axes background to transparent
    set(0, 'defaultAxesXColor', 'k');   % Set all axis lines/ticks to black
    set(0, 'defaultAxesYColor', 'k');
    set(0, 'defaultAxesZColor', 'k');
    set(0, 'defaultTextColor', 'k');    % Set all text (labels, title) to black%%%
    % Scale signal y to have values between -1.0 and 1.0, then plot its power
    % spectrum in a new figure window.
    %
    % y - time sequence
    % Fs - sampling rate for y (Hz)
    % titleText - The title for the plot
    % saveFilename - The filename to save the plot as (e.g., 'myplot.png')
    set(0, 'defaultFigureColor', 'w');

    [p,f] = periodogram(y/max(abs(y)),[],[],Fs);
    
    figure;
    semilogx(f,20*log10(abs(p)));
    xlim([20 20E3]);        % limit graph to normal human hearing range
    ylabel('Power/frequency (dB/Hz)')
    xlabel('Frequency (Hz)')
    
    % Use the provided title
    if nargin > 2 && ~isempty(titleText)
        title(titleText);
    else
        title('Power Spectrum');
    end
    grid on;

    % Save the figure if a filename is provided
    if nargin > 3 && ~isempty(saveFilename)
        set(gca, 'FontSize', 14)
        exportgraphics(gcf, saveFilename, 'BackgroundColor', 'white');
    end
end