function segmented_data = segment_cluster_data(data, framesPerFly, maxchangepts)
%data need to be normalized/scaled first
numflies = length(data) / framesPerFly;
segmented_data = [];
changepoints = zeros(numflies, maxchangepts+1);
for i = 1:numflies
    tmp_data = transpose(data((i - 1)*framesPerFly+1:i*framesPerFly, :));
    ipt = findchangepts(tmp_data, 'MaxNumChanges', maxchangepts);
    ipt = [ipt, framesPerFly];

    changepoints(i, 1:length(ipt)) = ipt;

end
maxlength = max(max(diff(changepoints, 2)));

for i = 1:numflies
    tmp_data = data((i - 1)*framesPerFly+1:i*framesPerFly, :);
    changepoints_tmp = changepoints(i, :);
    changepoints_tmp = changepoints_tmp(changepoints_tmp > 0);

    numchangepoints = length(changepoints_tmp);
    segmented_tmp = zeros(numchangepoints, maxlength*size(data, 2)+3);
    last = 1;
    for j = 1:numchangepoints
        eventlength = changepoints_tmp(j) - last;
        for k = 1:size(data, 2)
            segmented_tmp(j, (k - 1)*maxlength+1:(k - 1)*maxlength + eventlength) = ...
                tmp_data(last:changepoints_tmp(j)-1, k);
            segmented_tmp(j, end-2) = i;
            segmented_tmp(j, end-1) = last;
            segmented_tmp(j, end) = changepoints_tmp(j) - 1;
        end
        last = changepoints_tmp(j);
    end


    segmented_data = vertcat(segmented_data, segmented_tmp);
end