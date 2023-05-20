`timescale 1ns/1ps
module tb_mem;

parameter        MAX_ROW = 540;
parameter        MAX_COL = 540;

reg rst_n;
reg CLK;

//Connection Wire
wire ena;
wire wea;
wire [18:0] addra;
wire [7:0] d2mem;
wire [7:0] mem2d;


blk_mem_gen_0 U_BRAM 
(
    .clka               (CLK),
    .rsta               (!rst_n),
    .ena                (ena),
    .wea                (wea),
    .addra              (addra),
    .dina               (d2mem),
    .douta              (mem2d),
    .rsta_busy          () 
);

wire [7:0]       data_o;
reg             fetch_run_i;
wire             fetch_done_o;

wire [9:0]  cnt_img_row_o;
wire [9:0]  cnt_img_col_o;

memory_controller U_MEM_CTR
(
    //============== SYSTEM ====================
    .clk                (CLK),
    .rst_n              (rst_n),    

    //============== BRAM ====================
    .ena_o              (ena),
    .wea_o              (wea),
    .addr_o             (addra),
    .d2mem_o            (d2mem),
    .mem2d_i            (mem2d),


    //============== PREPROCESS ==============
    .data_o             (data_o),

    //============== Controller ================
    .fetch_run_i        (fetch_run_i),
    .fetch_done_o       (fetch_done_o),

    //============== DEUBG ================
    .cnt_img_row_o      (cnt_img_row_o),
    .cnt_img_col_o      (cnt_img_col_o)
);

//clock
initial
begin
    forever
    begin
        #10 CLK = !CLK;
    end
end

reg fetch_run_i;

initial begin
    CLK         = 1'd0;
    fetch_run_i = 1'd0;
    rst_n       = 1'd0;
end

initial begin
    //RESET TSET
    #5;
    #40 fetch_run_i = 1'd1; 
    rst_n = 1'd0;

    // TEST START
    #60 rst_n = 'd1;
end

endmodule