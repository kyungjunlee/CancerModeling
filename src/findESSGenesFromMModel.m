function [ essGenes ] = findESSGenesFromMModel( model, bmDropRatio )

% Find essential genes from metabolic model

optSol = optimizeCbModel(model);
optBM = optSol.f;
% 
for i = 1:length(model.genes)
  modelC = model;
  %NOTE: not working as expected
%   inds = ones(size(model.genes));
%   inds(i) = 0;
%   for j = 1:length(model.rxns)
%       vv(j) = evalExpRule2(model.rules{j}, inds);
%   end
%   modelC.ub(vv==0) = 0;
%   modelC.lb(vv==0) = 0;
  % just use the rxnGeneMat for now
  r = find(model.rxnGeneMat(:,i));
  modelC.ub(r) = 0;
  modelC.lb(r) = 0;
  FBAsol(i) = optimizeCbModel(modelC);
  sol(i) = FBAsol(i).f;
end


essGeneIdx = unique(model.genes_unique_map(find(sol < (optBM * (1 - bmDropRatio)))));
essGenes = model.genes_unique_names(essGeneIdx);

end

