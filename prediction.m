function [gt, raw_pred] = prediction(path, ntw_type, volLocTest, lblLocTest, patch_flag)

volReader = @(x) matRead(x);

switch patch_flag
    case true
        voldsTest = imageDatastore([volLocTest], ...
            'FileExtensions','.mat','ReadFcn',volReader);
    otherwise
        voldsTest = imageDatastore(volLocTest, 'FileExtensions','.mat','ReadFcn', volReader);
end

% classNames = ["background","myocardium", "rv", "bloodpool"];
% pixelLabelID = [0 1 2 3];
classNames = ["background","myocardium"];
pixelLabelID = [0 1];

pxdsTest = pixelLabelDatastore(lblLocTest,classNames,pixelLabelID, 'FileExtensions','.mat','ReadFcn',volReader);
net = load([path ntw_type '.mat']).net;



% id = 1;
parfor id=1:numel(voldsTest.Files)
    if rem(id,1000)==1 && id>10000 && patch_flag
        disp(['Processing test volume ' num2str(id)]);
    elseif  rem(id,10)==1 && ~patch_flag
        disp(['Processing test volume ' num2str(id)]);
    end
    
    if patch_flag
        raw_pred{id} = squeeze(activations(net,load(voldsTest.Files{id}).temp_img,'Softmax-Layer')); %#ok<*AGROW>
    else
        t = activations(net,load(voldsTest.Files{id}).final_img,'Softmax-Layer');
        raw_pred{id} = round(squeeze(t(:,:,2)));
        
    end
end
    

id=1;
parfor id=1:numel(pxdsTest.Files)
%     disp(['Processing test volume ' num2str(id)]);

   
gt{id} = load(pxdsTest.Files{id}).final_mask; 
end


end