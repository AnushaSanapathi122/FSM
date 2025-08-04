// This is a simple FSM (Finite State Machine) implementation in Verilog
module top_module (
    input clk,
    input areset,
    input in,
    output reg out
);

    parameter A = 0, B = 1;
    reg state, next_state;

    // Combinational logic for next state
    always @(*) begin
        case (state)
            A:begin
                out=0;
                if (in)
                    next_state = A;
                else
                    next_state = B;
            end
            B:begin
                 out=1;
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            default: next_state = B;
        endcase
    end

    // Synchronous state transition
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output logic (depends only on state)
    //we can directly give output within the case statement or else 
    /*we can do like this seperately
    always @(*) begin
        case (state)
            A: out = 0;
            B: out = 1 ;// You can change this to `1` if needed
            default: out = 0;
        endcase
    end*/

endmodule


// Testbench for the FSM
module FSMTb;
reg clk, areset,in;
wire out;
top_module uut (
    .clk(clk),
    .areset(areset),
    .in(in),
    .out(out)
);
initial begin 
    clk=0;
    areset=1;
    in=0;
end
always begin
    #5 clk = ~clk; // Clock generation
end
initial begin
    $dumpfile("FSMTb.vcd");
    $dumpvars(0, FSMTb);
end
initial begin
    // Initial state
    $monitor("clk=%b | areset=%b | in=%b |out=%b", clk, areset, in, out);
    #10 areset = 0; in = 0; #10
    in= 1; #10; // Transition to state 1
    in= 0; #10; // Transition to state 2
    in= 1; #10; // Transition to state 3
    in= 0; #10; // Transition to state 4
    in= 1; #10; // Transition to state 5
    in= 0; #10; // Transition to state 6
    $finish;
end
endmodule