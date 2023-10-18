function [cellout,dataout] = helperTransformToTrainData(data,numPoints,info,...
    labelIDs,classNames)
if ~iscell(data)  
    data = {data};
end
numObservations = size(data,1);  
cellout = cell(numObservations,2); 
dataout = cell(numObservations,2); 
for i = 1:numObservations 
    classification = info.PointAttributes(i).Classification; 

    % Use the helperDownsamplePoints function, attached to this example as a
    % supporting file, to extract a downsampled point cloud and its labels
    % from the dense point cloud.
    [ptCloudOut,labelsOut] = helperDownsamplePoints(data{i,1}, ...
    classification,numPoints);

    % Make the spatial extent of the dense point cloud and the sparse point
    % cloud same.
    limits = [ptCloudOut.XLimits;ptCloudOut.YLimits;...
                    ptCloudOut.ZLimits];
    ptCloudSparseLocation = ptCloudOut.Location;
    ptCloudSparseLocation(1:2,:) = limits(:,1:2)';
    ptCloudSparseUpdated = pointCloud(ptCloudSparseLocation, ...
        'Intensity',ptCloudOut.Intensity, ...
        'Color',ptCloudOut.Color, ...
        'Normal',ptCloudOut.Normal);

    % Use the helperNormalizePointCloud function, attached to this example as
    % a supporting file, to normalize the point cloud between 0 and 1.    
    ptCloudOutSparse = helperNormalizePointCloud( ...
        ptCloudSparseUpdated);
    cellout{i,1} = ptCloudOutSparse.Location;

    % Permuted output.
    cellout{i,2} = permute(categorical(labelsOut,labelIDs,classNames),[1 3 2]);

    % General output.
    dataout{i,1} = ptCloudOutSparse;
    dataout{i,2} = labelsOut;
end
end
