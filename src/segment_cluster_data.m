function segmented_data = segment_cluster_data(data, framesPerFly,...
    numfeatures, maxchangepts, avg_pts, downsample_intv)
numfeatures = min(numfeatures, size(data, 2));


numflies = length(data) / framesPerFly;
segmented_data = [];
changepoints = zeros(numflies, maxchangepts+1);
colmin = min(data(:, 1:numfeatures));
colmax = max(data(:, 1:numfeatures));
rescaled = rescale(data(:, 1:numfeatures), 'InputMin', colmin, ...
    'InputMax', colmax);


for i = 1:numflies
    tmp_data = rescaled((i - 1)*framesPerFly+1:i*framesPerFly, :);
    moving_av = movmean(tmp_data, avg_pts);
    downsampled = downsample(moving_av, downsample_intv);
    downsampled = transpose(downsampled);

    ipt = findchangepts(downsampled, 'MaxNumChanges', maxchangepts);
    ipt = [ipt, ceil(framesPerFly/downsample_intv)];

    changepoints(i, 1:length(ipt)) = ipt;

end
%maxlength = max(max(diff(changepoints, 2)));
maxlength = round(median(median(diff(changepoints, 1,2))));

for i = 1:numflies
    tmp_data = rescaled((i - 1)*framesPerFly+1:i*framesPerFly, :);
     moving_av = movmean(tmp_data, avg_pts);
    downsampled = downsample(moving_av, downsample_intv);
    genotype = data(i * framesPerFly,end);
    changepoints_tmp = changepoints(i, :);
    changepoints_tmp = changepoints_tmp(changepoints_tmp > 0);

    numchangepoints = length(changepoints_tmp);
    segmented_tmp = zeros(numchangepoints, maxlength*size(downsampled, 2)+4);
    last = 1;
    for j = 1:numchangepoints
        eventlength = min(maxlength,changepoints_tmp(j) - last);
        for k = 1:size(downsampled, 2)
            segmented_tmp(j, (k - 1)*maxlength+1:(k - 1)*maxlength + eventlength) = ...
                downsampled(last:last+eventlength-1, k);
            segmented_tmp(j, end-3) = genotype;
            segmented_tmp(j, end-2) = i;
            segmented_tmp(j, end-1) = (last - 1) * downsample_intv + 1;
            segmented_tmp(j, end) = (changepoints_tmp(j) - 2) * downsample_intv + 1;
        end
        last = changepoints_tmp(j);
    end


    segmented_data = vertcat(segmented_data, segmented_tmp);
end