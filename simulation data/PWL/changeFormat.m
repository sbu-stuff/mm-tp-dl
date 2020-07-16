
function [] = changeFormat(nfiles,fname)
  for i = [1:nfiles]
    forg = fopen(sprintf('PWL_CurrentSource_%d.txt',i),'r');
    fedt = fopen(sprintf('PWL_VOltageSource_%d.txt',i),'w');
    line = fgetl(forg);
    while line != -1
      keep = [];
      for c = line
        keep = [keep,!all(c!='0123456789. n')];
      end
      line = [line(logical(keep)),'m'];
      fprintf(fedt,[line,'\n']);
      line = fgetl(forg);
    end
    fclose(forg);
    fclose(fedt);
    pause(0.1);
  end
end

