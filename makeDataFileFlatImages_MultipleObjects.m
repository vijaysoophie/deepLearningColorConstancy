function makeDataFileFlatImages_MultipleObjects

lightnessLevels = 0.1:0.1:1;
NImages = 1000;
NObjects = 4;
mm = [0.001 1]; % Intensity variation scale

imageVals = rand(NImages, NObjects);
% imageVals = repmat(imageVals,NImages,1);
xx = reshape(repmat(lightnessLevels, NImages/length(lightnessLevels),1),[],1);

imageMatrix = [imageVals xx];
imageMatrix = repmat(imageMatrix, 1, 100)';

scales = 10.^(log10(mm(1)) + (log10(mm(2))-log10(mm(1))) * rand(1,NImages));
scales = repmat(scales, size(imageMatrix,1),1);

imageMatrix = imageMatrix.*scales;


fid = fopen(fullfile('/Users/julian/Documents/masteringMachineLearning/',['FlatImageFull_',...
    num2str(NObjects),'_Objects_DistinctBackground.csv']),'w');
for jj = 1:size(imageMatrix,2)
    for ii = 1:size(imageMatrix,1)
        fprintf(fid,'%3.6f ',imageMatrix(ii,jj));
    end
    fprintf(fid,'%3.6f\n', squeeze(xx(jj)));
end

end