%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 

%% Creation of the Fuzzy Inference System
% Singleton fuzzifier
% The AND connector is implemented with the min operator
% Larsen Rule : ImplicationMethod -> prod, AggregationMethod -> max , Totally -> max-min method
% The ALSO connector is implemented with the max operator
% Defuzzifier -> COS (Center Of Sums)
FISystem = mamfis('Name', 'MyMamdaniFIS', 'AndMethod', 'min', 'OrMethod', 'max', 'ImplicationMethod', 'prod', 'AggregationMethod', 'max', 'DefuzzificationMethod', 'centroid');

%% Declaration of fuzzy sets for each linguistic variable
% Declaration of input variables
% The error (E) as input variable
FISystem = addInput(FISystem, [-1 1], 'Name', 'E');  % Define the range for 'E' input
FISystem = addmf(FISystem, 'input', 1, 'NL', 'trimf', [-1 -1 -0.667]);  % NL set
FISystem = addmf(FISystem, 'input', 1, 'NM', 'trimf', [-1 -0.667 -0.333]);  % NM set
FISystem = addmf(FISystem, 'input', 1, 'NS', 'trimf', [-0.667 -0.333 0]);  % NS set
FISystem = addmf(FISystem, 'input', 1, 'ZR', 'trimf', [-0.333 0 0.333]);  % ZR set
FISystem = addmf(FISystem, 'input', 1, 'PS', 'trimf', [0 0.333 0.667]);   % PS set
FISystem = addmf(FISystem, 'input', 1, 'PM', 'trimf', [0.333 0.667 1]);   % PM set
FISystem = addmf(FISystem, 'input', 1, 'PL', 'trimf', [0.667 1 1]);       % PL set

% The derivative error (DE) as input variable
FISystem = addInput(FISystem, [-1 1], 'Name', 'DE');  % Define the range for 'DE' input
FISystem = addmf(FISystem, 'input', 2, 'NL', 'trimf', [-1 -1 -0.667]);  % NL set
FISystem = addmf(FISystem, 'input', 2, 'NM', 'trimf', [-1 -0.667 -0.333]);  % NM set
FISystem = addmf(FISystem, 'input', 2, 'NS', 'trimf', [-0.667 -0.333 0]);  % NS set
FISystem = addmf(FISystem, 'input', 2, 'ZR', 'trimf', [-0.333 0 0.333]);  % ZR set
FISystem = addmf(FISystem, 'input', 2, 'PS', 'trimf', [0 0.333 0.667]);   % PS set
FISystem = addmf(FISystem, 'input', 2, 'PM', 'trimf', [0.333 0.667 1]);   % PM set
FISystem = addmf(FISystem, 'input', 2, 'PL', 'trimf', [0.667 1 1]);       % PL set

 % The derivative control signal (DU) as output variable 
FISystem = addOutput(FISystem, [-1 1], 'Name', 'DU');  % Define the range for 'DU' output
FISystem = addmf(FISystem, 'output', 1, 'NV', 'trimf', [-1 -1 -0.75]);  % NV set
FISystem = addmf(FISystem, 'output', 1, 'NL', 'trimf', [-1 -0.75 -0.5]);  % NL set
FISystem = addmf(FISystem, 'output', 1, 'NM', 'trimf', [-0.75 -0.5 -0.25]);  % NM set
FISystem = addmf(FISystem, 'output', 1, 'NS', 'trimf', [-0.5 -0.25 0]);  % NS set
FISystem = addmf(FISystem, 'output', 1, 'ZR', 'trimf', [-0.25 0 0.25]);  % ZR set
FISystem = addmf(FISystem, 'output', 1, 'PS', 'trimf', [0 0.25 0.5]);  % PS set
FISystem = addmf(FISystem, 'output', 1, 'PM', 'trimf', [0.25 0.5 0.75]);  % PM set
FISystem = addmf(FISystem, 'output', 1, 'PL', 'trimf', [0.5 0.75 1]);  % PL set
FISystem = addmf(FISystem, 'output', 1, 'PV', 'trimf', [0.75 1 1]);  % PV set


