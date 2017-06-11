function f_m = f_measure(tp, fp, fn, tn)
  prec = tp / (tp + fp);
  rec = tp / (tp + fn);
  f_m = 2 * ((prec * rec) / (prec + rec));
end
