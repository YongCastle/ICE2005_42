//
// Description :
//                  TOP_SOC
//                   |______ switch.v
//                   |______ 7_segment.v
//                   |______ LED.v
//                   |______ buzzer.v
//                   |
//                   |______ BRAM_INST
//                   |______ SOBER_TOP.v
//                   |______ vga_buffer.v
//                   |______ vga_port.v
//
`timescale 1ns / 1ps

module TOP_SOC
(
    input wire              clk,
    input wire              rst_n,
    input wire              START_I,
    output wire [7:0]       PIXEL_O,
    output wire             PIXEL_EN_O
);


//=========== SET PARAMETER ======================
parameter        MAX_ROW = 540;
parameter        MAX_COL = 540;


//=========== SET WIRE, REG ======================
reg                 rst_n;
reg                 clk;


// From BRAM
wire                ena_w;
wire                wea_w;
wire [18:0]         addra_w;
wire [7:0]          d2mem_w;
wire [7:0]          mem2d_w;

// From MEM CONTROLLER
wire [7:0]          data_w;
wire                data_en_w;

// From Controller
wire                fetch_run_w;
wire                fetch_done_w;
wire                core_done_w;
wire                core_run_w;
wire  [19:0]        cnt_len_w;

// From SOBEL TOP
wire  [7:0]         PIXEL_W;
wire                PIXEL_EN_W;


//============== FOR DEBUGGING =============
wire [2:0] state, state_n;
wire [9:0] cnt_img_row, cnt_img_col;
// ==========================================

blk_mem_gen_0 U_BRAM 
(
    .clka               (clk),
    .rsta               (!rst_n),
    .ena                (ena_w),
    .wea                (wea_w),
    .addra              (addra_w),
    .dina               (d2mem_w),
    .douta              (mem2d_w),
    .rsta_busy          () 
);


memory_controller U_MEM_CTR
(
    //============== SYSTEM ====================
    .clk                (clk),
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
    .fetch_run_i        (fetch_run_w),
    .fetch_done_o       (fetch_done_w),
    .cnt_len_i          (cnt_len_w),

    //============== DEUBG ================
    .cnt_img_row_o      (cnt_img_row),
    .cnt_img_col_o      (cnt_img_col)
);

controller_module U_CONTROLLER
(
    //============== SYSTEM ====================
    .clk                (clk),
    .rst_n              (rst_n),
    //======================= Switch ================
    .start_i            (START_I),
    //============ Memory Controller ==================
    .fetch_done_i       (fetch_done_w),
    .cnt_img_row_i      (cnt_img_row),
    .fetch_run_o        (fetch_run_w),
    .cnt_len_o          (cnt_len_w),
    //=============== Preprocessor ==================
    .core_done_i        (core_done_w),
    .core_run_o         (core_run_w),
    //==================== For Debugging ============================
    .state_o            (state),    
    .state_n_o          (state_n)
);

SOBEL_TOP U_SOBEL_TOP
(
    //========== SYSTEM =====================
    .CLK            (clk),
    .RST_N          (rst_n),

    //========== Memory Controller ==========
    .DATA_I         (data_w),
    .DATA_EN_I      (data_en_w),

    //========== Controller ================
    .CORE_RUN_I     (core_run_w),
    .CORE_DONE_O    (core_done_w),

    //========== VGA ====================
    .PIXEL_O        (PIXEL_W),
    .PIXEL_EN_O     (PIXEL_EN_W)
);

assign PIXEL_O          = PIXEL_W;
assign PIXEL_EN_O       = PIXEL_EN_W;

endmodule