m = 4; n = 4; k = 6;
A = rand(m,k)*rand(k,n);
A = c
beta1 = 0;
beta2 = 0;

Y = [1 1 0 0;1 0 1 0;1 0 0 1; 0 1 1 0 ;0 1 0 1;0 0 1 1]'


% Perform alternating minimization
MAX_ITERS = 20;
residual = zeros(1,MAX_ITERS);
for iter = 1:MAX_ITERS
    cvx_begin quiet
       variable X(k,n)
       X >= 0;
        minimize(norm(A - Y*X,'fro') + (beta1)^(1/2)* norm(ones(1,m)*Y,1) + (beta2)^(1/2)* norm(ones(1,k)*X,1));
    cvx_end
    fprintf(1,'Iteration %d, residual norm %g\n',iter,cvx_optval);
    residual(iter) = cvx_optval;
end