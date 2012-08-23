
for z=1:Para.ZSize
    tic
    for v=1:VGridSize
      
        DelVStar(z,v,:)=VStar(z,v,:)-VGrid(z,v);
            end
    toc
end
