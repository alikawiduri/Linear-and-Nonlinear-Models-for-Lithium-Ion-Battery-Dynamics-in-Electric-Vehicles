clc;
clear;
close all;

rng(123);

%% Battery Parameters

Ts = 1;

R1 = 0.015;
C1 = 3000;

R2 = 0.008;
C2 = 10000;

Q = 2.5*3600;      % 2.5 Ah

%% EV Driving Cycle Inspired Current Profile

N = 7000;

u = zeros(N,1);

k = 1;

while k < N

    mode = randi(5);

    duration = randi([20 200]);

    idx = k:min(k+duration-1,N);

    switch mode

        case 1      % Idle
            current = 0 + 0.2*randn;

        case 2      % Acceleration
            current = 2 + 2*rand;

        case 3      % Cruise
            current = 0.5 + rand;

        case 4      % Regenerative Braking
            current = -1 - 2*rand;

        case 5      % Hard Acceleration
            current = 3 + rand;

    end

    u(idx) = current;

    k = idx(end)+1;

end

u = u + 0.1*randn(size(u));

u(u > 5) = 5;
u(u < -4) = -4;

figure;
stairs(u);
grid on;
xlabel('Sample');
ylabel('Current (A)');
title('EV Inspired Current Profile');

%% SOC Model

SOC = zeros(N,1);

SOC(1) = 0.9;

for k = 2:N

    SOC(k) = SOC(k-1) - (u(k-1)*Ts)/Q;

    SOC(k) = min(max(SOC(k),0),1);

end

%% OCV-SOC Relationship

SOC_table = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];

OCV_table = [3.0 3.2 3.35 3.45 3.55 ...
             3.65 3.75 3.85 4.0 4.1 4.2];

Voc = interp1(SOC_table,...
              OCV_table,...
              SOC,...
              'pchip');

%% Temperature Model

Temp = zeros(N,1);

Temp(1) = 25;

for k = 2:N

    Temp(k) = Temp(k-1) ...
            + 0.0003*u(k)^2 ...
            - 0.00005*(Temp(k-1)-25);

end

%% SOC & Temperature Dependent Resistance
R0_var = (0.03 + 0.02*(1-SOC)) ...
       .* (1 + 0.01*(25-Temp));

%% 2RC ECM Simulation

Vrc1 = zeros(N,1);
Vrc2 = zeros(N,1);

for k = 2:N

    dVrc1 = -(1/(R1*C1))*Vrc1(k-1) ...
            + (1/C1)*u(k-1);

    dVrc2 = -(1/(R2*C2))*Vrc2(k-1) ...
            + (1/C2)*u(k-1);

    Vrc1(k) = Vrc1(k-1) + Ts*dVrc1;
    Vrc2(k) = Vrc2(k-1) + Ts*dVrc2;

end

%% Terminal Voltage

Vt = Voc ...
    - R0_var.*u ...
    - Vrc1 ...
    - Vrc2;

%% Measurement Noise

noise = 0.005*randn(N,1);

sensor_bias = 0.003;

Vt_noisy = Vt + noise + sensor_bias;

%% Visualization

figure;

subplot(3,1,1)
plot(SOC)
grid on
ylabel('SOC')

subplot(3,1,2)
stairs(u)
grid on
ylabel('Current (A)')

subplot(3,1,3)
plot(Vt_noisy)
grid on
ylabel('Voltage (V)')
xlabel('Sample')

%% IDENTIFICATION DATA

data = iddata(Vt_noisy,[u SOC Temp],Ts);

%% TRAIN VALIDATION SPLIT

data_est = data(1:2:end);
data_val = data(2:2:end);

bestFit = -inf;
bestOrder = 0;


%% HAMMERSTEIN-WIENER

orders_hw = [10 10 10 ...
             10 10 10 ...
             1 1 1];

InputNL  = idSigmoidNetwork;
OutputNL = idSigmoidNetwork;

sys_hw = nlhw(...
    data_est,...
    orders_hw,...
    InputNL,...
    OutputNL);

%% VALIDATION
figure
compare(data_val,sys_hw)
grid on
title('Hammerstein-Wiener Validation')

[~,fit_hw_train] = compare(data_est,sys_hw);
[~,fit_hw_val]   = compare(data_val,sys_hw);

fprintf('\n');
fprintf('HW RESULTS\n');
fprintf('Training Fit   = %.2f %%\n',fit_hw_train);
fprintf('Validation Fit = %.2f %%\n',fit_hw_val);

%% Prediction Data

[y_hw,fit_hw_val] = compare(data_val,sys_hw);

%% Save

save('battery_hw_results.mat',...
    'sys_hw',...
    'y_hw',...
    'fit_hw_val',...
    'data_val');