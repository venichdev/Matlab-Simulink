%% STEP 2: Simulink Model Setup for Energy-Efficient Drive-by-Wire Demo
% File: setupDriveByWireModel.m
% Purpose: Create and configure the complete Simulink model

function setupDriveByWireModel()
    %% 1. CREATE NEW MODEL
    model_name = 'EnergyEfficientDriveByWire';
    
    % Close existing model if open
    if bdIsLoaded(model_name)
        close_system(model_name, 0);
    end
    
    % Create new model
    new_system(model_name);
    open_system(model_name);
    
    %% 2. MODEL CONFIGURATION
    set_param(model_name, 'Solver', 'ode45');
    set_param(model_name, 'StopTime', '300'); % 5 minutes simulation
    set_param(model_name, 'FixedStep', '0.01'); % 10ms sample time
    
    %% 3. CREATE MAIN SUBSYSTEMS
    
    % Driver Input Subsystem
    add_block('simulink/Ports & Subsystems/Subsystem', [model_name '/Driver Inputs']);
    set_param([model_name '/Driver Inputs'], 'Position', [50 100 150 200]);
    
    % Traditional Control Subsystem
    add_block('simulink/Ports & Subsystems/Subsystem', [model_name '/Traditional Control']);
    set_param([model_name '/Traditional Control'], 'Position', [250 50 400 150]);
    
    % Optimized Control Subsystem
    add_block('simulink/Ports & Subsystems/Subsystem', [model_name '/Optimized Control']);
    set_param([model_name '/Optimized Control'], 'Position', [250 200 400 300]);
    
    % Vehicle Dynamics Subsystem
    add_block('simulink/Ports & Subsystems/Subsystem', [model_name '/Vehicle Dynamics']);
    set_param([model_name '/Vehicle Dynamics'], 'Position', [500 125 650 225]);
    
    % Energy Monitor Subsystem
    add_block('simulink/Ports & Subsystems/Subsystem', [model_name '/Energy Monitor']);
    set_param([model_name '/Energy Monitor'], 'Position', [750 125 900 225]);
    
    % Visualization Subsystem
    add_block('simulink/Ports & Subsystems/Subsystem', [model_name '/Visualization']);
    set_param([model_name '/Visualization'], 'Position', [500 350 650 450]);
    
    %% 4. BUILD DRIVER INPUTS SUBSYSTEM
    buildDriverInputs([model_name '/Driver Inputs']);
    
    %% 5. BUILD TRADITIONAL CONTROL
    buildTraditionalControl([model_name '/Traditional Control']);
    
    %% 6. BUILD OPTIMIZED CONTROL
    buildOptimizedControl([model_name '/Optimized Control']);
    
    %% 7. BUILD VEHICLE DYNAMICS
    buildVehicleDynamics([model_name '/Vehicle Dynamics']);
    
    %% 8. BUILD ENERGY MONITOR
    buildEnergyMonitor([model_name '/Energy Monitor']);
    
    %% 9. BUILD VISUALIZATION
    buildVisualization([model_name '/Visualization']);
    
    %% 10. CONNECT SUBSYSTEMS
    connectSubsystems(model_name);
    
    %% 11. ADD SCOPES AND DISPLAYS
    addScopesAndDisplays(model_name);
    
    %% Save and arrange
    Simulink.BlockDiagram.arrangeSystem(model_name);
    save_system(model_name);
    
    fprintf('✅ Simulink model "%s" created successfully!\n', model_name);
    fprintf('📊 Ready for energy-efficient drive-by-wire simulation\n');
end

%% SUBSYSTEM BUILDERS

function buildDriverInputs(subsystem_path)
    % Create driver input signals (steering, throttle, brake)
    
    % Steering input - sinusoidal for testing
    add_block('simulink/Sources/Signal Builder', [subsystem_path '/Steering Command']);
    
    % Throttle input - step changes
    add_block('simulink/Sources/Signal Builder', [subsystem_path '/Throttle Command']);
    
    % Brake input - pulse signals
    add_block('simulink/Sources/Signal Builder', [subsystem_path '/Brake Command']);
    
    % Driving scenario selector
    add_block('simulink/Signal Routing/Multiport Switch', [subsystem_path '/Scenario Selector']);
    
    % Output ports
    add_block('simulink/Ports & Subsystems/Out1', [subsystem_path '/Steering_Out']);
    add_block('simulink/Ports & Subsystems/Out1', [subsystem_path '/Throttle_Out']);
    add_block('simulink/Ports & Subsystems/Out1', [subsystem_path '/Brake_Out']);
end

