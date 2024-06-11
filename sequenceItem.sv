class comp_decomp_seq_item extends uvm_sequence_item;
  
  rand logic 		 	reset, 
  rand logic [79:0] 	data_in,
  rand logic [7:0] 	compressed_in,
  rand logic [1:0] 	command,
  
       logic [7:0] 	compressed_out, 
  	   logic [79:0] 	decompressed_out,
  	   logic [1:0] 	response,
  
  //Utility and Field macros,
  `uvm_object_utils_begin(comp_decomp_seq_item)
    `uvm_field_int(reset,UVM_ALL_ON)
    `uvm_field_int(data_in,UVM_ALL_ON)
    `uvm_field_int(compressed_in,UVM_ALL_ON)
    `uvm_field_int(command,UVM_ALL_ON)
    `uvm_field_int(compressed_out,UVM_ALL_ON)
    `uvm_field_int(decompressed_out,UVM_ALL_ON)
    `uvm_field_int(response,UVM_ALL_ON)
  `uvm_object_utils_end
  
  //Constructor
  function new(string name = "comp_decomp_seq_item");
    super.new(name);
  endfunction
  
  //constaint, to generate any one among write and read
//   constraint wr_rd_c { wr_en != rd_en; }; 
endclass
