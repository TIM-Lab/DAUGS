function gt = get_gt(dataset, gt_folder)

ls = dir([pwd filesep dataset filesep gt_folder]);

if isequal(ls(3).name, '.DS_Store')
    ind = 3;
else
    ind = 2;
end

for i=1:length(ls)-ind

    gt{i}=load([pwd filesep dataset filesep gt_folder filesep ls(i+2).name]).final_mask; 
    
end

end