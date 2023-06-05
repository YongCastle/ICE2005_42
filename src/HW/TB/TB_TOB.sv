`timescale 1ns/1ps

module TB_TOB();

//=========== SET PARAMETER ======================
parameter        MAX_ROW = 540;
parameter        MAX_COL = 540;


//=========== SET WIRE, REG ======================
reg                 rst_n;
reg                 clk;

reg                 MODE1_START_I;
reg                 MODE2_START_I;
reg                 START_I;
reg                 BUZZER_MODE_I;
reg                 bram_en_w;

// =======================================================
// From BRAM
wire                ena_w;
wire                wea_w;
wire [17:0]         addra_w;
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
wire [2:0] state;
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
    .led_idle_o         (LED_IDLE_O),
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
reg LED1_ON_o;
reg LED2_ON_o;
assign led1_on        = MODE1_START_I;
assign led2_on        = MODE2_START_I;
assign LED1_ON_o      = led1_on;
assign LED2_ON_o      = led2_on;


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

wire                dena_w;
wire                dwea_w;
wire [18:0]         daddra_w;
wire [7:0]          dd2mema_w;
wire [7:0]          dmem2da_w;

mem_ctr_A   U_DPBRAM_CTR_A
(
    .clk                    (clk),
    .rst_n                  (rst_n),

    //============== BRAM ====================
    .ena_o                  (dena_w),
    .wea_o                  (dwea_w),               // 1 : Write    , 0 : READ
    .addra_o                (daddra_w),
    .d2mema_o               (dd2mema_w),           

    .mem2da_i               (dmem2da_w),           // Not Using. Do Not READ

    //============== PIXEL INPUT ====================
    .pixel_i                (PIXEL_W),
    .pixel_en_i             (PIXEL_EN_W)
);

wire                denb_w;
wire                dweb_w;
wire [17:0]         daddrb_w;
wire [7:0]          dd2memb_w;
wire [7:0]          dmem2db_w;

reg                 tft_iclk;

blk_mem_gen_1 U_BRAM1
(
    //------------ PORT A-------------------
    .clka               (clk),
    .rsta               (!rst_n),
    .ena                (dena_w),
    .wea                (dwea_w),
    .addra              (daddra_w),
    .dina               (dd2mema_w),
    .douta              (dmem2da_w),
    .rsta_busy          (), 
    //------------ PORT B-------------------
    .clkb               (tft_iclk),
    .rstb               (!rst_n),
    .enb                (denb_w),
    .web                (dweb_w),
    .addrb              (daddrb_w),
    .dinb               (dd2memb_w),
    .doutb              (dmem2db_w),
    .rstb_busy          () 
);


reg [7:0]                RGB_W;
reg                      RGB_EN_W;

mem_ctr_B U_DPBRAM_CTR_B
(
    .clk                (tft_iclk),
    .rst_n              (rst_n),
    .enb_o              (denb_w),
    .web_o              (dweb_w),
    .addrb_o            (daddrb_w),
    .d2memb_o           (dd2memb_w),
    .mem2db_i           (dmem2db_w),
    .bram_en_i          (bram_en_w),
    
    .RGB_o              (RGB_W),
    .RGB_en_o           (RGB_EN_W)
);





//clock
initial
begin
    forever
    begin
        #10 clk = !clk;
        #5 tft_iclk = !tft_iclk;
    end
end

initial begin
    clk                 = 1'd0;
    MODE1_START_I       = 1'd0;
    MODE2_START_I       = 1'd0;
    START_I             = 1'd0;
    BUZZER_MODE_I       = 1'd0;
    rst_n               = 1'd0;
    tft_iclk            = 1'd0;
    bram_en_w           = 1'd0;
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
    #6000000 rst_n       = 'd1;
    #20 bram_en_w           = 'd1;
    #1000 bram_en_w           = 'd0;

    #40 bram_en_w           = 'd1;
    // #20 rst_n               = 'd1;
    // #20 MODE1_START_I       = 1'd0; MODE2_START_I           = 1'd1; 
    // #20 START_I             = 'd1;
    // #20 START_I             = 'd0;

end


endmodule
