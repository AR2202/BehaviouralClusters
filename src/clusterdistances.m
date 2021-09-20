function clusternumbers = clusterdistances(centroids_pca_rep, k)

first_run = centroids_pca_rep(:, :, 1);
numclusters = size(centroids_pca_rep, 1);
numclosest = k;
numruns = size(centroids_pca_rep, 3);
closest = zeros(numclosest, numclusters, (numruns - 1));
clusternumbers = zeros(numclusters, numruns);
clusternumbers(:, 1) = 1:numclusters;

for i = 2:size(centroids_pca_rep, 3)
    Y = centroids_pca_rep(:, :, i);
    %find the 'numclosest' clusters in first_run with the smallest centroid distance to clusters in
    %the ith run
    [~, closest_clusters] = pdist2(first_run, Y, 'euclidean', 'Smallest', numclosest);
    closest(:, :, i-1) = closest_clusters;
    clusternumbers(:, i) = closest_clusters(1, :);
    uniques = unique(closest_clusters(1, :));
    for j = 1:numel(uniques)
        duplicate_ind = find(closest_clusters(1, :) == uniques(j));
        numduplicates = size(duplicate_ind, 2);
        if size(duplicate_ind, 2) > 1
            duplicates = closest_clusters(:, duplicate_ind);
            for c = 2:numclosest

                for d = 1:size(duplicate_ind, 2)
                    if numduplicates > 1

                        next_closest = duplicates(c, d);

                        if ~ismember(uniques, next_closest)


                            uniques = [uniques, next_closest];

                            %fprintf('replacing %d with %d at index %d in run %d', clusternumbers(duplicate_ind(d),i),  next_closest, duplicate_ind(d),  i);
                            clusternumbers(duplicate_ind(d), i) = next_closest;
                            numduplicates = numduplicates - 1;

                        else

                        end
                    end
                end
            end
        end
    end
end