function p = predicao(Theta1, Theta2, X)

m = size(X, 1);

h1 = sigmoide([ones(m, 1) X] * Theta1');
h2 = sigmoide([ones(m, 1) h1] * Theta2');

p = round(h2);

end
