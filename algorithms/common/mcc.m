function mcc = mcc(tp, fp, fn, tn)
  mcc = ((tp * tn) - (fp * fn)) / sqrt((tp + fp) * (tp + fn) * (tn + fp) * (tn + fn));
end
