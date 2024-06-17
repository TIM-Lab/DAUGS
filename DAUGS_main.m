% set variables
addpath([pwd '/utils'])

test_set = 'data';
img_path = [pwd filesep test_set filesep 'Images' filesep];
lbl_path = [pwd filesep test_set filesep 'Labels' filesep];

ntw_path = [pwd filesep 'models' filesep];

im_size = [128 128 30];
patch_size = [64 64 30];
ind = dir(img_path);

% create patches for segmentation prediction w/ 25% overlap
seg_patch_folder = 'seg_img_patches';
stride = [patch_size(1)/4 patch_size(1)/4];
save_path_seg = [pwd filesep test_set filesep seg_patch_folder filesep];
if ~exist([pwd filesep test_set filesep seg_patch_folder],'dir')
    mkdir([pwd filesep test_set filesep seg_patch_folder]);
end
create_patches(patch_size, im_size, stride, ind, img_path, save_path_seg);

% create patches for U-map prediction w/ 3% overlap
umap_patch_folder = 'umap_img_patches';
stride = [patch_size(1)/32 patch_size(1)/32];
save_path_um = [pwd filesep test_set filesep umap_patch_folder filesep];
if ~exist([pwd filesep test_set filesep umap_patch_folder],'dir')
    mkdir([pwd filesep test_set filesep umap_patch_folder]);
end
create_patches(patch_size, im_size, stride, ind, img_path, save_path_um);

% inference 
ntw_dir = dir(ntw_path);
ntw_count = numel(ntw_dir)-2;
dt_size = dir(img_path);

for i=1:numel(ntw_dir)-2
    nm = ntw_dir(i+2).name(1:end-4);
    seg = predictSeg(save_path_seg, lbl_path, ntw_path, nm);
    um = predictUncertaintyMap(save_path_um, lbl_path, ntw_path, nm);
    for j=1:numel(dt_size)-2
        U_pp(j) = norm(um{j},"fro")^2/sum(sum(seg{j}));
    end
    save([pwd filesep 'preds' filesep nm], 'seg', 'um', 'U_pp');
end

% start DAUGS analysis 

gt = get_gt(test_set,'Labels');
dataset_dir = dir(img_path);

U_pp =[];
for j=1:ntw_count
    U_pp = [U_pp; load([pwd filesep 'preds' filesep ntw_dir(j+2).name], 'U_pp').U_pp];
end

[~, ind_U_pp] = min(U_pp);

for i=1:numel(dataset_dir)-2

seg = load([pwd filesep 'preds' filesep ntw_dir(ind_U_pp(i)+2).name], 'seg').seg;
um = load([pwd filesep 'preds' filesep ntw_dir(ind_U_pp(i)+2).name], 'um').um;
chosen_pred_Upp{i} = seg{i};
chosen_um_Upp{i} = um{i};

end

plot_all_segs_cell_arr(chosen_pred_Upp)
dice_of_cell_array(gt,chosen_pred_Upp);

