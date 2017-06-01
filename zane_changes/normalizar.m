function [X_norm, mu, sigma] = normalizar(X)
%NORMALIZAR normaliza os atributos em X
%   NORMALIZAR(X) retorna uma versao normalizada de X onde o valor da
%   media de cada atributo eh 0 e desvio padrao eh igual a 1. Trata-se de
%   um importante passo de pre-processamento quando trabalha-se com 
%   metodos de aprendizado de maquina.

%  Calcula a quantidade de amostra e de atributos
[m,n] = size(X); % m = qtde de objetos e n = qtde de atributos por objeto

% Incializa as variaves de saida
X_norm = zeros(m,n); % inicializa X_norm
mu = 0; % inicializa media
sigma = 1; % inicializa desvio padrao

mu = mean(X);
sigma = std(X);

tmp = X - repmat(mu, m, 1);
X_norm = tmp ./ repmat(sigma, m, 1);



% ============================================================

end
