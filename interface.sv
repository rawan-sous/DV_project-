


interface mem_if(input logic clk, reset);
  
  //---------------------------------------
  //declaring the signals
  //---------------------------------------
  logic [79:0] data_in;
  logic [7:0] compressed_in;
  logic [1:0] command;
  
  logic [7:0] compressed_out;
  logic [79:0] decompressed_out;
  logic [1:0] response;
  
  //---------------------------------------
  //driver clocking block
  //---------------------------------------
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output data_in;
    output compressed_in;
    output command;
    input compressed_out;  
    input decompressed_out;  
    input response;  
  endclocking
  
  //---------------------------------------
  //monitor clocking block
  //---------------------------------------
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input data_in;
    input compressed_in;
    input command;
    output compressed_out;  
    output decompressed_out;  
    output response; 
  endclocking
  
  //---------------------------------------
  //driver modport
  //---------------------------------------
  modport DRIVER  (clocking driver_cb, input clk, reset);
  
  //---------------------------------------
  //monitor modport  
  //---------------------------------------
  modport MONITOR (clocking monitor_cb, input clk, reset);
  
endinterface

  modport MONITOR (clocking monitor_cb,input clk,reset);
  
endinterface
