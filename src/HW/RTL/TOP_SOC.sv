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
    //-----------SWITCH-----------------------
    input wire              MODE1_START_I,  //SW1
    input wire              MODE2_START_I,  //SW2
    input wire              BUZZER_MODE_I,  //SW3

    input wire              START_I,

    //-------------LED-----------------------
    output wire             LED1_ON_o,
    output wire             LED2_ON_o,

    //--------------VGA INPUT-----------------
    output wire [7:0]       PIXEL_O,
    output wire             PIXEL_EN_O,

    //-------------SEGEMNT_-------------------
    output wire [3:0]       digit_o,
    output wire [6:0]       seg_data_o,

    //-------------BUZZER-------------------
    output wire             buzzer_out_o
);



//=========== SET PARAMETER ======================
parameter        MAX_ROW = 540;
parameter        MAX_COL = 540;


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

//============== FOR DEBUGGING =============
wire [2:0] state, state_n;
wire [9:0] cnt_img_row, cnt_img_col;
// ==========================================

blk_mem_gen_0 U_BRAM0
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
    .is_mode1_i         (is_mode1_w),
    .is_mode2_i         (is_mode2_w),
    .mode1_run_i        (mode1_run_w),
    .mode1_done_o       (mode1_done_w),
    .fetch_run_i        (fetch_run_w),
    .fetch_done_o       (fetch_done_w),
    .cnt_len_i          (cnt_len_w),

    //============== DEUBG ================
    .cnt_img_row_o      (cnt_img_row),
    .cnt_img_col_o      (cnt_img_col),

    // ============== VGA ====================
    .pixel_o            (md1_pixel_w),
    .pixel_en_o         (md1_pixel_en_w)
);

controller_module U_CONTROLLER
(
    //============== SYSTEM ====================
    .clk                (clk),
    .rst_n              (rst_n),
    //======================= Switch ================
    .mode1_start_i      (MODE1_START_I),
    .mode2_start_i      (MODE2_START_I),
    .start_i            (START_I),
    //============ Memory Controller ==================
    .fetch_done_i       (fetch_done_w),
    .cnt_img_row_i      (cnt_img_row),
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
    .cnt_img_row_o      (cnt_img_row_w),
    //==================== For Debugging ============================
    .state_o            (state)
);

reg led1_on;
reg led2_on;

assign led1_on        = MODE1_START_I;
assign led2_on        = MODE2_START_I;
assign LED1_ON_o      = (!rst_n)? 'd0: led1_on;
assign LED2_ON_o      = (!rst_n)? 'd0: led2_on;


wire [7:0]       DATA_0_0;
wire [7:0]       DATA_0_1;
wire [7:0]       DATA_0_2;
wire [7:0]       DATA_1_0;
wire [7:0]       DATA_1_1;
wire [7:0]       DATA_1_2;
wire [7:0]       DATA_2_0;
wire [7:0]       DATA_2_1;
wire [7:0]       DATA_2_2;

wire             core_en_w;

preprocess_module U_pre
(
    //======== SYSTEM ========================
    .clk                    (clk),
    .rst_n                  (rst_n),
    //======== Controller ===================
    .core_run_i             (core_run_w),
    .core_done_o            (core_done_w), 
    //======== Memory_Controller ============
    .data_i                 (data_w),
    .data_en_i              (data_en_w),
    //======== CORE =========================
    .data_0_0_o             (DATA_0_0),
    .data_0_1_o             (DATA_0_1),
    .data_0_2_o             (DATA_0_2),
    .data_1_0_o             (DATA_1_0),
    .data_1_1_o             (DATA_1_1),
    .data_1_2_o             (DATA_1_2),
    .data_2_0_o             (DATA_2_0),
    .data_2_1_o             (DATA_2_1),
    .data_2_2_o             (DATA_2_2),
    .core_en_o              (core_en_w)
);

core_module U_CORE
(
    //======== SYSTEM ========================
    .clk                    (clk),
    .rst_n                  (rst_n),
    //======== Preprocess ===================
    .data_0_0_i             (DATA_0_0),
    .data_0_1_i             (DATA_0_1),
    .data_0_2_i             (DATA_0_2),
    .data_1_0_i             (DATA_1_0),
    .data_1_1_i             (DATA_1_1),
    .data_1_2_i             (DATA_1_2),
    .data_2_0_i             (DATA_2_0),
    .data_2_1_i             (DATA_2_1),
    .data_2_2_i             (DATA_2_2),
    .core_en_i              (core_en_w),
    //======== VGA ===================
    .pixel_o                (md2_pixel_w), 
    .pixel_en_o             (md2_pixel_en_w)       
);


segment U_SEGMENT
(
    .clk            (clk),
    .rst_n          (rst_n),

    .cnt_row_i      (cnt_img_row_w),

    .digit_o        (digit_o),
    .seg_data_o     (seg_data_o)
);


buzzer_module U_BUZZER (
    .clk            (clk),
    .rst_n          (rst_n),
    .play_tone_i    (BUZZER_MODE_I),
    .buzzer_out_o   (buzzer_out_o)
);



reg  [7:0]         PIXEL_W;
reg                PIXEL_EN_W;
always @(*) begin
    PIXEL_W         = 'd0;
    PIXEL_EN_W      = 'd0;
    case({md1_pixel_en_w, md2_pixel_en_w})
        //mode1 START
        'b10: begin
            PIXEL_W     = md1_pixel_w;
            PIXEL_EN_W  = md1_pixel_en_w;
        end
        //mode1 START
        'b01: begin
            PIXEL_W     = md2_pixel_w;
            PIXEL_EN_W  = md2_pixel_en_w;
        end
        default: begin
            PIXEL_W     = 'd0;
            PIXEL_EN_W  = 'd0;
        end
    endcase
end

assign PIXEL_O          = PIXEL_W;
assign PIXEL_EN_O       = PIXEL_EN_W;


endmodule