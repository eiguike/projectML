function [X_norm, mu, sigma] = normalizar(X)
  [m,n] = size(X);

  X_norm = zeros(m,n);
  mu = 0;
  sigma = 1;

  mu = mean(X);
  sigma = std(X);

  tmp = X - repmat(mu, m, 1);
  X_norm = tmp ./ repmat(sigma, m, 1);
end
