# MATLAB Storage Directory

This directory contains MATLAB projects and simulations for various engineering applications.

## Directory Structure

### NUSTARC2025_Ideas/
Energy-efficient drive-by-wire system demonstration project for NUSTARC 2025.

**Files:**
- `energyOptimizer.m` - Core energy optimization algorithm for drive-by-wire systems
- `presentationHelper.m` - Helper functions and quick start guide for demo presentation
- `runEnergyEfficiencyDemo.m` - Main demo script with different driving scenarios
- `setupDriveByWireModel.m` - Simulink model setup and configuration
- `readme.md` - Project-specific documentation

**Quick Start:**
```matlab
% Setup (run once)
setupDriveByWireModel()

% Run full demo
runEnergyEfficiencyDemo()

% Run specific scenarios
runSingleScenario('City_Driving')
runSingleScenario('Highway_Driving')
runSingleScenario('Mixed_Conditions')
```

### QSS/
Quasi-Steady State (QSS) simulation and tutorial materials.

**Files:**
- `QSS_Tutor.slx` - Simulink tutorial model for QSS methods

## Requirements

- MATLAB with Simulink
- Control System Toolbox (recommended)
- Powertrain Blockset (for automotive simulations)

## Usage

Each subdirectory contains specific project files with their own documentation. Refer to individual readme files for detailed instructions.