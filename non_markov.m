
% This file calculate the coherence dynamics 
% for a two-qubit system under a non-Markovian environment.
% Generate the data used for comparing with the results
% by machine learing method.


% set the parameters
gamma = 1;
lambda = 0.018;
d = sqrt(2*gamma*lambda - lambda^2);

% initial state at t=0 Psi t_step = 0.1
% r11 = 2/3; r12 = 0; r13 = 0; r14 = sqrt(2/9);
% r21 = 0; r22 = 0; r23 = 0; r24 = 0;
% r31 = 0; r32 = r23; r33 = 0; r34 = 0;
% r41 = r14; r42 = 0; r43 = 0; r44 = 1/3;


% initial state at t=0 Phi t_step = 0.1 (used in the paper)
r11 = 0; r12 = 0; r13 = 0; r14 = 0;
r21 = 0; r22 = 2/3; r23 = sqrt(2/9); r24 = 0;
r31 = 0; r32 = r23; r33 = 1/3; r34 = 0;
r41 = 0; r42 = 0; r43 = 0; r44 = 0;

% initial random at t=0
%r11 = 0.3017; r12 =  -0.1748; r13 = -0.0677; r14 = -0.0754;
%r21 = -0.1748; r22 = 0.3552; r23 = -0.1268; r24 = 0.0191;
%r31 = -0.0677; r32 = -0.1268; r33 = 0.1744; r34 = 0.0950;
%r41 = -0.0754; r42 = 0.0191; r43 = 0.0950; r44 = 0.1687;

% set the time interval
t_end = 200;
t_step = 1;
n = t_end/t_step + 1; % total n points
y = zeros(1,n);
time = 0:t_step:t_end; % time - y graph

yX = zeros(n,17); % this is used for predicting use network
i = 1;
for t = 0:t_step:t_end
   ut = exp(-lambda*t)*(cos(d*t/2) + (lambda/d)*sin(d*t/2))^2;
   vt = 0;
   zt = sqrt(ut);
   rho12 = ut*zt*r12 + vt*zt*r34;
   rho13 = zt*ut*r13 + zt*vt*r24;
   rho24 = zt*(1-ut)*r13 + zt*(1-vt)*r24;
   rho34 = (1-ut)*zt*r12 + (1-vt)*zt*r34;
   rho23 = zt*zt*r23;
   rho14 = zt*zt*r14;
   
   rho21 = rho12;
   rho31 = rho13;
   rho42 = rho24;
   rho43 = rho34;
   rho32 = rho23;
   rho41 = rho14;
   
   rho11 = ut*ut*r11 + ut*vt*r22 + vt*ut*r33 + vt*vt*r44;
   rho22 = ut*(1-ut)*r11 + ut*(1-vt)*r22 + vt*(1-ut)*r33 + vt*(1-vt)*r44;
   rho33 = (1-ut)*ut*r11 + (1-ut)*vt*r22 + (1-vt)*ut*r33 + (1-vt)*vt*r44;
   rho44 = (1-ut)*(1-ut)*r11 + (1-ut)*(1-vt)*r22 + (1-vt)*(1-ut)*r33 + (1-vt)*(1-vt)*r44;
   
   rho = [
       rho11,rho12,rho13,rho14;
       rho21,rho22,rho23,rho24;
       rho31,rho32,rho33,rho34;
       rho41,rho42,rho43,rho44
       ];
   y(i) = RobustnessCoherence(rho);
   rho = reshape(rho,1,16);
   yX(i,1) = y(i);
   yX(i,2:17) = rho;
   i = i + 1;
end

% save the data
csvwrite('nonmarkov.csv',yX)