function buildTraditionalControl(subsystem_path)
    % Traditional PID-based control system
    
    % Input ports
    add_block('simulink/Ports & Subsystems/In1', [subsystem_path '/Steering_In']);
    add_block('simulink/Ports & Subsystems/In1', [subsystem_path '/Throttle_In']);
    add_block('simulink/Ports & Subsystems/In1', [subsystem_path '/Brake_In']);
    
    % PID Controllers
    add_block('simulink/Continuous/PID Controller', [subsystem_path '/Steering_PID']);
    set_param([subsystem_path '/Steering_PID'], 'P', '10', 'I', '0.5', 'D', '0.1');
    
    add_block('simulink/Continuous/PID Controller', [subsystem_path '/Throttle_PID']);
    set_param([subsystem_path '/Throttle_PID'], 'P', '5', 'I', '0.2', 'D', '0.05');
    
    add_block('simulink/Continuous/PID Controller', [subsystem_path '/Brake_PID']);
    set_param([subsystem_path '/Brake_PID'], 'P', '15', 'I', '0.1', 'D', '0.2');
    
    % Actuator models
    add_block('simulink/Continuous/Transfer Fcn', [subsystem_path '/Steering_Actuator']);
    set_param([subsystem_path '/Steering_Actuator'], 'Numerator', '[1]', 'Denominator', '[0.1 1]');
    
    % Output ports
    add_block('simulink/Ports & Subsystems/Out1', [subsystem_path '/Control_Out']);
    add_block('simulink/Ports & Subsystems/Out1', [subsystem_path '/Energy_Out']);
end

function buildOptimizedControl(subsystem_path)
    % AI-enhanced optimized control system
    
    % Input ports
    add_block('simulink/Ports & Subsystems/In1', [subsystem_path '/Steering_In']);
    add_block('simulink/Ports & Subsystems/In1', [subsystem_path '/Throttle_In']);
    add_block('simulink/Ports & Subsystems/In1', [subsystem_path '/Brake_In']);
    add_block('simulink/Ports & Subsystems/In1', [subsystem_path '/Vehicle_State']);
    
    % MATLAB Function block for optimization
    add_block('simulink/User-Defined Functions/MATLAB Function', [subsystem_path '/Energy_Optimizer']);
    
    % Set MATLAB Function code
    optimizer_code = sprintf(['function [control_out, energy_out] = fcn(steering_in, throttle_in, brake_in, vehicle_state)\n' ...
        '    %% Call optimization algorithm\n' ...
        '    current_state.steering = steering_in;\n' ...
        '    current_state.throttle = throttle_in;\n' ...
        '    current_state.brake = brake_in;\n' ...
        '    current_state.speed = vehicle_state(1);\n' ...
        '    current_state.battery_soc = vehicle_state(2);\n' ...
        '    current_state.motor_temp = vehicle_state(3);\n' ...
        '    \n' ...
        '    prediction_horizon = 30;\n' ...
        '    [optimized_control, energy_saved, ~] = energyOptimizer(current_state, prediction_horizon, ''balanced'');\n' ...
        '    \n' ...
        '    control_out = [optimized_control.steering.motor_current; \n' ...
        '                   optimized_control.throttle.position; \n' ...
        '                   optimized_control.brake.mechanical_force];\n' ...
        '    energy_out = energy_saved;\n' ...
        'end']);
    
    % Adaptive control blocks
    add_block('simulink/Math Operations/Gain', [subsystem_path '/Adaptive_Gain']);
    
    % Output ports
    add_block('simulink/Ports & Subsystems/Out1', [subsystem_path '/Control_Out']);
    add_block('simulink/Ports & Subsystems/Out1', [subsystem_path '/Energy_Out']);
end

function buildVehicleDynamics(subsystem_path)
    % Simplified EV vehicle dynamics model
    
    % Input ports
    add_block('simulink/Ports & Subsystems/In1', [subsystem_path '/Control_In']);
    
    % Motor model
    add_block('simulink/Continuous/Transfer Fcn', [subsystem_path '/Motor_Model']);
    set_param([subsystem_path '/Motor_Model'], 'Numerator', '[100]', 'Denominator', '[0.5 1]');
    
    % Battery model
    add_block('simulink/Continuous/Integrator', [subsystem_path '/Battery_SOC']);
    set_param([subsystem_path '/Battery_SOC'], 'InitialCondition', '80'); % 80% initial SOC
    
    % Vehicle speed dynamics
    add_block('simulink/Continuous/Integrator', [subsystem_path '/Vehicle_Speed']);
    
    % Drag and resistance
    add_block('simulink/Math Operations/Gain', [subsystem_path '/Aero_Drag']);
    set_param([subsystem_path '/Aero_Drag'], 'Gain', '-0.3');
    
    % Output ports
    add_block('simulink/Ports & Subsystems/Out1', [subsystem_path '/Vehicle_State']);
    add_block('simulink/Ports & Subsystems/Out1', [subsystem_path '/Speed_Out']);
