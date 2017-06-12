function [U, S] = pca(X)
%PCA Executa a analise de componentes principais na base de dados X
%   [U, S] = pca(X) computa os autovetores da matriz de covariancia de X
%   Retorna os autovetores U e os autovalores (diagonal) em S.
%

% Dimensao de X
[m, n] = size(X);

% Valores de retorno
U = zeros(n);
S = zeros(n);

sigma = (1 / m) * (X' * X);
[U, S, V] = svd(sigma);


end
