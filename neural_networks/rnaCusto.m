function [J grad] = rnaCusto(nn_params, input_layer_size, hidden_layer_size, X, y, lambda)

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), 1, (hidden_layer_size + 1));

m = size(X, 1);

DELTA2 = 0;
DELTA1 = 0;
J = 0;

for (i = 1: m)
	x = X(i,:);
	Y = y(i,:);

	a1 = x;
	z2 = [1 a1] * Theta1';
	a2 = sigmoide(z2);

	z3 = [1 a2] * Theta2';
	a3 = sigmoide(z3);
	hTheta = a3;
	j = sum(sum((-Y .* log(hTheta)) - ((1 - Y) .* log(1 - hTheta)))) / m;
	J = J + j;

	delta3 = hTheta - Y;

	aux = (Theta2' * delta3')';
	aux(:,1) = [];
	delta2 =  aux .* gradienteSigmoide(z2);

	DELTA2 = DELTA2 + delta3' * [1 a2];
	DELTA1 = DELTA1 + delta2' * [1 a1];

	Theta2_grad = DELTA2 / m;
	Theta1_grad = DELTA1 / m;
end;

	Theta1(:,1) = [zeros(size(Theta1(:,1)))];
	Theta2(:,1) = [zeros(size(Theta2(:,1)))];

	Theta1_grad = Theta1_grad + (Theta1 * lambda / m);
	Theta2_grad = Theta2_grad + (Theta2 * lambda / m);

	J = J + (lambda * (sum(sum(Theta1 .^ 2)) + sum(sum(Theta2 .^ 2)))) / (2 * m);

grad = [Theta1_grad(:) ; Theta2_grad(:)];

end
