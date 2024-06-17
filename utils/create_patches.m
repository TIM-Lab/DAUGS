function create_patches(patch_size, im_size, stride, ind, img_path, basepath)

    patch_count = ceil((im_size(1)-patch_size(1)+1)/stride(1)); % patch count in one dimension

    parfor i=3:length(ind)
        disp(i-2);
       
        final_img = load([img_path ind(i).name]).final_img;

        for j = 1:patch_count
            for k = 1:patch_count

                temp_img = final_img(1+stride(1)*(k-1):stride(1)*(k-1)+patch_size(1), ...
                                    1+stride(2)*(j-1):stride(2)*(j-1)+patch_size(2), :);
                img_loc = [basepath ind(i).name(1:end-4) '_Patch' num2str((j-1)*patch_count+k+100000) '.mat'];
                parsave_img(img_loc, temp_img);

            end
        end
    end

end