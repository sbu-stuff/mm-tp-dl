

function [] = wnPWL(nfiles,pm,fname,ncells)
  for i = [1:nfiles]
    pm.V = ['PWL file="C:\\Users\\zOob\\Documents\\SB REU\\LTspice\\data\\',...
        sprintf('PWL_VoltageSource_%d.txt',i),'"'];
    writeNetlist(ncells,sprintf([fname,'_%d.cir'],i),pm);
    pause(0.1);
  end
end
