function dc = dice_of_cell_array(gt, pred)

ln = numel(gt);
% dc = zeros(ln,1);
c=1;
for i=1:ln
dc(c) = dice(gt{i}==1,pred{i}==1);
c=c+1;
end

disp(['mean: ' num2str(mean(dc)) ', std: ' num2str(std(dc))]);

end