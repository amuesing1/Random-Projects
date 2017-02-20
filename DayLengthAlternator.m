% Aaron McCusker
% April 29th, 2015
%
% It is hypothesized that by increasing the length of a day on a planet,
% the extreme heat and cold on the far and near sides of the planet can be
% minimized. For example, if a side of a planet experiences 12 hours of
% daylight and then 12 hours of darkness, it may become extremely hot or
% cold during those times. However, if it only experiences 3 hours of
% daylight and 3 hours of darkness at a time, these temperature extremes
% can be contained.
%
% This script is designed to change the length of a day on a planet using
% rockets and a tether system. Supplied with information about the planet,
% the desired length of day, and information about the rocket type to be
% used, the script will determine the number of rockets required to 
% complete the task. The basic principles of angular momentum are used.
%
% Planet in Question: Mars
% Rocket type to be used: Booster from an SLS
% Tether length will reach to EU Definition of Space

% Reset Button

clear all; close all; clc;

% Tether Info

Length_Tether = 100000; % Length of Tether to Rocket(s) [meters]
Density_Tether_Material = 8000; % Steel was used in this case [kg/m^3]
Diameter_Tether = 0.5; % Diameter of the tether to be used. Material cost, deployment, and durability were not analyzed
Mass_Tether = (pi*(Diameter_Tether/2)^2) * Length_Tether * Density_Tether_Material;

% Planet Info

Mass_Body = 6.41693 * 10^(23); % Mass of Body [kg]
Radius_Body = 3390000; % Radius of Body [m]
Inertia = (2/5)*(Mass_Body)*(Radius_Body^2) + ...
    (1/2)*(Mass_Tether)*(((Radius_Body+Length_Tether)/2)^2);

Day_Length_Hours = 24; % Length for one full rotation [hours]
Day_Length_Minutes = 37;
Day_Length_Seconds = Day_Length_Hours*3600 + Day_Length_Minutes*60; % Length of Day [seconds]
Current_Spin = (2*pi)/Day_Length_Seconds; % Angular Velocity of Body [rad/s]

% Rocket Info

Engine_Burn_Time = 124; % Burn time for the rocket used [seconds]
Thrust_Force = 32000000; % Thrust from a single rocket [N]

% Desired Day Length

Desired_Day_Length_Hours = 24;
Desired_Day_Length_Minutes = 36;
Desired_Day_Length_Seconds = Desired_Day_Length_Hours*3600 +...
    Desired_Day_Length_Minutes*60; % Desired Length of Day [seconds]
Desired_Spin = (2*pi)/Desired_Day_Length_Seconds;

% Calculations

Delta_Omega = abs(Desired_Spin - Current_Spin); % Change in Angular Velocity [rad/s]
Alpha_Required = Delta_Omega/Engine_Burn_Time;
Force_Required = Alpha_Required*Inertia/(Length_Tether+Radius_Body);
Rockets_Required = Force_Required/Thrust_Force;

% Results

fprintf('The number of Rockets required to complete this task is %3.0d \n',Rockets_Required);
fprintf('Good Fucking Luck.\n');