module preprocess
(
    //================================
    //        SYSTEM
    //================================
    input   wire             clk,   
    input   wire             rst_n,

    //================================
    //      Controller
    //================================
    //From
    input   wire            core_en_i,

    //To
    output  wire            fetch_done_o,
    output  wire            core_done_o,

    //================================
    //      Memory Controller   
    //================================
    //From
    input   wire [7:0]      data_i,
    input   wire            fetch_en_i,   
    //To

    //================================
    //            Core
    //================================
    //From

    //To
    output  wire [7:0]      data_0_0_o,
    output  wire [7:0]      data_0_1_o,
    output  wire [7:0]      data_0_2_o,
    output  wire [7:0]      data_1_0_o,
    output  wire [7:0]      data_1_1_o,
    output  wire [7:0]      data_1_2_o,
    output  wire [7:0]      data_2_0_o,
    output  wire [7:0]      data_2_1_o,
    output  wire [7:0]      data_2_2_o,


    
    output  wire            core_en_o,
    //================================
    //        7 Segment 
    //================================
    //From
 
    //To
    output                   n_segment_up_o,      

    //======================================================
    //              DEBUGG
    //======================================================
    output    [1:0]                 cnt_buf_row,   
    output    [9:0]                 cnt_buf_col,

    output    [9:0]                 cnt_pos_col
);

parameter       MAX_BUF_ROWS = 3;
parameter       MAX_IMG_COLS = 540;
parameter       CNT_IMG_COLS = 10;

//8x(3x(540+2))        +2 is for 0
reg [7:0]     buffer_0[MAX_IMG_COLS+2];     
reg [7:0]     buffer_1[MAX_IMG_COLS+2];   
reg [7:0]     buffer_2[MAX_IMG_COLS+2];   

//MEM controller --> BUFFER
reg [1:0]                                   cnt_buf_row;            //Count row
reg [CNT_IMG_COLS - 1:0]                    cnt_buf_col;            //Count col

//Position Buffer : BUF --> CORE (3x3 Filter)
reg [CNT_IMG_COLS - 1:0]                    cnt_pos_col;


//Fetch CNT
always @(posedge clk) begin
    if(!rst_n) begin
        cnt_buf_row         <= 'd0;
        cnt_buf_col         <= 'd0;
    end
    else begin
        if(fetch_en_i) begin
            if(cnt_buf_col == MAX_IMG_COLS-1) begin
                cnt_buf_col         <= 'd0;
                if((cnt_buf_row == MAX_BUF_ROWS-1) && (cnt_buf_col == MAX_IMG_COLS-1)) begin
                    cnt_buf_row         <= 'd0;
                end
                else begin
                    cnt_buf_row         <= cnt_buf_row  + 'd1;
                end
            end
            else begin
                cnt_buf_col         <= cnt_buf_col + 'd1;
            end
        end
    end
end

//Fetch DONE
//                     __
// fetch_done_o   :___|  |___
//
assign fetch_done_o     = ((cnt_buf_row == MAX_BUF_ROWS-1) && (cnt_buf_col == MAX_IMG_COLS-1))? 1 : 0;

//Filter POS
always @(posedge clk) begin
    if(!rst_n) begin
        buffer_0[0:MAX_IMG_COLS+1]              <= 'd0;
        buffer_1[0:MAX_IMG_COLS+1]              <= 'd0;
        buffer_2[0:MAX_IMG_COLS+1]              <= 'd0;
    end
    else begin
        case(cnt_buf_row)
            'd0: buffer_0[cnt_buf_col]       <= data_i;
            'd1: buffer_1[cnt_buf_col]       <= data_i;
            'd2: buffer_2[cnt_buf_col]       <= data_i;
        endcase
    end
end

//==========================================================================================

//Filter Pos CNT
always @(posedge clk) begin
    if(!rst_n) begin
        cnt_pos_col         <= 'd0;
    end
    else begin
        if(core_en_i) begin
            if(cnt_pos_col == MAX_IMG_COLS-1) begin
                cnt_pos_col         <= 'd0;
            end
            else begin
                cnt_pos_col         <= cnt_pos_col + 'd1;
            end
        end
    end
end

//                        __
// core_done_o      : ___|  |___
//                        __
// n_segment_up_o   : ___|  |___

assign core_done_o      = (cnt_pos_col == MAX_IMG_COLS-1)? 1 : 0;
assign n_segment_up_o   = (cnt_pos_col == MAX_IMG_COLS-1)? 1 : 0;



assign data_0_0_o       = (core_en_i)? buffer_0[cnt_pos_col+0] : 'd0;
assign data_0_1_o       = (core_en_i)? buffer_0[cnt_pos_col+1] : 'd0;
assign data_0_2_o       = (core_en_i)? buffer_0[cnt_pos_col+2] : 'd0;

assign data_1_0_o       = (core_en_i)? buffer_1[cnt_pos_col+0] : 'd0;
assign data_1_1_o       = (core_en_i)? buffer_1[cnt_pos_col+1] : 'd0;
assign data_1_2_o       = (core_en_i)? buffer_1[cnt_pos_col+2] : 'd0;

assign data_2_0_o       = (core_en_i)? buffer_2[cnt_pos_col+0] : 'd0;
assign data_2_1_o       = (core_en_i)? buffer_2[cnt_pos_col+1] : 'd0;
assign data_2_2_o       = (core_en_i)? buffer_2[cnt_pos_col+2] : 'd0;


assign core_en_o    = core_en_i;

endmodule