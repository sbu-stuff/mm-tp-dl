
function [] = wnPWL_i(nfiles,pm,fname,ncells)
  for i = [1:nfiles]
    pm.V = ['I1 1 0 PWL file="C:\\Users\\zOob\\Documents\\SB REU\\LTspice\\data\\',...
        sprintf('PWL_Current_%d.txt',i),'"'];
    writeNetlist(ncells,sprintf([fname,'_%d.cir'],i),true,pm);
    pause(0.1);
  end
end