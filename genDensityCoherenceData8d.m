% This file contains code to generate m density matrices
% and the corresponding values of Robustness of Coherence(ROC).
% 
%
% First, we generate m density matrices and calculate their ROC,
% saving in X and y, respectively.

% Concretely, for the ith density, we convert 
% its 8 * 8matrix into a 1 * 64 row array. 
% Then save in the ith row in X. 
% X will be a m * 64 matrix.
% The corresponding concurrences are saved in y. 
% y will be a column array of m.

m = 100000; % number of training examples
yX = zeros(m, 65); % initialize X

% randomly generate real entries density matrix, then calculate ROCs
for i = 1:m
    rho = RandomDensityMatrix(8,1);
    coh= RobustnessCoherence(rho);
    rho = reshape(rho,1,64);
    yX(i, 1) = coh;
    yX(i, 2:65) = rho;
end

% save the data for machine learning
csvwrite('yXcoherence.csv',yX)

% for pure states, we can use the following code
% V = RandomStateVector(8,1);
% rho = V*V';


% for small value coherence density matrix, use
% for i = 1:n
%    rho = RandomDensityMatrix(8,1);
%    rho_diagonal = rho .* eye(8);
%    rho = rho_diagonal + (rho - rho_diagonal)*rand();
%    yX(i,1) = RobustnessCoherence(rho);
%    yX(i,2:65) = reshape(rho,1,64);
% end


% for complex entries, use
% yX = zeros(m, 129);
% for i = 1:m
%    rho = RandomDensityMatrix(8,0);
%    coh= RobustnessCoherence(rho);
%    rho = horzcat(real(reshape(rho,1,64)),imag(reshape(rho,1,64)));
%    yX(i, 1) = coh;
%    yX(i, 2:129) = rho;
% end