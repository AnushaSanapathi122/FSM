// This is a simple FSM (Finite State Machine) implementation in Verilog
module top_module(
    input clk,
    input in,
    input areset,
    output reg out
    ); 
    reg [1:0] state,next_state;
    parameter A=2'd0,B=2'd1,C=2'd2,D=2'd3;
    always @(posedge clk or posedge areset)
        begin
            if(areset)
                state<=A;
            else 
               state<=next_state;
        end
    always @(*)
        begin
            case(state)
                A:next_state=in?B:A;
                B:next_state=in?B:C;
                C:next_state=in?D:A;
                D:next_state=in?B:C;
                default:next_state=A;
            endcase
        end
    always @(*)
        begin
            case(state)
                A,B,C:out=0;
                D:out=1;
                default:out=0;
            endcase
        end
            
endmodule

// Testbench for the FSM

module FSM4Tb;
reg clk, in, areset;
wire out;
top_module uut (
    .clk(clk),
    .areset(areset),
    .in(in),
    .out(out)
);
initial begin 
    clk = 0;
    areset = 1;
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
    $monitor("clk=%b | areset=%b | in=%b | out=%b", clk, areset, in, out);
    #10 areset = 0; in = 0; #10;
    in = 1; #10; // Transition to state 1
    in = 0; #10; // Transition to state 2
    in = 1; #10; // Transition to state 3
    in = 0; #10; // Transition to state 4
    in = 1; #10; // Transition to state 5
    in = 0; #10; // Transition to state 6
    $finish;
end
endmodule
