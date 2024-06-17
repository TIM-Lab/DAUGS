function dc = dice_of_cell_array(gt, pred)

ln = numel(gt);
% dc = zeros(ln,1);
c=1;
for i=1:ln%[13,14,15,16,17,18,46,47,48,49,50,51,74,75,76,77,78,79,80,81,82,83,84,85,107,108,109]%1:ln
dc(c) = dice(gt{i}==1,pred{i}==1);
c=c+1;
end

disp(['mean: ' num2str(mean(dc)) ', std: ' num2str(std(dc))]);

end