clear all
close all
clc

earth=load('earth.lst');
mars=load('mars.lst');

earth_au=earth(:,3);
earth_lat=earth(:,4);
earth_lon=earth(:,6);
mars_au=mars(:,3);
mars_lat=mars(:,4);
mars_lon=mars(:,6);

earth_distance_magnitude=149597870.700*earth_au;
earth_z=earth_distance_magnitude.*sind(earth_lat);
earth_x=earth_distance_magnitude.*sind(earth_lon);
earth_y=earth_distance_magnitude.*cosd(earth_lon);

mars_distance_magnitude=149597870.700*mars_au;
mars_z=mars_distance_magnitude.*sind(mars_lat);
mars_x=mars_distance_magnitude.*sind(mars_lon);
mars_y=mars_distance_magnitude.*cosd(mars_lon);

figure
hold on
plot3(earth_x,earth_y,earth_z);
plot3(mars_x,mars_y,mars_z,'r');
plot3(0,0,0,'rO');
plot3(zeros(length(earth_x),1),linspace(min(mars_y),max(mars_y),...
    length(mars_y)),zeros(length(earth_x),1),'k');
plot3(linspace(min(mars_x),max(mars_x),length(mars_x)),...
    zeros(length(earth_x),1),zeros(length(earth_x),1),'k');
plot3(zeros(length(earth_x),1),zeros(length(earth_x),1),...
    linspace(min(mars_z),max(mars_z),length(mars_z)),'k');
axis equal tight