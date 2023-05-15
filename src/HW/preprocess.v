//Combinational Logic
module preprocess(
    //From Buffer
    input   [71:0]      data_i,

    //From Controller
    input   [2:0]       state_i,

    //From Core
    input               core_valid_i,

    //To CORE
    output  [71:0]      data_o,

    output  [9:0]       cnt_col_o,
    output  [9:0]       cnt_row_o,

    //To 7-Segment
    output              n_segment_up_o,

    //To Controller
    output              preprocess_done_o
);


reg [539:0]             buffer;         //Main Buffer

reg [9:0]   cnt_col;
reg [9:0]   cnt_row;



//Multiplexer(MUX)
always @(*) begin

end


assign cnt_row_o                = cnt_row;
assign cnt_col_o                = cnt_col;

assign preprocess_done_o        = 

endmodule