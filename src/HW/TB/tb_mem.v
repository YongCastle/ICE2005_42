`timescale 1ns/1ps
module tb_mem;

parameter        MAX_ROW = 360;
parameter        MAX_COL = 540;

reg rst_n;
reg CLK;

//Connection Wire
wire                ena_w;
wire                wea_w;
wire [17:0]         addra_w;
wire [7:0]          d2mem_w;
wire [7:0]          mem2d_w;

// From MEM CONTROLLER
wire [7:0]          data_w;
wire                data_en_w;
wire [19:0]         cnt_fetch;
wire [17:0]         addr_temp;

blk_mem_gen_0 U_BRAM 
(
    .clka               (CLK),
    .rsta               (!rst_n),
    .ena                (ena_w),
    .wea                (wea_w),
    .addra              (addra_w),
    .dina               (d2mem_w),
    .douta              (mem2d_w),
    .rsta_busy          () 
);


reg                 MODE1_START_I;
reg                 MODE2_START_I;
reg                 START_I;
// From Controller
wire                fetch_run_w;
wire                fetch_done_w;
reg                core_done_w;
wire                core_run_w;
wire  [19:0]        cnt_len_w;

wire                mode1_done_w;
wire                is_mode1_w;
wire                mode1_run_w;
wire                is_mode2_w;
// From SOBEL TOP
wire  [7:0]         md1_pixel_w;
wire  [7:0]         md2_pixel_w;
wire                md1_pixel_en_w;
wire                md2_pixel_en_w;

wire  [9:0]         cnt_img_row_w;
wire  [9:0]         cnt_img_col_w;
wire                fetch_start;
wire [2:0]          state;
memory_controller U_MEM_CTR
(
    //============== SYSTEM ====================
    .clk                (CLK),
    .rst_n              (rst_n),    

    //============== BRAM ====================
    .ena_o              (ena_w),
    .wea_o              (wea_w),
    .addr_o             (addra_w),
    .d2mem_o            (d2mem_w),
    .mem2d_i            (mem2d_w),


    //============== PREPROCESS ==============
    .data_o             (data_w),
    .data_en_o          (data_en_w),

    //============== Controller ================
    .is_mode1_i         (is_mode1_w),
    .is_mode2_i         (is_mode2_w),
    .mode1_run_i        (mode1_run_w),
    .mode1_done_o       (mode1_done_w),
    .fetch_run_i        (fetch_run_w),
    .fetch_done_o       (fetch_done_w),
    .cnt_len_i          (cnt_len_w),

    //============== DEUBG ================
    .cnt_img_row_o      (cnt_img_row_w),
    .cnt_img_col_o      (cnt_img_col_w),

    // ============== VGA ====================
    .pixel_o            (md1_pixel_w),
    .pixel_en_o         (md1_pixel_en_w),
    .cnt_fetch_o          (cnt_fetch),
    .addr_temp_o          (addr_temp),
    .fetch_start_o        (fetch_start)
);

controller_module U_CONTROLLER
(
    //============== SYSTEM ====================
    .clk                (CLK),
    .rst_n              (rst_n),
    //======================= Switch ================
    .mode1_start_i      (MODE1_START_I),
    .mode2_start_i      (MODE2_START_I),
    .start_i            (START_I),
    .led_idle_o         (),
    //============ Memory Controller ==================
    .fetch_done_i       (fetch_done_w),
    .cnt_img_row_i      (cnt_img_row_w),
    .mode1_done_i       (mode1_done_w),
    .is_mode1_o         (is_mode1_w),
    .mode1_run_o        (mode1_run_w),
    .is_mode2_o         (is_mode2_w),
    .fetch_run_o        (fetch_run_w),
    .cnt_len_o          (cnt_len_w),
    //=============== Preprocessor ==================
    .core_done_i        (core_done_w),
    .core_run_o         (core_run_w),
    //================ 7-Segment ==========================
    .cnt_img_row_o      (),
    //==================== For Debugging ============================
    .state_o            (state)
);

integer cnt;

//clock
initial
begin
    forever
    begin
        #10 CLK = !CLK;
    end
end

initial begin
    CLK                 = 1'd0;
    MODE1_START_I       = 1'd0;
    MODE2_START_I       = 1'd0;
    START_I             = 1'd0;
    rst_n               = 1'd0;
end
initial begin
    //RESET TSET
    #5;
    #20 MODE1_START_I = 1'd1; 
    rst_n = 1'd0;

    #20 MODE2_START_I = 1'd1;
    #20 MODE1_START_I = 1'd0;
    MODE2_START_I = 1'd0; 

    // TEST START
    // MODE 1 START 
    #20 rst_n = 'd1;
    #20 MODE1_START_I = 1'd1; MODE2_START_I = 1'd0; 
    #20 START_I = 'd1;
    #20 START_I = 'd0;


    #100 rst_n = 'd1;
    #20 MODE1_START_I = 1'd1; MODE2_START_I = 1'd0; 
    #20 START_I = 'd1;
    #40 START_I = 'd0;
    #3000000;
    //RESET TEST
    #100 rst_n = 'd0;
    #100 rst_n = 'd1;
    #20 START_I = 'd1;
    #40 START_I = 'd0;
    // MODE 2 START --> SOBEL -->  VGA ON
    #40000 core_done_w = 'd1;
    #20      core_done_w = 'd0;
    #40000 core_done_w = 'd1;
    #20      core_done_w = 'd0;
    for(cnt=0; cnt<360; cnt++)
    begin    
        #40000 core_done_w = 'd1;
        #20      core_done_w = 'd0;
    end
    #6000000 rst_n       = 'd1;

    // #20 rst_n               = 'd1;
    // #20 MODE1_START_I       = 1'd0; MODE2_START_I           = 1'd1; 
    // #20 START_I             = 'd1;
    // #20 START_I             = 'd0;

end



endmodule