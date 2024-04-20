module testbench;
  reg clk, reset;
  reg [79:0] data_in;
  reg [7:0] compressed_in;
  reg [1:0] command;
  wire [7:0] compressed_out;
  wire [79:0] decompressed_out;
  wire [1:0] response;
  //wire [31:0] test_index;
  //wire [79:0] test_mem;
  //MA h1(clk, reset,data_in,  compressed_in,command, compressed_out, decompressed_out, response,test_index,test_mem);
  MA h1(clk, reset,data_in,  compressed_in,command, compressed_out, decompressed_out, response);

  initial begin
    $dumpfile("file.vcd");
    $dumpvars(1);
    reset = 0;
    data_in = 80'b111;
    compressed_in = 8'b0;
    

    command = 0; // response = 0 // do nothing
    #4 
    	command = 1; // compress data = 111

    #4 
    	command = 2; // decompress index = 0
      	
    #4 
    	command = 3; // show error
    #4 
    	command = 1; // compress same dara

    #4 
      command = 2; // decompress > index
      compressed_in = compressed_in +1;
    #4;
		compressed_in = compressed_in -1;
    
    #100 
    	reset = 1;
    #4 
   		reset = 0;
    #20 $finish;
  end
  
always begin
  	#24;
    
    forever begin 
      	command = 1;
      	data_in = data_in + 1;
      #4 
      	compressed_in = compressed_in +1;
      	command = 2;
      #4; 
    end
end


always begin
    forever begin // repeat clock pulses forever
        #2
        	clk = 1; 
        #2 
        	clk = 0; 
    end
end
endmodule
