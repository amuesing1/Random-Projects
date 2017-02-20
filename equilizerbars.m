clear all
clc
close all
d_tube=.75; %in
h_tube=16; %in
t_motor=90.26; %oz*in
react_time=.15; %sec
speed_motor=0.21; %sec/60 degrees
in_2_oz=1.8046875; %oz/in^3
tube_separation=1.5; %in
max_height=6; %in

v_tube=h_tube*pi*(d_tube/2)^2; %in^3
volume_sec= v_tube/react_time; %in^3/sec
degrees=(60/speed_motor)*react_time; %degrees/react time

force=v_tube*in_2_oz; %oz
max_r=t_motor/force; %in

height_of_chamber=0;
while (2*max_r)>height_of_chamber
    max_r=max_r-.1;
    depth=((2*max_r*pi)/360)*degrees; %in
    height_of_chamber=(2*v_tube)/(depth*tube_separation); %in
end

height_of_chamber=max_height+1;
min_r=0;
while height_of_chamber>max_height
    min_r=min_r+.01;
    depth=((2*min_r*pi)/360)*degrees; %in
    height_of_chamber=(2*v_tube)/(depth*tube_separation); %in
end
    
i=1;
for r=min_r:.01:max_r
    radius(i)=r;
    depth(i)=((2*r*pi)/360)*degrees; %in
    height_of_chamber(i)=(2*v_tube)/(depth(i).*tube_separation); %in
    i=i+1;
end


figure
plot(radius,height_of_chamber)
title('radius of attatchment vs. height of chamber')
xlabel('radius of attachment (in)')
ylabel('height of chamber')