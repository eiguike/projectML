function [tp, fp, fn, tn] = knn(test_data, train_data, K)

  % getting final results %
  test_data_Y = test_data(:,end);
  train_data_Y = train_data(:,end);

  % removing final results %
  train_data = train_data(:,1:(end-1));
  test_data = test_data(:,1:(end-1));

  [m, n] = size(test_data_Y);

  Y_out = zeros(m, 1);

  ind_viz = ones(K,1);  % Inicializa indices (linhas) em train_data das K amostras mais

  for i=1:m
    D = distancia(test_data(i,:), train_data);
    %[D, indices] =sort(D);
    %D = horzcat(D, indices);

    D = horzcat(D, train_data_Y);
    D = horzcat(D, (1:size(D,1))');
    D = sortrows(D,[1]);

    indices = D(:,end);
    classes = D(:,end-1);

    ind_viz = indices(1:K);
    viz_classes = classes(1:K);

    if sum(viz_classes) <= (K / 2)
        Y_out(i) = 0;
    else
        Y_out(i) = 1;
    endif
  endfor

  tp = sum(((Y_out == 0)+1) == (test_data_Y == 1));
  fp = sum(((Y_out == 0)+1) == (test_data_Y == 0));
  tn = sum(((Y_out == 1)+1) == (test_data_Y == 0));
  fn = sum(((Y_out == 1)+1) == (test_data_Y == 1));
end
