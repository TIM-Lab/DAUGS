function [preds, dc] = predictSeg(im_folder, lbl_folder, ntw_path, ntw_param)

disp_name = ntw_param;
decision_rule = 'prob-avg'; % 'prob-avg' (probability average) or 'major-vote' (majority vote), specify decision rule for patch-level networks

img_size = 128; % each spatial dimensions of the images
Myo_fld_area = 250; % remove areas smaller than 400 pixels in the myo predictions using morphological operations
RV_fld_area = 200; % remove areas smaller than 200 pixels in the RV predictions using morphological operations

% Path 
imgLocTest = im_folder;
lblLocTest = lbl_folder;

[gt, raw_pred_adv] = prediction(ntw_path, ntw_param, imgLocTest, lblLocTest, true);
[preds, ~, dc, ~, ~, ~, ~, ~] = ...
                predict_postprocess(raw_pred_adv, gt, img_size, disp_name, 64, 25, Myo_fld_area, RV_fld_area, true, 'myo', decision_rule);

                
end