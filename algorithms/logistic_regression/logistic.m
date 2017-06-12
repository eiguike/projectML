function [tp, fp, fn, tn] = logistic(train_data, test_data)
  [m,n] = size(train_data);
  theta_inicial = zeros(n,1);

  test_data_Y = test_data(:,end);

  opcoes = optimset('GradObj', 'on', 'MaxIter', 100000);
  [theta, custo] = fminunc(@(t)(funcaoCusto(t, train_data, train_data(:,end))), theta_inicial, opcoes);

  p = predicao(theta, test_data);

  tp = sum(((p == 0)+1) == (test_data_Y == 1));
  fp = sum(((p == 0)+1) == (test_data_Y == 0));
  tn = sum(((p == 1)+1) == (test_data_Y == 0));
  fn = sum(((p == 1)+1) == (test_data_Y == 1));
end
