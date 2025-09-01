clear;
clc;

%% AIMSC demo for UCI dataset
addpath('./ClusteringMeasure');
dataset = './Datasets/UCI.mat';
load(dataset);

numClust = length(unique(gt));
num_views = 3;

data{1} = X1;
data{2} = X2;
data{3} = X3;

for k = 1:3
    data{k} = data{k}./(repmat(sqrt(sum(data{k}.^2,1)),size(data{k},1),1)+1e-8);
end

nSmp = size(data{1},2);

Max_iter = 4;

fid = fopen('./Results/results_UCI.txt','a');
fprintf(fid,'\t This demo is based on UCI dataset\n');
fclose(fid);

alpha=1000;
gamma=-3;
num_anchor = 3*numClust;

rng(3);
B = ConstructBipartiteGraph(data,nSmp,num_views,num_anchor,18);
tic;
R = AIMSC(B, numClust, Max_iter, alpha, gamma);
% Final kmeans
pre_result=litekmeans(R,numClust,'MaxIter',100,'Replicates',10);
t_time = toc;

NMI = nmi(pre_result,gt);
Purity = purity(gt, pre_result);
ACC = Accuracy(pre_result,double(gt));
[Fscore,Precision,~] = compute_f(gt,pre_result);

fprintf("time %f\n", t_time);
fprintf("results: NMI: %f, ACC: %f, Purity: %f, Fscore: %f, Precision: %f\n", NMI, ACC, Purity, Fscore, Precision);

fid = fopen('./Results/results_UCI.txt','a');
fprintf(fid,'\t NMI: %f, ACC: %f, Purity: %f, Fscore: %f, Precision: %f, time: %f\n',NMI, ACC, Purity, Fscore, Precision, t_time);
fclose(fid);
