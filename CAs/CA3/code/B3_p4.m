

features = diabetesvalidation(:, 1:end-1);

true_labels = diabetesvalidation(:, end);
true_labels = table2array(true_labels);


accuracy = sum(predictions == true_labels) / length(true_labels) * 100;
fprintf('دقت مدل: %.2f%%\n', accuracy);




