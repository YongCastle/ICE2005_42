`timescale 1ns / 1ps

module TOPTOP_SOC
(
    input wire              host_CLK,
    input wire              rst_n,
    //-----------SWITCH-----------------------
    input wire              MODE1_START_I,  //SW1
    input wire              MODE2_START_I,  //SW2
    input wire              BUZZER_MODE_I,  //SW3

    input wire              START_I,

    //-------------LED-----------------------
    output wire             LED1_ON_o,
    output wire             LED2_ON_o,

    //-------------SEGEMNT_-------------------
    output wire [3:0]       digit_o,
    output wire [6:0]       seg_data_o,

    //-------------BUZZER-------------------
    output wire             buzzer_out_o,

    //----------- - VGA -------------------
    output wire             vga_vs_o,
    output wire             vga_hs_o,
    output wire [3:0]       vga_r_o,
    output wire [3:0]       vga_g_o,
    output wire [3:0]       vga_b_o
);


//-------------INPUT PIXEL --------------------
wire [7:0]      PIXEL_W;
wire            PIXEL_EN_W;


//-------------DPBRAM A PORT---------------------
wire [18:0]     addra_w;
wire            ena_w;
wire            wea_w;
wire            d2mema_w;
wire            mem2da_w;

//-------------DPBRAM B PORT---------------------
wire [18:0]     addrb_w;
wire            enb_w;
wire            web_w;
wire            mem2db_w;
wire            d2memb_w;

//------------- DATA --------------------
wire [7:0]      DATA_W;
wire            DATA_EN_W;
wire            bran_en_w;


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
    .ena_o                  (ena_w),
    .wea_o                  (wea_w),               // 1 : Write    , 0 : READ
    .addra_o                (addra_w),
    .d2mema_o               (d2mema_w),           

    .mem2da_i               (mem2da_w),           // Not Using. Do Not READ

    //============== PIXEL INPUT ====================
    .pixel_i                (PIXEL_W),
    .pixel_en_i             (PIXEL_EN_W)
);


blk_mem_gen_1 U_BRAM1
(
    //------------ PORT A-------------------
    .clka               (clk),
    .rsta               (!rst_n),
    .ena                (ena_w),
    .wea                (wea_w),
    .addra              (addra_w),
    .dina               (d2mema_w),
    .douta              (mem2da_w),
    .rsta_busy          () 
    //------------ PORT B-------------------
    .clkb               (),
    .rstb               (),
    .enb                (),
    .web                (),
    .addrb              (),
    .dinb               (),
    .doutb              (),
    .rstb_busy          () 
);

endmodule