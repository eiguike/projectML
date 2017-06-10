function [X_norm, mu, sigma] = normalizar(X)
  [m,n] = size(X); % m = qtde de objetos e n = qtde de atributos por objeto
  X_norm = zeros(m,n); % inicializa X_norm
  mu = 0; % inicializa media
  sigma = 1; % inicializa desvio padrao
  X_norm = X;
  mu = mean(X);
  sigma = std(X);
  X_norm = X_norm - mu;
  X_norm = X_norm ./sigma;
end
