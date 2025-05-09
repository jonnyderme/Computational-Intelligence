%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 

%% Plot refence input and output
figure(1);
plot(out.r.Time, out.r.Data);
hold on;
plot(out.y.Time, out.y.Data);
title('System Response: Ke = 4, Ki = 1, K = 12','Interpreter','latex','FontSize',12,'FontWeight','bold');
xlabel('Time(sec)','Interpreter','latex');
ylabel('Angular Velocity of the mechanism','Interpreter','latex');
ylim([0 100]);

% Calculate the rise time of the signal
rise = risetime(out.y.Data, out.y.Time);
fprintf("\n\nRise Time(sec): %d", rise);

% Calculate the overshoot factor
os = overshoot(out.y.Data, out.y.Time);
os = (max(out.y.Data)-out.y.Data(end,:))/out.y.Data(end,:)*100;
fprintf("\nOvershoot factor(%%): %d", os);

