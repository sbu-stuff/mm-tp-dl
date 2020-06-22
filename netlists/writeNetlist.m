%writes to a text file in the format of an LTspice netlist

function [] = writeNetlist(n_cells,file_name,pm)
%n_cells is the number of delay line cells.  file_name must come in the format of ('___.cir')
%pm is a struct detailing parameters of the circuit. All elements must be strings.
%pm: [V,R,L,C,PC] -> [input voltage,cell resistance,cell inductance,cell capacitance,parallel (parasitic) capacitance]
%the struct may be omitted from the function call, in which case a default set of values will be used

  if ~exist('pm')
    pm.V = 'PULSE(0 1 0 7.5n 7.5n 100n 1 1)';
    pm.R = '0.17';
    pm.L = '290n';
    pm.C = '6.8p';
    pm.PC = '0';
  end

  netlist = sprintf(['*Auto-gererated %d-cell delay line circuit\n\nV1 1 0 ',pm.V,...
      '\nR1 1 0 220'],n_cells);
  counts = [1 1 2]; %[C, L, R]
  nodes = [[1:2:2*n_cells-1],-1]; %node -1 will represent output
  
  for node = nodes(1:end-1)
    counts += 1;
    C = sprintf(['\nC%d %d 0 ',pm.C,' Cpar = ',pm.PC],counts(1),node);
    L = sprintf(['\nL%d %d %d ',pm.L],counts(2),node,node+1);
    R = sprintf(['\nR%d %d %d ',pm.R],counts(3),node+1,nodes(counts(1))); %re-using counts b/c it is already 1 index ahead of node
    netlist = [netlist,C,L,R];
  end
  
  counts += 1;
  netlist = [netlist,sprintf(['\nC%d -1 0 ',pm.C,' Cpar = ',pm.PC,'\nR%d -1 0 220',...
      '\nR%d -1 0 1E6\nC%d -1 0 25p\n\n.tran %dn'],...
      counts(1),counts(3),counts(3)+1,counts(1)+1,200+ceil((100/64)*n_cells))];
      
  fID = fopen(file_name,'w');
  fprintf(fID,netlist);
  fclose(fID);
  
end
