module sender(input clk,rst,
              input [7:0] din,
              output reg [7:0] dout,
              output reg write_en
              
             );
 
  always @(posedge clk) begin
    if(rst)  begin
      dout<=8'd0;
      write_en<=0;
    end
    else begin
      dout<=din;
      write_en<=1;
  end
  end
endmodule