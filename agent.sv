// The following items need to be edited:
// - myDriver driver
// - mySequencer sequencer
// - myMonitor monitor



class myAgent extends uvm_agent;
  //declaring agent components
  myDriver    driver;
  mySequencer sequencer;
  myMonitor   monitor;

  // UVM automation macros for general components
  `uvm_component_utils(myAgent)

  // constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(get_is_active() == UVM_ACTIVE) begin
      driver = myDriver::type_id::create("driver", this);
      sequencer = mySequencer::type_id::create("sequencer", this);
    end

    monitor = myMonitor::type_id::create("monitor", this);
  endfunction : build_phase

  // connect_phase
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : myAgent
