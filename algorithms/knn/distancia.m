function D = distancia(x, X)
  c = 3;
  [m,n] = size(X);
  D = zeros(m,1);
  for i = 1:m
    D(i) = sqrt(sum( (x - X(i)) .^ 2)); % euclidean distance
    %D(i) = sum( sign((x - X(i))) .* (x - X(i)) ); % manhattan
    %D(i) = (sum( (sign((x - X(i))) .* (x - X(i))).^c ))^(1/c); % Minkowski
  endfor
end
