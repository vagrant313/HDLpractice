module day14#(
    parameter NUM_PORTS = 4
)
(
    input   wire   [NUM_PORTS-1:0]req,
    output  wire   [NUM_PORTS-1:0]grnt

);

    //port[0] has highest priority
    //assign grnt[0] = req[0];

    //assign grnt[1] = req[1] & ~(grnt[0] ); 
    //assign grnt[2] = req[2] & ~(grnt[1] | grnt[0]); 
    //assign grnt[3] = req[3] & ~(grnt[2] | grnt[1] | grnt[0]); 

    //single line implementation
    //genvar i;
    //for(i=1; i<NUM_PORTS; i=i+1) begin
    //    assign grnt[i] = req[i] & ~(|grnt[i-1:0]);
    //end

    
  genvar i;
  for (i=1; i<NUM_PORTS; i=i+1) begin
    assign grnt[i] = req[i] & ~(|grnt[i-1:0]);
  end

endmodule