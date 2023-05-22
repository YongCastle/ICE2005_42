module preprocess_module
#(
    parameter       MAX_ROW = 540,
    parameter       MAX_COL = 540
)
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
    input   wire            core_run_i,
    //To
    output  wire            core_done_o,
    //================================
    //      Memory Controller   
    //================================
    //From
    input   wire [7:0]      data_i,
    input   wire            data_en_i,   
    //================================
    //            Core
    //================================
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

    //======================================================
    //              DEBUGG
    //======================================================
    output    [1:0]                 cnt_buf_row_o,   
    output    [9:0]                 cnt_buf_col_o,

    output    [9:0]                 cnt_pos_col_o
);

//8x(3x(540))       
reg [7:0]     buffer_0[0:MAX_COL-1];     
reg [7:0]     buffer_1[0:MAX_COL-1];   
reg [7:0]     buffer_2[0:MAX_COL-1];   

//MEM controller --> BUFFER
reg [1:0]                    cnt_buf_row;            //Count row
reg [9:0]                    cnt_buf_col;            //Count col

//Position Buffer : BUF --> CORE (3x3 Filter)
reg [9:0]                    cnt_pos_col;


//Fetch CNT
always @(posedge clk) begin
    if(!rst_n) begin
        cnt_buf_row         <= 'd0;
        cnt_buf_col         <= 'd0;
    end
    else begin
        if(data_en_i) begin
            if(cnt_buf_col == MAX_COL-1) begin
                cnt_buf_col         <= 'd0;
                if((cnt_buf_row == 2) && (cnt_buf_col == MAX_COL-1)) begin
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


//Filter POS
always @(posedge clk) begin
    if(!rst_n) begin
        buffer_0[MAX_COL]                      <= 'd0;
        buffer_1[MAX_COL]                      <= 'd0;
        buffer_2[MAX_COL]                      <= 'd0;
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
        if(core_run_i) begin
            if(cnt_pos_col == MAX_COL-1-2) begin
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


// ======== TO Controller ===========================
assign core_done_o      = (cnt_pos_col == MAX_COL-3)? 1 : 0;

// ======== TO CORE ===========================
assign data_0_0_o       = (core_run_i)? buffer_0[cnt_pos_col+0] : 'd0;
assign data_0_1_o       = (core_run_i)? buffer_0[cnt_pos_col+1] : 'd0;
assign data_0_2_o       = (core_run_i)? buffer_0[cnt_pos_col+2] : 'd0;

assign data_1_0_o       = (core_run_i)? buffer_1[cnt_pos_col+0] : 'd0;
assign data_1_1_o       = (core_run_i)? buffer_1[cnt_pos_col+1] : 'd0;
assign data_1_2_o       = (core_run_i)? buffer_1[cnt_pos_col+2] : 'd0;

assign data_2_0_o       = (core_run_i)? buffer_2[cnt_pos_col+0] : 'd0;
assign data_2_1_o       = (core_run_i)? buffer_2[cnt_pos_col+1] : 'd0;
assign data_2_2_o       = (core_run_i)? buffer_2[cnt_pos_col+2] : 'd0;


assign core_en_o        = core_run_i;

endmodule