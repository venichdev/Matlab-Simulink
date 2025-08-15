% Test optimization algorithm
current_state.speed = 60;
current_state.steering = 10;
current_state.throttle = 50;
current_state.brake = 0;
current_state.battery_soc = 80;
current_state.motor_temp = 45;

[optimized_control, energy_saved, metrics] = energyOptimizer(current_state, 30, 'balanced');

fprintf('Energy Saved: %.2f kWh (%.1f%%)\n', energy_saved, metrics.energy_saved_percentage);