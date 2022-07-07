//APB master module

// Cmd Operations
//  -   2'b00   -   No-OP
//  -   2'b01   -   Read from address 0xDEAD_BEEF
//  -   2'b10   -   increment the received data and
//                  store to address 0xDEABEEF

module  day16(

    input       logic       clk,
    input       logic       reset,

    input       logic  [1:0]cmd_i,
    
    output      logic   pselect_o,
    output      logic   penable_o,
    output      logic   pwrite_o,
    output      logic   paddr_o,
    output      logic   pwdata_o,
    input       logic   pready_i,
    input       logic   prdata_i
);

    typedef enum logic[1:0] {   IDLE,
                                SETUP,
                                ACCES } apb_state_t;

    apb_state_t state_nxt;
    apb_state_t state;

    logic   [31:0]rdata_q;

    always_ff@(posedge clk or posedge reset)
        if(reset)   state   <=  IDLE;
        else        state   <=  state_nxt;
            
            
    always_comb begin
        state_nxt   =   state;

        case(state)
            IDLE    :  if(|cmd_i)   state_nxt = SETUP;
                       else         state_nxt = IDLE;

            SETUP   :               state_nxt = ACCES;
            
            ACCES   :      if(pready_i)
                                    state_nxt = IDLE;
            
        endcase
    end
            

    assign  pselect_o       =   (state ==  SETUP) | 
                                (state ==  ACCES);

    assign  penable_o       =   (state ==  ACCES);
    assign  pwrite_o        =   cmd_i[1];
    assign  paddr_o         =   32'hDEADBEEF;
    assign  pwdata_o        =   rdata_q + 32'h1;

    //capture read data and rewrite on the same address
    always_ff@(posedge clk or posedge reset)
        if(reset)   
            rdata_q <=  32'h0;
        else if(penable_o && pready_i)
            rdata_q <= prdata_i;    
    

endmodule