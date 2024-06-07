// The following items need to be edited:
// - mySeq_item
// - virtual task run_phase(uvm_phase phase);
//     --- comparision logic ---    
//   endtask : run_phase



class myScoreboard extends uvm_scoreboard;

  `uvm_component_utils(myScoreboard)
  uvm_analysis_imp#(mySeq_item, myScoreboard) item_collected_export;

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
  endfunction: build_phase
  
  // write
  virtual function void write(mem_seq_item pkt);
    $display("SCB:: Pkt recived");
    pkt.print();
  endfunction : write

  // run phase
  virtual task run_phase(uvm_phase phase);
    --- comparision logic ---    
  endtask : run_phase
endclass : mem_scoreboard
