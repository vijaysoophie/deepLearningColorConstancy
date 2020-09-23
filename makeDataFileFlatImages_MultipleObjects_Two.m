function makeDataFileFlatImages_MultipleObjects_Two

lightnessLevels = 0.1:0.1:1;
NImages = 1000;
NObjects = 5;
imageSize = 31;
centerSize = 11;
mm = [0.001 1]; % Intensity variation scale

xx = reshape(repmat(reshape(repmat(lightnessLevels, NImages/length(lightnessLevels),1),1,[]), ...
    centerSize*centerSize,1),centerSize,centerSize,NImages);

imageMatrix = randi(NObjects, [imageSize,imageSize]);
imageMatrix = repmat(imageMatrix,1,1,NImages);
imageMatrix(centerSize:centerSize+10, centerSize:centerSize+10, :) = xx;
imageMatrix = reshape(imageMatrix,imageSize*imageSize,NImages);

scales = 10.^(log10(mm(1)) + (log10(mm(2))-log10(mm(1))) * rand(1,NImages));
scales = repmat(scales, size(imageMatrix,1),1);

imageMatrix = imageMatrix.*scales;


fid = fopen(fullfile('/Users/julian/Documents/masteringMachineLearning/',['FlatImageFull_',...
    num2str(NObjects),'_Objects_DistinctBackground_Square.csv']),'w');
for jj = 1:size(imageMatrix,2)
    for ii = 1:size(imageMatrix,1)
        fprintf(fid,'%3.6f ',imageMatrix(ii,jj));
    end
    fprintf(fid,'%3.6f\n', squeeze(xx(1,1,jj)));
end

end