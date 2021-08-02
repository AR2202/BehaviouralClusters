function tests = clustermembersTest
tests = functiontests(localfunctions);
end


%this is the general test for the function
function test_clustermembers(testCase)

load(fullfile('../testdata','clustermemberstest.mat'),'frac','absolute','frac_genotype');
expSolution_frac=frac;
expSolution_abs=absolute;
expSolution_frac_genotype=frac_genotype;


clustermembers(fullfile('../testdata','testdata.mat'),'out',false,true)

load(fullfile('clustermembersout.mat'),'frac','absolute','frac_genotype');
actSolution_frac=frac;
actSolution_abs=absolute;
actSolution_frac_genotype=frac_genotype;

verifyEqual(testCase,actSolution_frac,expSolution_frac);
verifyEqual(testCase,actSolution_abs,expSolution_abs);
verifyEqual(testCase,actSolution_frac_genotype,expSolution_frac_genotype);


delete *out.eps
delete clustermembersout.mat

close all;
clearvars;

end
