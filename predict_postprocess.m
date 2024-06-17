function [pred_postprocessed, pred_raw_sum, dice_myo, final_weights, uncert_map, uncert_map_er, prob_store_all_imgs, prob_store_er_all_imgs] = ...
                predict_postprocess(raw_pred, gt, img_size, ntw_type, patch_size, stride_perc, Myo_fld_area, RV_fld_area, patch_flag, seg_type, decision)

switch seg_type
    case 'myo'
        num = 2;
    case 'rv'
        num = 3;
    case 'bp'
        num = 4;
    otherwise % background
        num = 1;
end


if patch_flag
    
    stride = patch_size*stride_perc/100;
    patch_count = ceil((img_size-patch_size+1)/stride); % patch count in one dimension

    prob_tmp = zeros(img_size);
    img_inter_weight = zeros(img_size);

    count = 1;
    for i=1:patch_count*patch_count:numel(raw_pred)
        
%         display(num2str(i));
        
        prob_store = cell(img_size,img_size);
        prob_store_er = cell(img_size,img_size);
        
        for j = 1:patch_count
            for k = 1:patch_count
                
                tmp = raw_pred{i+k+(j-1)*patch_count-1};
                
                
                switch decision
                    case 'major-vote'
                        prob_tmp(1+stride*(k-1):stride*(k-1)+patch_size, ...
                                    1+stride*(j-1):stride*(j-1)+patch_size) = round(squeeze(tmp(:,:,num))); 
                    case 'prob-avg'
                        prob_tmp(1+stride*(k-1):stride*(k-1)+patch_size, ...
                                    1+stride*(j-1):stride*(j-1)+patch_size) = squeeze(tmp(:,:,num)); 
                end
                 
                
                % "er" stands for edges removed                            
                img_inter_weight(1+stride*(k-1):stride*(k-1)+patch_size, ...
                                    1+stride*(j-1):stride*(j-1)+patch_size) = 1;
                                
                er_filter = zeros(img_size);
                
                er_filter(1+stride*(k-1)+5:stride*(k-1)+patch_size-1, ...
                                    1+stride*(j-1)+5:stride*(j-1)+patch_size-1) = 1;
                                
                                
                for m=1:img_size
                    for n=1:img_size
                        if img_inter_weight(m,n)==1
                            tmp_cell = prob_store{m,n};
                            tmp_cell = [tmp_cell prob_tmp(m,n)];
                            prob_store{m,n} = tmp_cell;
                        end
                    end
                end

                for m=1:img_size
                    for n=1:img_size
                        if er_filter(m,n)==1
                            tmp_cell = prob_store_er{m,n};
                            tmp_cell = [tmp_cell prob_tmp(m,n)];
                            prob_store_er{m,n} = tmp_cell;
                        end
                    end
                end


                img_pre{k+(j-1)*patch_count} = prob_tmp;
                
                img_weight{k+(j-1)*patch_count} = img_inter_weight;
                                
                prob_tmp = zeros(img_size);
                img_inter_weight = zeros(img_size);
                                
            end
        end
        
        img_final = zeros(img_size);
        final_weights = zeros(img_size);

        for m=1:patch_count^2
            img_final = img_final+img_pre{m};
            final_weights = final_weights + img_weight{m};
        end
        
        std_map = zeros(img_size, img_size);
        for m=1:img_size
            for n=1:img_size
                tmp = prob_store{m,n};
                std_map(m,n)=std(tmp);
            end
        end
        
        
        std_map_er = zeros(img_size, img_size);
        for m=1:img_size
            for n=1:img_size
                tmp = prob_store_er{m,n};
                std_map_er(m,n)=std(tmp);
            end
        end
        
        
        
        uncert_map{count} = std_map; %#ok<*AGROW>
        uncert_map_er{count} = std_map_er;
        pred_raw_sum{count} = img_final./final_weights;
        pred_raw_sum_rounded{count} = round(img_final./final_weights);
        
        prob_store_all_imgs{count} = prob_store;
        prob_store_er_all_imgs{count} = prob_store_er;
        
        count = count+1;
    end
    
    [pred_postprocessed, dice_myo] = CalculateAndDisplayDice(gt, pred_raw_sum_rounded, ntw_type, RV_fld_area, Myo_fld_area, patch_flag); 

else

    pred_raw_sum=raw_pred;
    [pred_postprocessed, dice_myo] = CalculateAndDisplayDice(gt, raw_pred, ntw_type, RV_fld_area, Myo_fld_area, patch_flag); 
    final_weights = {};
    uncert_map ={};
    uncert_map_er ={};
    prob_store_all_imgs = {};
    prob_store_er_all_imgs = {};
%     hd = zeros(1,90);
end

end