`timescale 1ns / 1ps

module tb_preprocess


//clock
reg CLK;

reg core_en_i;
reg [7:0]   data_i;
reg fetch_en_i;


reg fetch_done_o;
reg core_done_o;
reg [7:0] data_0_0_o,
reg [7:0] data_0_1_o,
reg [7:0] data_0_2_o,
reg [7:0] data_1_0_o,
reg [7:0] data_1_1_o,
reg [7:0] data_1_2_o,
reg [7:0] data_2_0_o,
reg [7:0] data_2_1_o,
reg [7:0] data_2_2_o,

reg core_en_o;

reg n_segment_up_o;

reg [1:0] cnt_buf_row;
reg [9:0] cnt_buf_col;
reg [9:0] cnt_pos_col;



parameter MAX_BUF_ROWS  = 3;
parameter MAX_IMG_COLS  = 540;



preprocess preprocess_module 
(
    //============= SYSTEM ==============
    .clk                (clk),
    .rst_n              (rst_n),
    
    //============ Controller ============
    //From
    .core_en_i          (core_en_i),
    //To
    .fetch_done_o       (fetch_done_o),
    .core_done_o        (core_done_o),

    //========== Memory Controller ========  
    //From
    .data_i             (data_i),           //[7:0]
    .fetch_en_i         (fetch_en_i),   
    //To

    //==========   Core  ================
    //From
    //To
    .data_0_0_o         (data_0_0_o),
    .data_0_1_o         (data_0_1_o),
    .data_0_2_o         (data_0_2_o),

    .data_1_0_o         (data_1_0_o),
    .data_1_1_o         (data_1_1_o),
    .data_1_2_o         (data_1_2_o),

    .data_2_0_o         (data_2_0_o),
    .data_2_1_o         (data_2_1_o),
    .data_2_2_o         (data_2_2_o),

    .core_done_o        (core_en_o),

    //===========  7 Segment =============== 
    //From
    //To
    .n_segment_up_o     (n_segment_up_o),

    //=========================== DEBUGG ==============================
    .cnt_buf_row        (cnt_buf_row),   //[1:0]
    .cnt_buf_col        (cnt_buf_col),   //[9:0] 

    .cnt_pos_col        (cnt_pos_col)   //[9:0] 
);

//clock
initial
begin
    forever
    begin
    #10 CLK = !CLK;
    end
end

reg [7:0] i;

initial
begin
    i = 'd0;
    core_en_i  = 1'b0;
    data_i     = 8'd0;
    fetch_en_i = 1'b0;
end

initial
begin
    i = 'd0;
    #5
    repeat(5) begin
        #20 data_i  = i
    end

    #20 data_i  = 'd0;

    #20 fetch_en_i = 1'd0;
    repeat(1620) begin
        #20 data_i  = 8'b1111_1111;
    end

    #20 fetch_en_i = 1'b0, data_i = 'd0;

    #20 core_en_i = 1'b0;

end
	


endmodule