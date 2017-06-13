function [tp, fp, fn, tn] = svm(train_data, test_data, C, gamma)

  X_train = train_data(:,1:(end - 1));
  y_train = train_data(:,end);

  X_test = test_data(:,1:(end - 1));
  y_test = test_data(:,end);

  svm_opts = cstrcat('-s 0 -t 2 -m 2048 -q -c ', num2str(C, '%.5f'), ' -g ', num2str(gamma, '%.12f'));

  model = svmtrain(y_train, X_train, svm_opts);

  [predicted_labels] = svmpredict(y_test, X_test, model, '-q');

  tp = sum(((predicted_labels == 0)+1) == (y_test == 1));
  fp = sum(((predicted_labels == 0)+1) == (y_test == 0));
  tn = sum(((predicted_labels == 1)+1) == (y_test == 0));
  fn = sum(((predicted_labels == 1)+1) == (y_test == 1));
end
