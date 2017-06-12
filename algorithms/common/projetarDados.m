function Z = projetarDados(X, U, K)
%PROJETARDADOS Computa a representacao reduzida pela projecao usando os K
%primeiros autovetores
%   Z = projetarDados(X, U, K) calcula a projecao dos dados X
%   em um espaco de dimensao reduzida gerado pelas primeiras K colunas de
%   U. A funcao retorna os exemplos projetados em Z.
%

% Inicializa variavel de retorno.
Z = zeros(size(X, 1), K);

Uparcial = U(:,1:K);
Z =  X * Uparcial;


end
