%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 

FIS_Car = readfis('C:\Thmmy_Auth\Computational_Intelligence\Assignment2\FIS_Car_E.fis') ; 
%FIS_Car = readfis('C:\Thmmy_Auth\Computational_Intelligence\Assignment2\TuningFIS\FIS_Car_E_Tuned.fis') ; 

%% Define X and Y coordinates of the obstacle points
XWall = [5, 5, 6, 6, 7, 7, 10];
YWall = [0, 1, 1, 2, 2, 3, 3];
figure;

% Plot the obstacle
plot(XWall, YWall, 'LineWidth', 2);

% Set axis labels and title and axis limits
xlabel('X-axis');   
ylabel('Y-axis');
title('Car Route');
xlim([0, 12]);
ylim([0, 4]);

hold on;

% Desired point coordinates
Xdestination = 10;
Ydestination = 3.2;

% Plot the Desired Position point
plot(Xdestination, Ydestination, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6);

% Plot the (X-Y) car route
plot(out.X.Data, out.Y.Data,'LineWidth', 2);


