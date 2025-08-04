//SCREENSHOT IS SAVED IN PICTURE FOLDER ABOUT THE(FIRST)
module top_module(
    input in,
    input reg [1:0] state,
    output reg [1:0] next_state,
    output out
);
   
    parameter A=2'd0, B=2'd1, C=2'd2, D=2'd3;
    always @(*)
        begin
            case(state)
                A:next_state=(in)?B:A;
                B:next_state=(in)?B:C;
                C:next_state=(in)?D:A;
                D:next_state=(in)?B:C;
            endcase
        end
    always @(*)
        begin
            case(state)
                A:out=0;
                B:out=0;
                C:out=0;
                D:out=1;
            endcase
        end
                
endmodule

// Testbench for the FSM
module FSM4Tb;
reg clk, in;
wire out;
top_module uut (
    .clk(clk),
    .in(in),
    .out(out)
);
initial begin 
    clk = 0;
    in = 0;
end
initial begin
    $dumpfile("FSM4Tb.vcd");
    $dumpvars(0, FSM4Tb);
end
always begin
    #5 clk = ~clk; // Clock generation
end
initial begin
    // Initial state
    $monitor("clk=%b | in=%b | out=%b", clk, in, out);
    in = 0; #10;
    in = 1; #10; // Transition to state 1
    in = 0; #10; // Transition to state 2
    in = 1; #10; // Transition to state 3
    in = 0; #10; // Transition to state 4
    in = 1; #10; // Transition to state 5
    in = 0; #10; // Transition to state 6
    $finish;
end
endmodule