% Declaration of the fuzzy rules: 49 compositions totally
fuzzyRules = [...
 
% --- 1st row of table: E = NL (Negative Large) --- %
"E==NL & DE==NL => DU=NV"; ...    % When both E and DE are Negative Large, DU is Negative Very (NV)
"E==NL & DE==NM => DU=NV"; ...    % E is NL, DE is Negative Medium, DU is NV
"E==NL & DE==NS => DU=NV"; ...    % E is NL, DE is Negative Small, DU is NV
"E==NL & DE==ZR => DU=NL"; ...    % E is NL, DE is Zero, DU becomes Negative Large (NL)
"E==NL & DE==PS => DU=NM"; ...    % E is NL, DE is Positive Small, DU is Negative Medium (NM)
"E==NL & DE==PM => DU=NS"; ...    % E is NL, DE is Positive Medium, DU is Negative Small (NS)
"E==NL & DE==PL => DU=ZR"; ...    % E is NL, DE is Positive Large, DU becomes Zero (ZR)

% --- 2nd row of table: E = NM (Negative Medium) --- %
"E==NM & DE==NL => DU=NV"; ...    % E is NM, DE is NL, DU is NV
"E==NM & DE==NM => DU=NV"; ...    % E is NM, DE is NM, DU is NV
"E==NM & DE==NS => DU=NL"; ...    % E is NM, DE is NS, DU is NL
"E==NM & DE==ZR => DU=NM"; ...    % E is NM, DE is ZR, DU is NM
"E==NM & DE==PS => DU=NS"; ...    % E is NM, DE is PS, DU is NS
"E==NM & DE==PM => DU=ZR"; ...    % E is NM, DE is PM, DU becomes ZR
"E==NM & DE==PL => DU=PS"; ...    % E is NM, DE is PL, DU becomes Positive Small (PS)

% --- 3rd row of table: E = NS (Negative Small) --- %
"E==NS & DE==NL => DU=NV"; ...    % E is NS, DE is NL, DU is NV
"E==NS & DE==NM => DU=NL"; ...    % E is NS, DE is NM, DU is NL
"E==NS & DE==NS => DU=NM"; ...    % E is NS, DE is NS, DU is NM
"E==NS & DE==ZR => DU=NS"; ...    % E is NS, DE is ZR, DU is NS
"E==NS & DE==PS => DU=ZR"; ...    % E is NS, DE is PS, DU becomes ZR
"E==NS & DE==PM => DU=PS"; ...    % E is NS, DE is PM, DU is PS
"E==NS & DE==PL => DU=PM"; ...    % E is NS, DE is PL, DU becomes Positive Medium (PM)

% --- 4th row of table: E = ZR (Zero) --- %
"E==ZR & DE==NL => DU=NL"; ...    % E is ZR, DE is NL, DU is NL
"E==ZR & DE==NM => DU=NM"; ...    % E is ZR, DE is NM, DU is NM
"E==ZR & DE==NS => DU=NS"; ...    % E is ZR, DE is NS, DU is NS
"E==ZR & DE==ZR => DU=ZR"; ...    % E is ZR, DE is ZR, DU is ZR (Zero control action)
"E==ZR & DE==PS => DU=PS"; ...    % E is ZR, DE is PS, DU is PS
"E==ZR & DE==PM => DU=PM"; ...    % E is ZR, DE is PM, DU is PM
"E==ZR & DE==PL => DU=PL"; ...    % E is ZR, DE is PL, DU is Positive Large (PL)

% --- 5th row of table: E = PS (Positive Small) --- %
"E==PS & DE==NL => DU=NM"; ...    % E is PS, DE is NL, DU is NM
"E==PS & DE==NM => DU=NS"; ...    % E is PS, DE is NM, DU is NS
"E==PS & DE==NS => DU=ZR"; ...    % E is PS, DE is NS, DU is ZR
"E==PS & DE==ZR => DU=PS"; ...    % E is PS, DE is ZR, DU is PS
"E==PS & DE==PS => DU=PM"; ...    % E is PS, DE is PS, DU is PM
"E==PS & DE==PM => DU=PL"; ...    % E is PS, DE is PM, DU is PL
"E==PS & DE==PL => DU=PV"; ...    % E is PS, DE is PL, DU becomes Positive Very (PV)

% --- 6th row of table: E = PM (Positive Medium) --- %
"E==PM & DE==NL => DU=NS"; ...    % E is PM, DE is NL, DU is NS
"E==PM & DE==NM => DU=ZR"; ...    % E is PM, DE is NM, DU is ZR
"E==PM & DE==NS => DU=PS"; ...    % E is PM, DE is NS, DU is PS
"E==PM & DE==ZR => DU=PM"; ...    % E is PM, DE is ZR, DU is PM
"E==PM & DE==PS => DU=PL"; ...    % E is PM, DE is PS, DU is PL
"E==PM & DE==PM => DU=PV"; ...    % E is PM, DE is PM, DU is PV
"E==PM & DE==PL => DU=PV"; ...    % E is PM, DE is PL, DU is PV

% --- 7th row of table: E = PL (Positive Large) --- %
"E==PL & DE==NL => DU=ZR"; ...    % E is PL, DE is NL, DU is ZR
"E==PL & DE==NM => DU=PS"; ...    % E is PL, DE is NM, DU is PS
"E==PL & DE==NS => DU=PM"; ...    % E is PL, DE is NS, DU is PM
"E==PL & DE==ZR => DU=PL"; ...    % E is PL, DE is ZR, DU is PL
"E==PL & DE==PS => DU=PV"; ...    % E is PL, DE is PS, DU is PV
"E==PL & DE==PM => DU=PV"; ...    % E is PL, DE is PM, DU is PV
"E==PL & DE==PL => DU=PV"; ...    % E is PL, DE is PL, DU is PV
];
%% Plot the Membership Functions for the input variables
% Error input Signal
figure(1);
plotmf(FISystem, 'input', 1, 1000);          
title('Membership Functions of Error(E)','Interpreter','latex','FontWeight','bold')
%legend('MF1','MF2','MF3','MF4','MF5','MF6','MF7')

% DE input Signal
figure(2)
plotmf(FISystem, 'input', 2, 1000);   
title('Membership Functions of Error Change(DE)','Interpreter','latex','FontWeight','bold')
%legend('MF1','MF2','MF3','MF4','MF5','MF6','MF7')

%% Plot the fuzzy sets for the output variables
% Control Signal Change(DU)
figure(3);
plotmf(FISystem, 'output', 1, 1000);
title('Membership Functions of Control Signal Change(DU)','Interpreter','latex','FontWeight','bold')
%legend('MF1','MF2','MF3','MF4','MF5','MF6','MF7','MF8','MF9')


%% Import the rule table into the fis
FISystem = addRule(FISystem, fuzzyRules);

% Write the fis object into a .fis file
writefis(FISystem, 'FISystem_Trapezi_Ergasias_24.fis');

%% Graphical presentation of rules with Rule Viewer 
ruleview(FISystem);

%% Creation of the 3D output graph
figure(4) ; 
gensurf(FISystem);
title('Output surface of the FIS as a function of the inputs','Interpreter','latex','FontWeight','bold')
