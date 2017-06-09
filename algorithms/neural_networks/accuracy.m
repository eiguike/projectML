function acc = accuracy(tp, fp, fn, tn)

acc = (tp + tn) / (tp + fp + fn + tn);

end
