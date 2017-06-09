function g = gradienteSigmoide(z)

g = sigmoide(z) .* (1 - (sigmoide(z)));

end
