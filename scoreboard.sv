//-------------------------------------------------------------------------
//						mem_scoreboard - www.verificationguide.com 
//-------------------------------------------------------------------------

class comp_decomp_scoreboard extends uvm_scoreboard;
  
  //---------------------------------------
  // declaring pkt_qu to store the pkt's recived from monitor
  //---------------------------------------
  comp_decomp_seq_item pkt_qu[$];
  
  //---------------------------------------
  // sc_mem 
  //---------------------------------------
  bit [7:0] sc_mem [4];//	------------------------------ change here ------------------------------

  //---------------------------------------
  //port to recive packets from monitor
  //---------------------------------------
  uvm_analysis_imp#(comp_decomp_seq_item, comp_decomp_scoreboard) item_collected_export;
  `uvm_component_utils(comp_decomp_scoreboard)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  //---------------------------------------
  // build_phase - create port and initialize local memory
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      item_collected_export = new("item_collected_export", this);
      foreach(sc_mem[i]) sc_mem[i] = 8'hFF;
  endfunction: build_phase
  
  //---------------------------------------
  // write task - recives the pkt from monitor and pushes into queue
  //---------------------------------------
  virtual function void write(comp_decomp_seq_item pkt);
    pkt.print();
    pkt_qu.push_back(pkt);
  endfunction : write

  //---------------------------------------
  // run_phase - compare's the read data with the expected data(stored in local memory)
  // local memory will be updated on the write operation.
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    comp_decomp_seq_item comp_decomp_pkt;
    
    forever begin
      wait(pkt_qu.size() > 0);
      comp_decomp_pkt = pkt_qu.pop_front();
      // debug remove it later
      
      `uvm_info(get_type_name(),$sformatf("------ :: I got a pkt       :: ------"),UVM_LOW)
      
      `uvm_info(get_type_name(),$sformatf("Addr: %0h",comp_decomp_pkt.data_in),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("Data: %0h",comp_decomp_pkt.compressed_in),UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("Addr: %0h",comp_decomp_pkt.command),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("Data: %0h",comp_decomp_pkt.compressed_out),UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("Addr: %0h",comp_decomp_pkt.decompressed_out),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("Data: %0h",comp_decomp_pkt.response),UVM_LOW)
      
      `uvm_info(get_type_name(),"-------------------- END ----------------",UVM_LOW)  
      
      // end debug

      
      
//       if(comp_decomp_pkt.wr_en) begin
//         sc_mem[comp_decomp_pkt.addr] = comp_decomp_pkt.wdata;
//         `uvm_info(get_type_name(),$sformatf("------ :: WRITE DATA       :: ------"),UVM_LOW)
//         `uvm_info(get_type_name(),$sformatf("Addr: %0h",comp_decomp_pkt.addr),UVM_LOW)
//         `uvm_info(get_type_name(),$sformatf("Data: %0h",comp_decomp_pkt.wdata),UVM_LOW)
//         `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)        
//       end
//       else if(comp_decomp_pkt.rd_en) begin
//         if(sc_mem[comp_decomp_pkt.addr] == comp_decomp_pkt.rdata) begin
//           `uvm_info(get_type_name(),$sformatf("------ :: READ DATA Match :: ------"),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("Addr: %0h",comp_decomp_pkt.addr),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[comp_decomp_pkt.addr],comp_decomp_pkt.rdata),UVM_LOW)
//           `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
//         end
//         else begin
//           `uvm_error(get_type_name(),"------ :: READ DATA MisMatch :: ------")
//           `uvm_info(get_type_name(),$sformatf("Addr: %0h",comp_decomp_pkt.addr),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[comp_decomp_pkt.addr],comp_decomp_pkt.rdata),UVM_LOW)
//           `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
//         end
//       end
    end
  endtask : run_phase
endclass : comp_decomp_scoreboard
