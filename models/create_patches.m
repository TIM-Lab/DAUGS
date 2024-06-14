function create_patches(patch_size, im_size, stride, ind, img_path, lbl_path, basepath, img_patch, lbl_patch)

    patch_count = ceil((im_size(1)-patch_size(1)+1)/stride(1)); % patch count in one dimension

    parfor i=3:length(ind)
        disp(i);
       
        final_img = load([img_path ind(i).name]).final_img;
        final_mask = load([lbl_path ind(i).name]).final_mask;

        for j = 1:patch_count
            for k = 1:patch_count

                temp_img = final_img(1+stride(1)*(k-1):stride(1)*(k-1)+patch_size(1), ...
                                    1+stride(2)*(j-1):stride(2)*(j-1)+patch_size(2), :);
                img_loc = [basepath img_patch ind(i).name(1:end-4) '_Patch' num2str((j-1)*patch_count+k+100000) '.mat']; % add 100000 to the file name to easily read the patches from the file later.
                parsave_img(img_loc, temp_img);

                temp_lbl = final_mask(1+stride(1)*(k-1):stride(1)*(k-1)+patch_size(1), ...
                                    1+stride(2)*(j-1):stride(2)*(j-1)+patch_size(2),:);
                lbl_loc = [basepath lbl_patch ind(i).name(1:end-4) '_Patch' num2str((j-1)*patch_count+k+100000) '.mat'];
                parsave_lbl(lbl_loc, temp_lbl);

            end
        end
    end

end