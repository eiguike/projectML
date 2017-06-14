function [J, grad] = funcaoCustoReg(theta, X, y, lambda)
  m = length(y); % numero de exemplos de treinamento
  J = 0;
  grad = zeros(size(theta));
  hyp = sigmoid(X*theta);
  J = (1/m)*(-y' * log(hyp) - (1 - y)' * log(1-hyp));
  J = J + sum((theta .^ 2)) * (lambda/(2*m));


  grad(1) = ((1/m) * X'(1) * (hyp(1)-y(1)));
  grad = ((1/m)* X' *(hyp - y)) + (lambda/m)*(grad);
end
