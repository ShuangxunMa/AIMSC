function [B] = ConstructBipartiteGraph_LSC(data, nSmp, num_views, num_anchor)
% Input: 
% 
for v = 1:num_views
    rng(5489,'twister');
    [~, H{v}] = litekmeans(data{v}',num_anchor,'MaxIter', 100,'Replicates',10);
    % H: m*d. 这个landmark合集
end

% Construct the Bipartite Graph for each view
for v = 1:num_views
    D = EuDist2(data{v}',H{v},0);

    sigma = mean(mean(D));

    dump = zeros(nSmp,5);
    idx = dump;
    for i = 1:5
        [dump(:,i),idx(:,i)] = min(D,[],2);
        temp = (idx(:,i)-1)*nSmp+[1:nSmp]';
        D(temp) = 1e100; 
    end

    dump = exp(-dump/(2*sigma^2));
    sumD = sum(dump,2);
    Gsdx = bsxfun(@rdivide,dump,sumD);
    Gidx = repmat([1:nSmp]',1,5);
    Gjdx = idx;
    B{v} = sparse(Gidx(:),Gjdx(:),Gsdx(:),nSmp,num_anchor);
    % B{v} = B{v}';
    % B{v} = full(B{v});
end

% B{v}: m*n
end

