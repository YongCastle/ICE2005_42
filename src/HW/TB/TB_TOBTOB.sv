`timescale 1ns / 1ps

module TB_TOBTOB;


//=========== SET PARAMETER ======================
parameter        MAX_ROW = 540;
parameter        MAX_COL = 540;




//=========== TEST BENCH IN ======================
reg                 rst_n;
reg                 clk;
reg                 tft_iclk;
reg                 MODE1_START_I;
reg                 MODE2_START_I;
reg                 START_I;
reg                 BUZZER_MODE_I;
reg                 bram_en_w;


//================ MODEL Wiring =================


reg [7:0]                PIXEL_W;
reg                      PIXEL_EN_W;

// ================ DPBRAM ================
wire                dena_w;
wire                dwea_w;
wire [18:0]         daddra_w;
wire [7:0]          dd2mema_w;
wire [7:0]          dmem2da_w;

wire                denb_w;
wire                dweb_w;
wire [18:0]         daddrb_w;
wire [7:0]          dd2memb_w;
wire [7:0]          dmem2db_w;


// ============== VGA INPUT =================
reg [7:0]                RGB_W;
reg                      RGB_EN_W;

TOP_SOC U_TOP_SOC
(
    .clk                    (clk),
    .rst_n                  (rst_n),
    //-----------SWITCH-----------------------
    .MODE1_START_I          (MODE1_START_I),  //SW1
    .MODE2_START_I          (MODE2_START_I),  //SW2
    .BUZZER_MODE_I          (BUZZER_MODE_I),  //SW3

    .START_I                (START_I),

    //-------------LED-----------------------
    .LED1_ON_o              (LED1_ON_o),
    .LED2_ON_o              (LED2_ON_o),

    //--------------VGA INPUT-----------------
    .PIXEL_O                (PIXEL_W),
    .PIXEL_EN_O             (PIXEL_EN_W),

    //-------------SEGEMNT_-------------------
    .digit_o                (digit_o),
    .seg_data_o             (seg_data_o),

    //-------------BUZZER-------------------
    .buzzer_out_o           (buzzer_out_o)
);


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
    #1000 rst_n         = 'd0;
    #100 rst_n          = 'd1;
    // #20 rst_n               = 'd1;
    // #20 MODE1_START_I       = 1'd0; MODE2_START_I           = 1'd1; 
    // #20 START_I             = 'd1;
    // #20 START_I             = 'd0;

end

endmodule