function makeDataFileFlatImages
yy = 0.5;
NImages = 1000;
imageSize = 31;
centerSize = 11;
mm = [0.001 1]; % Intensity variation scale

xx = reshape(repmat(reshape(repmat([0.1:0.1:1], 100,1),1,[]), ...
    centerSize*centerSize,1),centerSize,centerSize,NImages);
imageMatrix = yy*ones(imageSize,imageSize,NImages);
imageMatrix(centerSize:centerSize+10, centerSize:centerSize+10, :) = xx;
imageMatrix = reshape(imageMatrix,imageSize*imageSize,NImages);

scales = 10.^(log10(mm(1)) + (log10(mm(2))-log10(mm(1))) * rand(1,NImages));
scales = repmat(scales,imageSize*imageSize,1);

imageMatrix = imageMatrix.*scales;


fid = fopen(fullfile('/Users/julian/Documents/masteringMachineLearning/',...
    'FlatImageFull.csv'),'w');
for jj = 1:size(imageMatrix,2)
    for ii = 1:size(imageMatrix,1)
        fprintf(fid,'%3.6f ',imageMatrix(ii,jj));
    end
    fprintf(fid,'%3.6f\n', squeeze(xx(1,1,jj)));
end

end