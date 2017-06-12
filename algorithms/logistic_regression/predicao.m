function p = predicao(theta, X)
  m = size(X, 1); % Numero de examplos de treinamento
  p = zeros(m, 1);
  p = (sigmoid(theta' * X') >= 0.5)';
end
