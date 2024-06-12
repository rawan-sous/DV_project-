//-------------------------------------------------------------------------
//						mem_scoreboard - www.verificationguide.com 
//-------------------------------------------------------------------------

class comp_decomp_scoreboard extends uvm_scoreboard;

  //---------------------------------------
  // Declaring pkt_qu to store the pkt's received from monitor
  //---------------------------------------
  comp_decomp_seq_item pkt_qu[$];

  //---------------------------------------
  // sc_mem - Local scoreboard memory
  //---------------------------------------
  bit [79:0] sc_mem [256]; // Updated to match the dictionary size

  //---------------------------------------
  // Port to receive packets from monitor
  //---------------------------------------
  uvm_analysis_imp#(comp_decomp_seq_item, comp_decomp_scoreboard) item_collected_export;
  `uvm_component_utils(comp_decomp_scoreboard)

  //---------------------------------------
  // new - Constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase - Create port and initialize local memory
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
    foreach(sc_mem[i]) sc_mem[i] = 80'hFFFFFFFFFFFFFFFFFFFF; // Initialize memory to a default value
  endfunction: build_phase

  //---------------------------------------
  // write function - Receives the pkt from monitor and pushes into queue
  //---------------------------------------
  virtual function void write(comp_decomp_seq_item pkt);
    pkt.print();
    pkt_qu.push_back(pkt);
  endfunction : write

  //---------------------------------------
  // run_phase - Compare's the read data with the expected data (stored in local memory)
  // local memory will be updated on the write operation.
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    comp_decomp_seq_item comp_decomp_pkt;

    forever begin
      wait(pkt_qu.size() > 0);
      comp_decomp_pkt = pkt_qu.pop_front();

      // Compare with reference model
      compare_with_ref_model(comp_decomp_pkt);

      // Handle write operation
      if (comp_decomp_pkt.wr_en) begin
        sc_mem[comp_decomp_pkt.addr] = comp_decomp_pkt.wdata;
        `uvm_info(get_type_name(), $sformatf("------ :: WRITE DATA       :: ------"), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Addr: %0h", comp_decomp_pkt.addr), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Data: %0h", comp_decomp_pkt.wdata), UVM_LOW)
        `uvm_info(get_type_name(), "------------------------------------", UVM_LOW)        
      end
      // Handle read operation
      else if (comp_decomp_pkt.rd_en) begin
        if (sc_mem[comp_decomp_pkt.addr] == comp_decomp_pkt.rdata) begin
          `uvm_info(get_type_name(), $sformatf("------ :: READ DATA Match :: ------"), UVM_LOW)
          `uvm_info(get_type_name(), $sformatf("Addr: %0h", comp_decomp_pkt.addr), UVM_LOW)
          `uvm_info(get_type_name(), $sformatf("Expected Data: %0h Actual Data: %0h", sc_mem[comp_decomp_pkt.addr], comp_decomp_pkt.rdata), UVM_LOW)
          `uvm_info(get_type_name(), "------------------------------------", UVM_LOW)
        end
        else begin
          `uvm_error(get_type_name(), "------ :: READ DATA MisMatch :: ------")
          `uvm_info(get_type_name(), $sformatf("Addr: %0h", comp_decomp_pkt.addr), UVM_LOW)
          `uvm_info(get_type_name(), $sformatf("Expected Data: %0h Actual Data: %0h", sc_mem[comp_decomp_pkt.addr], comp_decomp_pkt.rdata), UVM_LOW)
          `uvm_info(get_type_name(), "------------------------------------", UVM_LOW)
        end
      end
    end
  endtask : run_phase

  //---------------------------------------
  // Reference Model
  //---------------------------------------
  MA reference_model = new();

  //---------------------------------------
  // Compare with Reference Model
  //---------------------------------------
  task compare_with_ref_model(comp_decomp_seq_item pkt);
    // Drive inputs to the reference model
    reference_model.clk = 0;
    reference_model.reset = pkt.reset;
    reference_model.data_in = pkt.data_in;
    reference_model.compressed_in = pkt.compressed_in;
    reference_model.command = pkt.command;

    // Run one clock cycle
    #10;
    reference_model.clk = 1;
    #10;
    reference_model.clk = 0;

    // Capture outputs
    bit [7:0] ref_compressed_out = reference_model.compressed_out;
    bit [79:0] ref_decompressed_out = reference_model.decompressed_out;
    bit [1:0] ref_response = reference_model.response;

    // Compare with DUT outputs
    if (ref_compressed_out !== pkt.compressed_out) begin
      `uvm_error(get_type_name(), $sformatf("Compressed output mismatch. Expected: %0h, Got: %0h", ref_compressed_out, pkt.compressed_out))
    end
    if (ref_decompressed_out !== pkt.decompressed_out) begin
      `uvm_error(get_type_name(), $sformatf("Decompressed output mismatch. Expected: %0h, Got: %0h", ref_decompressed_out, pkt.decompressed_out))
    end
    if (ref_response !== pkt.response) begin
      `uvm_error(get_type_name(), $sformatf("Response mismatch. Expected: %0h, Got: %0h", ref_response, pkt.response))
    end
  endtask : compare_with_ref_model
endclass : comp_decomp_scoreboard
