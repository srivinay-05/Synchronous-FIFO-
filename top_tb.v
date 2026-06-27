`timescale 1ns/1ps

module top_tb;

reg clk, rst;
reg [7:0] din;
reg write_en, read_en;

wire [7:0] dout;
wire full, empty;

// DUT
fifo DUT (
    .clk(clk),
    .rst(rst),
    .din(din),
    .write_en(write_en),
    .read_en(read_en),
    .dout(dout),
    .full(full),
    .empty(empty)
);

// Clock
initial clk = 0;
always #5 clk = ~clk;

// Task: reset
task reset;
begin
    rst = 1;
    write_en = 0;
    read_en = 0;
    din = 0;
    #20;
    rst = 0;
    #10;
end
endtask

initial begin

    reset();

    // ---------------- TEST 1: WRITE ----------------
    write_en = 1;
    din = 8'd10;
    #10;
    write_en = 0;
    #10;

    if (DUT.count == 1)
        $display("PASS: WRITE TEST");
    else
        $display("FAIL: WRITE TEST count=%0d", DUT.count);

    // ---------------- TEST 2: READ ----------------
    read_en = 1;
    #10;
    read_en = 0;
    #10;

    if (DUT.count == 0)
        $display("PASS: READ TEST dout=%0d", dout);
    else
        $display("FAIL: READ TEST count=%0d", DUT.count);

    // ---------------- TEST 3: FULL ----------------
    write_en = 1;

    din = 8'd10; #10;
    din = 8'd20; #10;
    din = 8'd30; #10;
    din = 8'd40; #10;
    din = 8'd50; #10;
    din = 8'd60; #10;
    din = 8'd70; #10;
    din = 8'd80; #10;

    write_en = 0;
    #10;

    if (full)
        $display("PASS: FULL TEST");
    else
        $display("FAIL: FULL TEST count=%0d", DUT.count);

    // ---------------- TEST 4: OVERFLOW ----------------
    write_en = 1;
    din = 8'd99;
    #10;
    write_en = 0;
    #10;

    if (DUT.count == 8)
        $display("PASS: OVERFLOW TEST");
    else
        $display("FAIL: OVERFLOW TEST count=%0d", DUT.count);

    // ---------------- TEST 5: EMPTY ----------------
    read_en = 1;

    repeat (8) #10;

    read_en = 0;
    #10;

    if (empty)
        $display("PASS: EMPTY TEST");
    else
        $display("FAIL: EMPTY TEST count=%0d", DUT.count);

    // ---------------- TEST 6: UNDERFLOW ----------------
    read_en = 1;
    #10;
    read_en = 0;
    #10;

    if (DUT.count == 0)
        $display("PASS: UNDERFLOW TEST");
    else
        $display("FAIL: UNDERFLOW TEST count=%0d", DUT.count);

    // ---------------- TEST 7: SIMULTANEOUS READ/WRITE ----------------
    write_en = 1;
    read_en  = 0;

    din = 8'd15; #10;
    din = 8'd25; #10;
    din = 8'd35; #10;
    din = 8'd45; #10;

    write_en = 0;
    #10;

    write_en = 1;
    read_en  = 1;
    din = 8'd55;

    #10;

    write_en = 0;
    read_en  = 0;

    if (DUT.count == 4)
        $display("PASS: SIMULTANEOUS READ/WRITE");
    else
        $display("FAIL: SIMULTANEOUS READ/WRITE count=%0d", DUT.count);

    #20;
    $display("---- ALL TESTS COMPLETED ----");
    $finish;

end

// Monitor
initial begin
    $monitor("T=%0t | din=%0d | dout=%0d | count=%0d | full=%b | empty=%b",
             $time, din, dout, DUT.count, full, empty);
end

endmodule