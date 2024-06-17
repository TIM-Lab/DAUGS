function plot_all_segs_cell_arr(cell_inp)

figure;
for i=1:numel(cell_inp)
    subplot(6,10,i); imagesc(cell_inp{i});
    axis off; axis image;
    colormap gray;
    title(num2str(i));
end

end