end

function buildEnergyMonitor(subsystem_path)
    % Energy consumption monitoring and comparison
    
    % Input ports
    add_block('simulink/Ports & Subsystems/In1', [subsystem_path '/Traditional_Energy']);
    add_block('simulink/Ports & Subsystems/In1', [subsystem_path '/Optimized_Energy']);
    
    % Energy integrators
    add_block('simulink/Continuous/Integrator', [subsystem_path '/Traditional_Total']);
    add_block('simulink/Continuous/Integrator', [subsystem_path '/Optimized_Total']);
    
    % Comparison calculations
    add_block('simulink/Math Operations/Sum', [subsystem_path '/Energy_Difference']);
    add_block('simulink/Math Operations/Divide', [subsystem_path '/Savings_Percentage']);
    
    % Running average
    add_block('simulink/Discrete/Discrete Filter', [subsystem_path '/Moving_Average']);
    
    % Output ports
    add_block('simulink/Ports & Subsystems/Out1', [subsystem_path '/Energy_Comparison']);
    add_block('simulink/Ports & Subsystems/Out1', [subsystem_path '/Savings_Percent']);
end

function buildVisualization(subsystem_path)
    % Real-time visualization components
    
    % Input ports
    add_block('simulink/Ports & Subsystems/In1', [subsystem_path '/Data_In']);
    
    % Dashboard blocks
    add_block('simulink/Dashboard/Dashboard Scope', [subsystem_path '/Energy_Scope']);
    add_block('simulink/Dashboard/Gauge', [subsystem_path '/Speed_Gauge']);
    add_block('simulink/Dashboard/Gauge', [subsystem_path '/SOC_Gauge']);
    add_block('simulink/Dashboard/Display', [subsystem_path '/Savings_Display']);
    
    % XY Graph for efficiency map
    add_block('simulink/Sinks/XY Graph', [subsystem_path '/Efficiency_Map']);
end

function connectSubsystems(model_name)
    % Connect all subsystems with signal lines
    
    % Driver to Controllers
    add_line(model_name, 'Driver Inputs/1', 'Traditional Control/1', 'autorouting', 'on');
    add_line(model_name, 'Driver Inputs/2', 'Traditional Control/2', 'autorouting', 'on');
    add_line(model_name, 'Driver Inputs/3', 'Traditional Control/3', 'autorouting', 'on');
    
    add_line(model_name, 'Driver Inputs/1', 'Optimized Control/1', 'autorouting', 'on');
    add_line(model_name, 'Driver Inputs/2', 'Optimized Control/2', 'autorouting', 'on');
    add_line(model_name, 'Driver Inputs/3', 'Optimized Control/3', 'autorouting', 'on');
    
    % Controllers to Vehicle
    add_line(model_name, 'Traditional Control/1', 'Vehicle Dynamics/1', 'autorouting', 'on');
    
    % Vehicle to Energy Monitor
    add_line(model_name, 'Traditional Control/2', 'Energy Monitor/1', 'autorouting', 'on');
    add_line(model_name, 'Optimized Control/2', 'Energy Monitor/2', 'autorouting', 'on');
    
    % Feedback from Vehicle to Optimized Control
    add_line(model_name, 'Vehicle Dynamics/1', 'Optimized Control/4', 'autorouting', 'on');
    
    % To Visualization
    add_line(model_name, 'Energy Monitor/1', 'Visualization/1', 'autorouting', 'on');
end

function addScopesAndDisplays(model_name)
    % Add scopes for real-time monitoring
    
    % Main comparison scope
    add_block('simulink/Sinks/Scope', [model_name '/Energy_Comparison_Scope']);
    set_param([model_name '/Energy_Comparison_Scope'], 'Position', [950 50 1050 150]);
    set_param([model_name '/Energy_Comparison_Scope'], 'NumInputPorts', '2');
    
    % Savings display
    add_block('simulink/Sinks/Display', [model_name '/Energy_Savings_Display']);
    set_param([model_name '/Energy_Savings_Display'], 'Position', [950 200 1050 250]);
    
    % Connect displays
    add_line(model_name, 'Energy Monitor/1', 'Energy_Comparison_Scope/1', 'autorouting', 'on');
    add_line(model_name, 'Energy Monitor/2', 'Energy_Savings_Display/1', 'autorouting', 'on');
end

%% Run the setup
setupDriveByWireModel();