function [tp, fp, fn, tn] = svm(train_data, test_data)

  X_train = train_data(:,1:(end - 1));
  y_train = train_data(:,end);

  X_test = test_data(:,1:(end - 1));
  y_test = test_data(:,end);

  model = svmtrain(y_train, X_train, '-s 0 -t 0 -c 5 -m 1024');

  [predicted_labels] = svmpredict(y_test, X_test, model);

  tp = sum(((predicted_labels == 0)+1) == (y_test == 1));
  fp = sum(((predicted_labels == 0)+1) == (y_test == 0));
  tn = sum(((predicted_labels == 1)+1) == (y_test == 0));
  fn = sum(((predicted_labels == 1)+1) == (y_test == 1));
end
