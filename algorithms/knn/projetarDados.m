function Z = projetarDados(X, U, K)
  Z = U(1:K,:) * X';
end
