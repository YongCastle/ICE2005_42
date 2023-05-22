`timescale 1ns/1ps

module TB_TOB();

//=========== SET PARAMETER ======================
parameter        MAX_ROW = 540;
parameter        MAX_COL = 540;


//=========== SET WIRE, REG ======================
reg                 rst_n;
reg                 clk;

reg                 START_I;

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
wire  [7:0]         pixel_w;
wire                pixel_en_w;




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
    .pixel_o                (pixel_w), 
    .pixel_en_o             (pixel_en_w)       
);


//clock
initial
begin
    forever
    begin
        #10 clk = !clk;
    end
end

initial begin
    clk         = 1'd0;
    START_I = 1'd0;
    rst_n       = 1'd0;
end

initial begin
    //RESET TSET
    #5;
    #40 START_I = 1'd1; 
    rst_n = 1'd0;

    // TEST START
    #60 rst_n = 'd1;
end


endmodule
