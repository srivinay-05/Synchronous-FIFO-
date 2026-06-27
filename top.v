`timescale 1ns/1ps
module top(

input clk,
input rst,

input [7:0] din,

output [7:0] final_out

);

wire [7:0] sender_to_fifo;

wire sender_write;

wire [7:0] fifo_to_receiver;

wire receiver_read;


sender S1(

.clk(clk),

.rst(rst),

.din(din),

.dout(sender_to_fifo),

.write_en(sender_write)

);


fifo F1(

.clk(clk),

.rst(rst),

.din(sender_to_fifo),

.write_en(sender_write),

.read_en(receiver_read),

.dout(fifo_to_receiver),

.empty(),

.full()

);


receiver R1(

.clk(clk),

.rst(rst),

.din(fifo_to_receiver),

.dout(final_out),

.read_en(receiver_read)

);

endmodule
