clc;
clear;
close all;

%% Load Results

load battery_identification_results.mat
load battery_hw_results.mat
load battery_nlarx_results.mat

%% Actual Voltage

actual = data_val.OutputData;

%% Plot Comparison
figure

plot(actual,...
    'k',...
    'LineWidth',1.5)

hold on

plot(y_oe.OutputData,...
    'LineWidth',1.2)

plot(y_hw.OutputData,...
    'LineWidth',1.2)

plot(y_nlarx.OutputData,...
    'LineWidth',1.2)

grid on

xlabel('Sample')
ylabel('Voltage (V)')

title('Comparison of Best Identification Models')

legend(...
sprintf('Actual'),...
sprintf('OE (%.2f%%)',fit_oe_val),...
sprintf('HW (%.2f%%)',fit_hw_val),...
sprintf('NLARX (%.2f%%)',fit_nlarx_val),...
'Location','best')

exportgraphics(gcf,...
'model_comparison.png',...
'Resolution',300);

%% Residual Error Distribution

err_oe    = actual - y_oe.OutputData;
err_hw    = actual - y_hw.OutputData;
err_nlarx = actual - y_nlarx.OutputData;

figure

histogram(err_oe,...
    50,...
    'Normalization','probability')

hold on

histogram(err_hw,...
    50,...
    'Normalization','probability')

histogram(err_nlarx,...
    50,...
    'Normalization','probability')

grid on

xlabel('Residual Error (V)')
ylabel('Probability')

title('Residual Error Distribution')

legend('OE',...
       'HW',...
       'NLARX',...
       'Location','best')

exportgraphics(gcf,...
'residual_distribution.png',...
'Resolution',300);

%% Residual Error Boxplot

err_oe    = actual - y_oe.OutputData;
err_hw    = actual - y_hw.OutputData;
err_nlarx = actual - y_nlarx.OutputData;

errors = [err_oe err_hw err_nlarx];

figure

boxplot(errors,...
    'Labels',{'OE','HW','NLARX'})

grid on

ylabel('Residual Error (V)')

title('Residual Error Comparison')

exportgraphics(gcf,...
'residual_boxplot.png',...
'Resolution',300);