function [U, S] = pca(X)
  [m, n] = size(X);

  U = zeros(n);
  S = zeros(n);

  matriz = (X' * X)./m;
  [U, S, V] = svd(matriz);
end
