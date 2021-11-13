% Autor: Jenny Kuhn und Jendrik Kraft 
% Modul: Modellierung und Simulation 1
% Thema: Lichtausbreitung in Räumen: Skizzen zur Monte-Carlo-Simulation

clc;
clear;
close all;
m = 1;  % Lambert Parameter
n = 5;  % Anzahl der gewürfelten Photonen
u = rand(n,1);  % Gleichverteilte Zufallsvariable
p = 0.6; %reflektions_wahrscheinlichkeit
% Lambertstrahler_Startpunkt
% Abstrahlrichtung

%% Drehung des Lambertstrahlers

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


%% Wand Matrizen Definition
% X = 0:0.1:100;
% Y = 0:0.1:100;
% [X,Y] = meshgrid(0:0.1:100);
% Wand_1 = [1, 0 ,0].*X + [0, 1 ,0].*Y;
% plot3(Wand_1)
% P = [x,y,z];
% planefunction = dot(normal, P-P1);

P1 = [0,0,0];
P2 = [1,0,0];
P3 = [0,1,0];
% Ebene_1 Parameterform
% Ebene_1 = P1 + P2.*s + P3.*t;
% Ebene_1 Koordinatenform
normal = cross(P1-P2, P1-P3);
% 0 = normal(1)*x + normal(2)*y + normal(3)*z + d;

%# Transform points to x,y,z
x = [P1(1) P2(1) P3(1)];  
y = [P1(2) P2(2) P3(2)];
z = [P1(3) P1(3) P3(3)];

%Find all coefficients of plane equation    
A = normal(1); B = normal(2); C = normal(3);
D = -dot(normal,P1);
%Decide on a suitable showing range
xLim = [-50 50];
zLim = [-50 50];
[X,Z] = meshgrid(xLim,zLim);
Y = (A * X + C * Z + D)/ (-B);

% --> schnittpunkt mit erster Wand nicht so sinnvoll


%% Berechnen der Schnittpunkte mit Wand

%% Ermitteln der zuerst getroffenen Wand

%% Überleben oder verschwinden des Photons ermitteln

%% Ausrechnen des nächsten Abstrahlvektors... -> Schleife

%% Plotten des Photonenwegs
X = [zeros(n) u_x] ;
Y = [zeros(n) u_y] ;
Z = [zeros(n) u_z] ;

figure(1)
plot3(X',Y',Z')
hold on
plot3(X',Y',Z','.')
grid on