// This is a simple FSM (Finite State Machine) implementation in Verilog
module top_module(
    input clk,
    input areset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        case(state)
            OFF:next_state=j?ON:OFF;
            ON:next_state=k?OFF:ON;
            default:next_state=OFF;
        endcase
       end

    always @(posedge clk, posedge areset) begin
        if(areset)
            state<=OFF;
        else
            state<=next_state;
    end
always @* begin
    case(state)
    OFF:out=0;
    ON:out=1;
    default:out=0;
    endcase
end
endmodule

// Testbench for the FSM
module FSM2TB();
reg clk, areset, j,k;
wire out;
top_module uut (
    .clk(clk),
    .areset(areset),
    .j(j),
    .k(k),
    .out(out)
);
initial begin 
    clk = 0;
    areset = 1;
    j = 0;
    k = 0;
end
always begin
    #5 clk = ~clk; // Clock generation
end
initial begin
    $dumpfile("FSM2TB.vcd");
    $dumpvars(0, FSM2TB);
end
initial begin
    // Initial state
    $monitor("clk=%b | areset=%b | j=%b | k=%b | out=%b", clk, areset, j, k, out);
    #10 areset = 0; j = 0; k = 0; #10
    j = 1; #10; // Transition to ON state
    j = 0; k = 1; #10; // Transition to OFF state
    j = 0; k = 0; #10; // Stay in OFF state
    j = 1; #10; // Transition to ON state again
    k = 1; #10; // Transition to OFF state again
    $finish;
end
endmodule
