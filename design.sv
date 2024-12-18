module MA(
    input logic clk, 
    input logic reset, 
    input logic [79:0] data_in,
    input logic [7:0] compressed_in,
    input logic [1:0] command,
    output logic [7:0] compressed_out, 
    output logic [79:0] decompressed_out,
  output logic [1:0] response,
   output logic [31:0] test_index,
  	output logic [79:0] test_mem
);
  logic [79:0] mem[0:255]; // 256 indexes, each storing 80 bits
  // Index for read and write operations
  logic [31:0] index;
  int i;
  bit data_exists;
    always @(posedge clk) begin

        if (reset == 1) begin
            // Reset index and test_index to 0
            index = 0;

            
            for (i = 0; i < 256; i = i + 1) begin // initialize memory array to zero
              $display("mem[%d] before: %b", i, mem[i]);
              mem[i] = 0;         
              $display("mem[%d] after: %b", i, mem[i]);

            end
          
          	test_mem = 0;
        end else begin
            // Command processing
            case (command)
                0: begin // No operation
                    response <= 0;
                end
                1: begin // Compression
                    // Check if data_in already exists in memory
                    data_exists = 0;
                    for (i = 0; i < index; i = i + 1) begin
                        if (mem[i] == data_in) begin
                            data_exists = 1;
                            break;
                        end
                    end

                    if (data_exists == 0) begin // Data not found in memory
                        if (index < 256) begin // Check if there is space in memory
                            response <= 1;
                            mem[index] <= data_in;
                            test_mem <= data_in; // Update test_mem for testing
                            compressed_out <= index[7:0]; // Assign compressed index to compressed_out
                            index <= index + 1; // Increment index
                            
                        end else begin
                            response <= 3; // Memory full
                            // Optionally handle the memory full scenario
                        end
                    end else begin
                      response <= 1; // Data already exists in memory
                      compressed_out <=i;
                    end
                end
                2: begin // Decompression
                    if (compressed_in < index[7:0]) begin
                      	decompressed_out <= mem[compressed_in];
                      	response <= 2;
                	end 
                  	else begin
                      	response <= 3; // error (compressed_in > index)
                    end

                end
                default: begin 
                    response <= 3;
                end
            endcase
        end
    end

    // Initialize index to 0
    initial begin
        index = 0;
        test_index = 0; // Initialize test_index to 0

        // Initialize memory array to zero on startup
        for (int i = 0; i < 256; i = i + 1) begin
            mem[i] = 80'b0; // Set each element of the memory array to zero
        end
    end
 always @(index) begin // for testing the index
     test_index <= index; 
   end
endmodule
