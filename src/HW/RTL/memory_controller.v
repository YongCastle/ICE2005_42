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


    //============== Controller ================
    input                   fetch_run_i,
    output                  fetch_done_o,

    //============== DEBUGGING ================
    output wire [9:0]       cnt_img_row_o,
    output wire [9:0]       cnt_img_col_o


);

reg [9:0] cnt_img_row;
reg [9:0] cnt_img_col; 

wire fetch_done;
assign fetch_done     = ((cnt_img_row == 539) && (cnt_img_col == 539));

assign cnt_img_row_o = cnt_img_row;
assign cnt_img_col_o = cnt_img_col;



// BRAM Read Latency is 2 cycle So we need Delay
reg fetch_run_d, fetch_run_2d;
reg fetch_done_d, fetch_done_2d;
always @(posedge clk) begin
    if(!rst_n) begin
        fetch_run_d     <= 'd0;
        fetch_done_d    <= 'd0;
        fetch_run_2d    <= 'd0;
        fetch_done_2d   <= 'd0;
    end
    else begin
        fetch_run_d     <= fetch_run_i;
        fetch_done_d    <= fetch_done;
        fetch_run_2d    <= fetch_run_d;
        fetch_done_2d   <= fetch_done_d;
    end
end

// Address
reg [18:0]          addr;
always @(posedge clk) begin
    if(!rst_n) begin
        addr     <= 'd0;
    end
    else begin
        if(fetch_run_i && !fetch_done_o) begin
            if(addr == 540*540-1) begin
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
        if(fetch_run_i) begin
            if(cnt_img_col == 539) begin
                cnt_img_col     <= 'd0;

                if(cnt_img_row == 539) begin
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

// TO BRAM
assign ena_o            = (fetch_run_i)? 1'd1 : 1'd0;
assign wea_o            = 1'd0;
assign addr_o           = addr;
assign d2mem_o          = 'd0;

// TO PREPROCESS
assign data_o           = (fetch_run_2d)? mem2d_i : 'd0;

// TO CONTORLLER
assign fetch_done_o     = fetch_done_2d;

endmodule