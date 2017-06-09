function MCC = mcc(tp, fp, fn, tn)

if sqrt((tp + fp) * (tp + fn) * (tn + fp) * (tn + fn)) == 0
	MCC = 0;
else
	MCC =  ((tp * tn) - (fp * fn)) / sqrt((tp + fp) * (tp + fn) * (tn + fp) * (tn + fn));
end

end
