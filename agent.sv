// The following items used from out classes:
  // comp_decomp_driver    driver;
  // comp_decomp_sequencer sequencer;
  // comp_decomp_monitor   monitor;
`include "comp_decomp_seq_item.sv"	
`include "comp_decomp_sequencer.sv"
`include "comp_decomp_sequence.sv"
`include "comp_decomp_driver.sv"	
`include "comp_decomp_monitor.sv"	


class comp_decomp_agent extends uvm_agent;
  //declaring agent components
  comp_decomp_driver    driver;
  comp_decomp_sequencer sequencer;
  comp_decomp_monitor   monitor;

  // UVM automation macros for general components
  `uvm_component_utils(comp_decomp_agent)

  // constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(get_is_active() == UVM_ACTIVE) begin
      driver = comp_decomp_driver::type_id::create("driver", this);
      sequencer = comp_decomp_sequencer::type_id::create("sequencer", this);
    end

    monitor = comp_decomp_monitor::type_id::create("monitor", this);
  endfunction : build_phase

  // connect_phase
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : comp_decomp_agent
