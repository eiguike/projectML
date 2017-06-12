function [J, grad] = funcaoCusto(theta, X, y)
  m = length(y); % numero de exemplos de treinamento
  J = 0;
  grad = zeros(size(theta));
  hyp = sigmoid(X*theta);
  J = (-y' * log(hyp) - (1 - y)' * log(1-hyp))/m;
  grad = (X' *(hyp - y))./m;
end
