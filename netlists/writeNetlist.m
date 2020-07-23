%writes to a text file in the format of an LTspice netlist

function [] = writeNetlist(n_cells,file_name,use_filter,pm)
%n_cells is the number of delay line cells.  file_name must come in the format of ('___.cir')
%pm is a struct detailing parameters of the circuit. All elements must be strings.
%pm: [V,R,L,C,PC] -> [input voltage,cell resistance,cell inductance,cell capacitance,parallel (parasitic) capacitance]
%the struct may be omitted from the function call, in which case a default set of values will be used

  if ~exist('pm')
    pm.V = 'V1 1 0 PULSE(0 1 0 7.5n 7.5n 100n 1 1)';
    pm.Ri = '0.17';
    pm.Ro = '220';
    pm.L = '290n';
    pm.C = '6.8p';
    pm.PC = '0';
  end

  netlist = [sprintf('*Auto-gererated %d-cell delay line circuit\n\n',...
       n_cells),pm.V];
  counts = [1 0 0]; %[C, L, Ri]
  nodes = [[1:2:2*n_cells-1],-1]; %node -1 will represent output
  
  for node = nodes(1:end-1)
    counts += 1;
    C = sprintf(['\nC%d %d 0 ',pm.C,' Cpar = ',pm.PC],counts(1),node);
    L = sprintf(['\nL%d %d %d ',pm.L],counts(2),node,node+1);
    Ri = sprintf(['\nR%d %d %d ',pm.Ri],counts(3),node+1,nodes(counts(1))); %re-using counts b/c it is already 1 index ahead of node
    netlist = [netlist,C,L,Ri];
  end
  counts += 1;
  
  if use_filter
    netlist = [netlist,sprintf(['\nC%d -1 0 ',pm.C,' Cpar = ',pm.PC,'\nR%d -1 0 ',pm.Ro,...
        '\nRf0 f1 -1 0.1m\nRf1 f3 0 1\nEf1 f3 0 f8 f2 10k\n',...
        'Rf2 f3 f2 5\nRf3 f2 0 10\nRf4 f8 f7 300\nCf1 f8 0 6.8p\nCf2 f7 0 6.8p\n',...
        'Rf5 f7 f1 300\nRf6 f-1 0 1\nEf2 f-1 0 f5 f6 10k\nRf7 f-1 f6 5\n',...
        'Rf8 f6 0 10\nRf9 f5 f4 300\nCf3 f5 0 6.8p\nCf4 f4 0 6.8p\nRf10 f4 f3 300',...
        '\n\n.tran %dn'],counts(1),counts(3),200+ceil((100/64)*n_cells+200))];
  else
    netlist = [netlist,sprintf(['\nC%d -1 0 ',pm.C,' Cpar = ',pm.PC,'\nR%d -1 0 ',pm.Ro,...
      '\n\n.tran %dn'],counts(1),counts(3),200+ceil((100/64)*n_cells+200))];
  end
      
  fID = fopen(['C:\Users\zOob\Documents\SB REU\LTspice\netlists_\',file_name],'w');
  fprintf(fID,netlist);
  fclose(fID);
  
end
