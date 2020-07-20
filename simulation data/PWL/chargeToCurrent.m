
function [] = chargeToCurrent(nfiles)
  for i = [1:nfiles]
    try
      forg = fopen(sprintf('PWL_CurrentSource_%d.txt',i),'r');
      fedt = fopen(sprintf('PWL_Current_%d.txt',i),'w');
      line = fgetl(forg);
      sizes = [5,4.75,5.25,5,5,5,5]*1E-9;
      i = 0;
      while line!= 1
        i += 1;
        bin_size = sizes(i);
        sp = (find(line==' '))(1);
        tail = line(sp+1:end);
        tail = tail(logical(!all((tail'!='0123456789.')')));
        line = [line(1:sp-2),' -',sprintf('%fu',1E6*1E-15*str2num(tail)/bin_size)];
        fprintf(fedt,[line,'\n']);
        line = fgetl(forg);
      end
    catch
      fclose(forg);
      fclose(fedt);
      pause(0.1);
    end
  end
end
