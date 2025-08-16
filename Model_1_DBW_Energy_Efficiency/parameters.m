%% STEP 0: System Parameters and Test Script
% File: parameters.m
% Purpose: Define system parameters and provide test examples

%% Test optimization algorithm with sample data
function testEnergyOptimizer()
    % Test with sample vehicle state
    current_state.speed = 60;        % km/h
    current_state.steering = 10;     % degrees
    current_state.throttle = 50;     % percentage
    current_state.brake = 0;         % bar
    current_state.battery_soc = 80;  % percentage
    current_state.motor_temp = 45;   % celsius
    
    % Run optimization
    [optimized_control, energy_saved, metrics] = energyOptimizer(current_state, 30, 'balanced');
    
    % Display results
    fprintf('Energy Saved: %.2f kWh (%.1f%%)\n', energy_saved, metrics.energy_saved_percentage);
    fprintf('Response Time: %.1f ms\n', metrics.response_time_ms);
    fprintf('Efficiency Score: %.1f/100\n', metrics.efficiency_score);
end

%% System Parameters
function params = getSystemParameters()
    % Vehicle parameters
    params.vehicle.mass = 1500;           % kg
    params.vehicle.drag_coeff = 0.3;      % Cd
    params.vehicle.frontal_area = 2.5;    % m²
    params.vehicle.wheel_radius = 0.3;    % m
    
    % Motor parameters
    params.motor.max_power = 200;         % kW
    params.motor.max_torque = 400;        % Nm
    params.motor.efficiency_peak = 0.95;  % 95%
    
    % Battery parameters
    params.battery.capacity = 75;         % kWh
    params.battery.voltage_nominal = 400; % V
    params.battery.max_current = 300;     % A
    
    % Control parameters
    params.control.sample_time = 0.01;    % 10ms
    params.control.max_steering_rate = 180; % deg/s
    params.control.max_throttle_rate = 100;  % %/s
end

%% To run test: testEnergyOptimizer()