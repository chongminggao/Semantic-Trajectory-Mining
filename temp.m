% Argyris Zymnis, Joelle Skaf, Stephen Boyd
%
% We are given a matrix A in R^{m*n}
% and are interested in solving the problem:
%
% minimize    ||A - Y*X||_F
% subject to  Y >= 0, X >= 0
%
% where Y in R{m*k} and X in R{k*n}.
% This script generates a random matrix A and obtains an
% *approximate* solution to the above problem by first generating
% a random initial guess for Y and the alternatively minimizing
% over X and Y for a fixed number of iterations.

% Generate data matrix A
rand('state',0);
m = 4; n = 4; k = 6;
A = rand(m,k)*rand(k,n);
A = c
beta1 = 0;
beta2 = 0;

% Initialize Y randomly
Y = rand(m,k);
Y = [1 1 0 0;1 0 1 0;1 0 0 1; 0 1 1 0 ;0 1 0 1;0 0 1 1]'

% Perform alternating minimization
MAX_ITERS = 20;
residual = zeros(1,MAX_ITERS);
for iter = 1:MAX_ITERS
    cvx_begin quiet
        if mod(iter,2) == 1
            variable X(k,n)
            X >= 0;
        else
            variable Y(m,k)
            Y >= 0;
        end
        minimize(norm(A - Y*X,'fro') + (beta1)^(1/2)* norm(ones(1,m)*Y,1) + (beta2)^(1/2)* norm(ones(1,k)*X,1));
    cvx_end
    fprintf(1,'Iteration %d, residual norm %g\n',iter,cvx_optval);
    residual(iter) = cvx_optval;
end

% Plot residuals
figure
plot(residual);
xlabel('Iteration Number');
ylabel('Residual Norm');

% Display results
% disp( 'Original matrix:' );
% disp( A );
% disp( 'Left factor Y:' );
% disp( Y );
% disp( 'Right factor X:' );
% disp( X );

disp( 'Residual A - Y * X:' );
disp( A - Y * X );
disp( 'Residual A - Y * X:' );
disp(norm(A-Y*X,'fro'));
fprintf( 'Residual after %d iterations: %g\n', iter, cvx_optval );