`timescale 1ns / 1ps



module TB_SOC;



reg                 rst_n;
reg                 clk;

reg                 MODE1_START_I;
reg                 MODE2_START_I;
reg                 START_I;
reg                 BUZZER_MODE_I;
reg                 bram_en_w;

reg                 tft_iclk;

reg [7:0]           RGB_O;
reg                 RGB_EN_O;

TOP_SOC U_TOP_SOC
(
    .clk                        (clk),
    .rst_n                      (rst_n),
    //-----------SWITCH-----------------------
    .MODE1_START_I              (MODE1_START_I),  //SW1
    .MODE2_START_I              (MODE2_START_I),  //SW2
    .BUZZER_MODE_I              (BUZZER_MODE_I),  //SW3

    .START_I                    (START_I),
    .VGA_START_I                (bram_en_w),

    //-------------LED-----------------------
    .LED1_ON_o                  (),
    .LED2_ON_o                  (),

    //--------------VGA output-----------------
    .tft_iclk                   (tft_iclk),

    .RGB_O                      (RGB_O),
    .RGB_EN_O                   (RGB_EN_O),

    //-------------SEGEMNT_-------------------
    .digit_o                    (),
    .seg_data_o                 (),

    //-------------BUZZER-------------------
    .buzzer_out_o               ()
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
