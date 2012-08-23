function d=test_parfor(a)
matlabpool open
test_parfor2;
parfor i=1:b
    d(i)=i;
end
