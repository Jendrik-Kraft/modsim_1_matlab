% Autor: Jenny Kuhn und Jendrik Kraft 
% Modul: Modellierung und Simulation 1
% Thema: Lichtausbreitung in Räumen: Skizzen zur Monte-Carlo-Simulation

clc;
clear;
close all;
m = 1;  % Lambert Parameter
n = 100;  % Anzahl der gewürfelten Photonen
u = rand(n,1);  % Gleichverteilte Zufallsvariable

%% Winkel Berechnung der Photonen
cos_theta = nthroot(u,m+1); 
sin_theta = sqrt(1-cos_theta.^2);
phi = 2*pi()*rand(n,1);
cos_phi = cos(phi);
sin_phi = sin(phi);

%% Vektor Berechnung der Photonen
u_x = sin_theta .* cos_phi;
u_y = sin_theta .* sin_phi;
u_z = cos_theta;


%% Plotten des Photonenwegs
X = [zeros(n) u_x] ;
Y = [zeros(n) u_y] ;
Z = [zeros(n) u_z] ;

figure(1)
plot3(X',Y',Z')
hold on
plot3(X',Y',Z','.')
grid on