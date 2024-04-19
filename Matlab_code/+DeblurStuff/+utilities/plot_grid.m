% Grid search Implementation %
function plot_grid(array_x, matrix_y_l1, matrix_y_l2, filename)
%   We perform grid search keeping one parameter fixed
%   z
%   Input Parameters:
%       array_x      : X indices
%       matrix_y     : cells of Y values
%   
%   No output, only saves the plot


    % Create figure for subplots
    figure;
    
    % Subplot for L1 errors
    subplot(1, 2, 1); % 1 row, 2 columns, first plot
    hold on; % Hold on to add multiple lines to the plot
    for j = 1:length(matrix_y_l1)
        % Generate a line for each combination of rho and t
        if (min(matrix_y_l1{j})<6) && (max(matrix_y_l1{j})<100)  % only consider parameters that have feasible errors since it is quite sensitive
            plot(array_x, matrix_y_l1{j}, '-o', 'DisplayName', sprintf('rho=%.2f', array_x(j)));
        end
    end
    hold off;
    title('L1 Errors across t Values');
    xlabel('Step Size');
    ylabel('Error');
    legend('show'); % Show legend to identify lines
    grid on; % Add grid
    
    % Subplot for L2 errors
    subplot(1, 2, 2); % 1 row, 2 columns, second plot
    hold on; % Hold on to add multiple lines to the plot
    for j = 1:length(matrix_y_l2)
        % Generate a line for each combination of rho and t
        if (min(matrix_y_l2{j})<6) && (max(matrix_y_l2{j})<100) % only consider parameters that have feasible errors since it is quite sensitive
            plot(array_x, matrix_y_l2{j}, '-*', 'DisplayName', sprintf('rho=%.2f', array_x(j)));
        end
    end
    hold off;
    title('L2 Errors across t Values');
    xlabel('Step Size');
    ylabel('Error');
    legend('show'); % Show legend to identify lines
    grid on; % Add grid
    
    % Save plot to the results folder
    saveas(gcf, sprintf('+DeblurStuff/+results/%s.png', filename));
end