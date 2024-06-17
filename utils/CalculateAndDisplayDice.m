function [pred_postprocessed, dice_myo] = CalculateAndDisplayDice(gt, pred, type, RV_fld_area, Myo_fld_area, patch_flag) 

num = numel(gt);
pred_postprocessed = cell(1,numel(gt));
dice_myo = zeros(1,numel(gt));

for j = 1:num
    
    tmp = zeros(size(gt{1},1),size(gt{1},2));
    tmp1 = double(gt{j});
    
    if patch_flag

        only_myo = (uint8(round(pred{j})))==1;

        only_rv = (uint8(round(pred{j})))==2;
        if isequal(type, 'patch_noiseaffint')
            bp = imfill(only_myo,'holes')-only_myo;
            sm = sum(bp(:));
            
            if sm==0
                only_myo = (uint8(pred{j}>0.4))==1;
            end
        end
        
    else
        only_myo = (uint8(round(double(pred{j}))))==1;
        only_rv = (uint8(round(double(pred{j}))))==2;
    end
    
    only_rv = bwpropfilt(only_rv,'FilledArea',[RV_fld_area size(gt{1},1)*size(gt{1},2)]);
    
    tmp(only_myo==1) = 1;
    tmp(only_rv==1) = 2;
%     tmp(find(only_bp==1)) = 3;
    dice_myo(j) =  dice(tmp1==1,tmp==1);
    
    pred_postprocessed{j} = tmp;
end
disp(type);
disp(['Myo dice: ', num2str(mean(dice_myo))]);

end