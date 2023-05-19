//
// Description :
// SOBER_TOP
//     |______ Controller.v
//     |______ preprocess.v
//     |______ core.v
//

module SOBER_TOP
(
    //========== SYSTEM ==============
    input wire              clk,
    input wire              rst_n,

    //========== Memory Controller ==============
    input wire [7:0]        data_i,
    input wire              en_i,

    //========== CPU CORE (Not Demanded at this Time)==============
    output wire [2:0]       state_o,

    //========== VGA ==============

    //========== 7-Segment ============== 
    
     //========== Switch ==============

);

U_CTR controller
#(

)
(

);

U_PRE preprocess
#(

)
(

);

U_CORE core
#(

)
(

);

endmodule