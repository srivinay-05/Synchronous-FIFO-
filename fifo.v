module fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = $clog2(DEPTH)
) (input clk,rst,
            input [WIDTH-1:0] din,
            input write_en,read_en,
            output reg [WIDTH-1:0] dout,
            output  empty,full
           );
  reg [WIDTH-1:0] mem [0:DEPTH-1];
  reg [ADDR_WIDTH-1:0] write_ptr,read_ptr;
  reg [ADDR_WIDTH:0] count;
  
 wire write_valid;
 wire read_valid;

  integer i;
  
  always @(posedge clk) begin
    if(rst) begin
      for(i=0;i<DEPTH;i=i+1)
      mem[i]    <={WIDTH{1'b0}};
      write_ptr <= 0;
      read_ptr  <= 0;
      count     <= 0;
      dout      <= {WIDTH{1'b0}};
    end
    else begin
    if(write_valid) begin
      mem[write_ptr]<=din;
      write_ptr<=write_ptr+1;
    end
     if(read_valid) begin
      dout<=mem[read_ptr];
      read_ptr<=read_ptr+1;
    end
   case ({write_valid, read_valid})

   2'b10: count <= count + 1'b1;

   2'b01: count <= count - 1'b1; 

   2'b11: count <= count;

   default: count <= count;    

endcase
  end
end
  
  assign full=(count==DEPTH);
  assign empty=(count==0);

  assign write_valid = write_en && !full;
  assign read_valid  = read_en && !empty;

endmodule