// BRAM Controller : BRAM read Latency 2 clock

module memory_controller
#(
    parameter        MAX_ROW = 540,
    parameter        MAX_COL = 540 
)
(
    input wire              clk,
    input wire              rst_n,

    //============== BRAM ====================
    output wire             ena_o,
    output wire             wea_o,
    output wire [18:0]      addr_o,
    output wire [7:0]       d2mem_o,             // Not Using. We Do Not Write

    input wire  [7:0]       mem2d_i,

    //============== PREPROCESS ==============
    output wire [7:0]       data_o,
    output wire             data_en_o,


    //============== Controller ================
    input                   is_mode1_i,
    input                   is_mode2_i,
    input  wire             mode1_run_i,
    output wire             mode1_done_o,
    input                   fetch_run_i,
    output                  fetch_done_o,
    input wire [19:0]       cnt_len_i,

    output wire [9:0]       cnt_img_row_o,
    output wire [9:0]       cnt_img_col_o,

    // ============== VGA ====================
    output wire [7:0]       pixel_o,
    output wire             pixel_en_o
);

reg [9:0] cnt_img_row, cnt_img_row_d, cnt_img_row_2d;
reg [9:0] cnt_img_col, cnt_img_col_d, cnt_img_col_2d; 


// BRAM Read Latency is 2 cycle So we need Delay
wire                fetch_done;

reg  [19:0]     cnt_fetch;
assign fetch_done     = (cnt_fetch == cnt_len_i - 1);

wire mode1_done_i;

reg [18:0]          addr;
assign mode1_done     = (addr == cnt_len_i-1);

always @(posedge clk) begin
    if(!rst_n) begin
        cnt_fetch       <= 0;
    end
    else begin
        if(fetch_run_i) begin
            if(fetch_done) begin
                cnt_fetch       <= 'd0;
            end
            else begin
                cnt_fetch       <= cnt_fetch + 'd1;
            end
        end
    end
end

reg mode1_run_d, mode1_run_2d; 
reg mode1_done_d, mode1_done_2d;
reg fetch_run_d, fetch_run_2d, fetch_run_3d;
reg fetch_done_d, fetch_done_2d, fetch_done_3d;
always @(posedge clk) begin
    if(!rst_n) begin
        mode1_run_d         <= 'd0;
        mode1_run_2d        <= 'd0;
        mode1_done_d        <= 'd0;
        mode1_done_2d       <= 'd0;
        fetch_run_d         <= 'd0;
        fetch_done_d        <= 'd0;
        fetch_run_2d        <= 'd0;
        fetch_run_3d        <= 'd0;
        fetch_done_2d       <= 'd0;
        fetch_done_3d       <= 'd0;
        cnt_img_col_d       <= 'd0;
        cnt_img_col_2d      <= 'd0;
        cnt_img_row_d       <= 'd0;
        cnt_img_row_2d      <= 'd0;
    end
    else begin
        mode1_run_d         <= mode1_run_i;
        mode1_run_2d        <= mode1_run_d;
        mode1_done_d        <= mode1_done;
        mode1_done_2d       <= mode1_done_d;
        fetch_run_d         <= fetch_run_i;
        fetch_done_d        <= fetch_done;
        fetch_run_2d        <= fetch_run_d;
        fetch_run_3d        <= fetch_run_2d;
        fetch_done_2d       <= fetch_done_d;
        fetch_done_3d       <= fetch_done_2d;
        cnt_img_col_d       <= cnt_img_col;
        cnt_img_col_2d      <= cnt_img_col_d;
        cnt_img_row_d       <= cnt_img_row;
        cnt_img_row_2d      <= cnt_img_row_d;
    end
end

// Address
always @(posedge clk) begin
    if(!rst_n) begin
        addr     <= 'd0;
    end
    else begin
        if(ena_o) begin
            if(addr == cnt_len_i-1) begin
                addr    <= 'd0;
            end
            else begin
                addr     <= addr + 'd1;
            end
        end
    end
end


// COUNTER
always @(posedge clk) begin
    if(!rst_n) begin
        cnt_img_col     <= 'd0;
        cnt_img_row     <= 'd0;
    end
    else begin
        //Delay Cycle
        if(mode1_run_i & !mode1_done_d & !mode1_done_2d) begin
            if(cnt_img_col == MAX_COL-1) begin
                cnt_img_col     <= 'd0;
                if(cnt_img_row == MAX_ROW-1) begin
                    cnt_img_row         <= 'd0;
                end
                else begin
                    cnt_img_row         <= cnt_img_row + 'd1;
                end
            end
            else begin
                cnt_img_col     <= cnt_img_col + 'd1;
            end               
        end
        else if(fetch_run_i & !fetch_done_d & !fetch_done_2d) begin
            if(cnt_img_col == MAX_COL-1) begin
                cnt_img_col     <= 'd0;

                if(cnt_img_row == MAX_ROW-1) begin
                    cnt_img_row         <= 'd0;
                end
                else begin
                    cnt_img_row         <= cnt_img_row + 'd1;
                end
            end
            else begin
                cnt_img_col     <= cnt_img_col + 'd1;
            end
        end
    end
end

// =================== TO BRAM
assign ena_o            = ((mode1_run_i & !mode1_done_d & !mode1_done_2d)  | (fetch_run_i & !fetch_done_d & !fetch_done_2d))? 1'd1 : 1'd0;
assign wea_o            = 1'd0;
assign addr_o           = addr;
assign d2mem_o          = 'd0;

// ================== TO PREPROCESS
assign data_o           = (data_en_o)? mem2d_i : 'd0;
assign data_en_o        = (fetch_run_i)? fetch_run_2d & fetch_run_i : 1'd0;
// ================== TO CONTORLLER
    //Fetch DONE
    //                     __
    // fetch_done_o   :___|  |___
    //
assign fetch_done_o     = fetch_done_2d;
assign cnt_img_row_o    = cnt_img_row_2d;
assign cnt_img_col_o    = cnt_img_col_2d;

assign mode1_done_o     = mode1_done_2d;

// ================== To VGA
assign pixel_o          = (pixel_en_o)? mem2d_i : 'd0;
assign pixel_en_o       = (mode1_run_i)? mode1_run_2d & mode1_run_i : 1'd0;

endmodule