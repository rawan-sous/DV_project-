// The following items used from out classes:
// - comp_decomp_seq_item

// The following items need to be edited:
// - virtual task run_phase(uvm_phase phase);
//     --- comparision logic ---    
//   endtask : run_phase



class comp_decomp_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(comp_decomp_scoreboard)
  uvm_analysis_imp#(comp_decomp_seq_item, comp_decomp_scoreboard) item_collected_export;

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
  endfunction: build_phase
  
  // write
  virtual function void write(comp_decomp_seq_item pkt);
    $display("SCB:: Pkt recived");
    pkt.print();
  endfunction : write

  // run phase
  virtual task run_phase(uvm_phase phase);
    --- comparision logic ---    
  endtask : run_phase
endclass : comp_decomp_scoreboard
