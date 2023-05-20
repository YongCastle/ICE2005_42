//
// Description :
// SOBER_TOP
//     |______ Controller.v
//     |______ preprocess.v
//     |______ core.v
//

module SOBER_TOP
(
    //========== INPUT ======================

    //========== SYSTEM =====================
    input wire              CLK,
    input wire              RST_N,

    //========== Memory Controller ==========
    input wire [7:0]        DATA_I,
    input wire              DATA_EN_I,

    //========== Controller ================
    input wire              CORE_RUN_I,

    //========== OUTPUT ====================

    //========== Accmulator ====================
    output wire [7:0]       PIXEL_O,
    output wire             EN_O,
    //output wire [9:0]       cnt_buf_row,
    //output wire [9:0]       cnt_buf_col,
    //========== Controller ================
    output wire              CORE_DONE_O

    //========== VGA ==============

    //========== 7-Segment ============== 
    
     //========== Switch ==============

);

reg [7:0]       DATA_0_0_O;
reg [7:0]       DATA_0_1_O;
reg [7:0]       DATA_0_2_O;
reg [7:0]       DATA_1_0_O;
reg [7:0]       DATA_1_1_O;
reg [7:0]       DATA_1_2_O;
reg [7:0]       DATA_2_0_O;
reg [7:0]       DATA_2_1_O;
reg [7:0]       DATA_2_2_O;


preprocess_module U_pre 
(
    .clk                    (CLK),
    .rst_n                  (RST_N),
    .core_run_i             (CORE_RUN_I),
    .data_i                 (DATA_I),
    .data_en_i              (DATA_EN_I),  // input
    .core_done_o            (CORE_DONE_O), 
    .core_en_o              (CORE_EN_O),
    .data_0_0_o             (DATA_0_0_O),
    .data_0_1_o             (DATA_0_1_O),
    .data_0_2_o             (DATA_0_2_O),
    .data_1_0_o             (DATA_1_0_O),
    .data_1_1_o             (DATA_1_1_O),
    .data_1_2_o             (DATA_1_2_O),
    .data_2_0_o             (DATA_2_0_O),
    .data_2_1_o             (DATA_2_1_O),
    .data_2_2_o             (DATA_2_2_O) //output
);

U_CORE core
(
    .clk                    (CLK),
    .core_en_i              (CORE_EN_O),
    .data_0_0_i             (DATA_0_0_O),
    .data_0_1_i             (DATA_0_1_O),
    .data_0_2_i             (DATA_0_2_O),
    .data_1_0_i             (DATA_1_0_O),
    .data_1_1_i             (DATA_1_1_O),
    .data_1_2_i             (DATA_1_2_O),
    .data_2_0_i             (DATA_2_0_O),
    .data_2_1_i             (DATA_2_1_O),
    .data_2_2_i             (DATA_2_2_O), // input
    .pixle_o                (PIXEL_O), 
    .en_o                   (EN_O)              // output
);

endmodule