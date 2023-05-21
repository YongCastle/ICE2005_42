//
// Description :
// SOBER_TOP
//     |
//     |______ preprocess.v
//     |______ core.v
//

module SOBEL_TOP
#(
    parameter       MAX_ROW = 540,
    parameter       MAX_COl = 540
)
(
    //========== SYSTEM =====================
    input wire              CLK,
    input wire              RST_N,

    //========== Memory Controller ==========
    input wire [7:0]        DATA_I,
    input wire              DATA_EN_I,

    //========== Controller ================
    input wire              CORE_RUN_I,
    output wire             CORE_DONE_O,

    //========== VGA ====================
    output wire [7:0]       PIXEL_O,
    output wire             PIXEL_EN_O
);

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
    .clk                    (CLK),
    .rst_n                  (RST_N),
    //======== Controller ===================
    .core_run_i             (CORE_RUN_I),
    .core_done_o            (CORE_DONE_O), 
    //======== Memory_Controller ============
    .data_i                 (DATA_I),
    .data_en_i              (DATA_EN_I),
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
    .pixel_o                (PIXEL_O), 
    .pixel_en_o             (PIXEL_EN_O)       
);

endmodule