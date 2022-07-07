// Round robbin priority encoder or arbitter

module day15#(
        parameter NUM_PORTS = 4
        )
    (
        input   logic   clk,reset,
        input   logic   [NUM_PORTS-1:0] req_i,
        input   logic   [NUM_PORTS-1:0] gnt_o
);

//use masking to register the last grant
logic   [NUM_PORTS-1:0] mask_q;
logic   [NUM_PORTS-1:0] mask_nxt;

//register last grant
always_ff @(posedge clk or posedge reset)
    if(reset)
        mask_q <= 4'hF;
    else
        mask_q <= mask_nxt;





endmodule