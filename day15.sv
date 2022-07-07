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


// next mask based on the current mask 
always_comb begin
    mask_nxt = mask_q;

            if (gnt_o[0])   mask_nxt    =   4'b1110;
    else    if (gnt_o[1])   mask_nxt    =   4'b1100;
    else    if (gnt_o[2])   mask_nxt    =   4'b1000;
    else    if (gnt_o[3])   mask_nxt    =   4'b0000;

end

//generate the masked requests

logic   [NUM_PORTS:0] mask_req;
logic   [NUM_PORTS:0] mask_gnt;
logic   [NUM_PORTS:0] raw_gnt;

//generate internal grants
day14 #(NUM_PORTS) masked_grant (.req_i(mask_req), .gnt_o(mask_gnt));
day14 #(NUM_PORTS) raw_grant    (.req_i(req_i), .gnt_o(raw_gnt));

assign mask_req  = req_i & mask_q;
assign gnt_o     = |mask_req ? mask_gnt : raw_gnt;

endmodule