module receiver #(
    parameter WIDTH = 8,
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = $clog2(DEPTH)
) (input clk,rst,
               input [WIDTH-1:0]din,
               output reg [WIDTH-1:0]dout,
               output reg read_en
              );
  parameter s0=2'b00;
  parameter s1=2'b01;
  parameter s2=2'b10;
  
  reg [1:0] ns,ps;
  
  always @(posedge clk) begin
    if(rst)
      ps<=s0;
    else
      ps<=ns;
  end
  
  always @(*) begin
    ns = ps;

    read_en = 0;
    case(ps)
      s0: begin 
        ns=s1;
        read_en=0;
      end
      s1: ns=s2;
      s2: begin
        ns=s0;
         read_en=1;
      end
      default:ns=s0;
    endcase
  end
    
    always @(posedge clk) begin

    if(rst)

        dout <= 0;

    else 

        dout <= din;

end


    endmodule
    