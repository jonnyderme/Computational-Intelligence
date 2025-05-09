%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr

% Open-Loop Tranfer Function of System
s = tf('s');
Ka = 1; 
c = 0.125;
% Open-loop transfer function for the system
openLoopSystem = 25*(s+c)/(s*(s+0.1)*(s+10));

% Closed Loop Transfer Function with feedback of -1
closedLoopSystem = feedback(openLoopSystem, 1, -1);

% Plot the Root Locus of the Open-Loop System
rlocus(openLoopSystem);

% Define the Transfer Functions for System and Controller
Gp = 25/((s+0.1)*(s+10));
Gc = Ka*(s+c)/s;

%% Tune the system using controlSystemDesigner
controlSystemDesigner(Gp,Gc) ;

%% Load the controller model after tuning
LinearPI = load('ControlSystemDesignerSessionTuneLinPI.mat') ; 
% Extract the tuned value of proportional gain Kp and zero c from the session data
Kp = LinearPI.ControlSystemDesignerSession.DesignerData.Architecture.TunedBlocks(2).ZPKGain ; 
c = LinearPI.ControlSystemDesignerSession.DesignerData.Architecture.TunedBlocks(2).PZGroup(1).Zero;

% Update the Controller Transfer Function Based on Tuned Values
Gc = Kp*(s-c)/s;

% Compute the Open and Closed-Loop Transfer Functions
openLoopSystem = Gp*Gc;
closedLoopSystem = feedback(openLoopSystem,1,-1);
step(closedLoopSystem);

% Info about the step response
S = stepinfo(closedLoopSystem);

% Print the results about rise time and overshoot 
fprintf('Step Respose Results\n');
fprintf('Rise time(sec): %f\n', S.RiseTime);
fprintf('Overshoot(%%): %f\n', S.Overshoot);

% Calculation of Ki and Kp
Ki = (-c)*Kp ; 
fprintf("\nKp = %g \t Ki = %g\n", Kp, Ki);

%% Root locus plot
figure;
rlocus(openLoopSystem);

%% Step response plot
figure;
step(closedLoopSystem);
