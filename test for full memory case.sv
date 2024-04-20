module testbench;
  reg clk, reset;
  reg [79:0] data_in;
  reg [7:0] compressed_in;
  reg [1:0] command;
  wire [7:0] compressed_out;
  wire [79:0] decompressed_out;
  wire [1:0] response;
  wire [31:0] test_index;
  wire [79:0] test_mem;
  MA h1(clk, reset,data_in,  compressed_in,command, compressed_out, decompressed_out, response,test_index,test_mem);
//   MA h1(clk, reset,data_in,  compressed_in,command, compressed_out, decompressed_out, response);

  initial begin
    $dumpfile("file.vcd");
    $dumpvars(1);
    reset = 0;
    data_in = 80'b1;
	command = 1;
    #520 $finish;
  end
  
always begin
    forever begin 
      	
      	data_in = data_in + 1;
      #2;
    end
end


always begin
    forever begin // repeat clock pulses forever
        #1
        	clk = 1; 
        #1 
        	clk = 0; 
    end
end
endmodule
