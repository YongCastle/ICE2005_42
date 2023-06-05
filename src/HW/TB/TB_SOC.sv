`timescale 1ns / 1ps



module TB_SOC;



reg                 rst_n;
reg                 clk;

reg                 MODE1_START_I;
reg                 MODE2_START_I;
reg                 START_I;
reg                 BUZZER_MODE_I;
reg                 bram_en_w;


wire                LED1_ON_o;
wire                LED2_ON_o;
wire                LED_IDLE_O;

wire                vga_hs_o;
wire                vga_vs_o;

wire [3:0]          vga_r_o;
wire [3:0]          vga_g_o;
wire [3:0]          vga_b_o;

wire [3:0]          digit_o;
wire [6:0]          seg_data_o;

wire                buzzer_out_o;

wire [9:0]         cnt_img_row_w;    
TOP_SOC U_TOP_SOC
(
    .clk                        (clk),
    .rst_n                      (rst_n),
    //-----------SWITCH-----------------------
    .MODE1_START_I              (MODE1_START_I),  //SW1
    .MODE2_START_I              (MODE2_START_I),  //SW2
    .BUZZER_MODE_I              (BUZZER_MODE_I),  //SW3

    .START_I                    (START_I),

    //-------------LED-----------------------
    .LED1_ON_o                  (LED1_ON_o),
    .LED2_ON_o                  (LED2_ON_o),
    .LED_IDLE_O                 (LED_IDLE_O),
    //--------------VGA output-----------------
    .vga_hs_o                   (vga_hs_o),
    .vga_vs_o                   (vga_vs_o),

    .vga_r_o                    (vga_r_o),
    .vga_g_o                    (vga_g_o),
    .vga_b_o                    (vga_b_o),

    //-------------SEGEMNT_-------------------
    .digit_o                    (digit_o),
    .seg_data_o                 (seg_data_o),

    //-------------BUZZER-------------------
    .buzzer_out_o               (buzzer_out_o),

    .cnt_img_row_o              (cnt_img_row_w)
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
    clk                 = 1'd0;
    MODE1_START_I       = 1'd0;
    MODE2_START_I       = 1'd0;
    START_I             = 1'd0;
    BUZZER_MODE_I       = 1'd0;
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
    #20 MODE1_START_I = 1'd0; MODE2_START_I = 1'd1; 
    #20 START_I = 'd1;
    #20 START_I = 'd0;


    #100 rst_n = 'd1;
    #20 MODE1_START_I = 1'd0; MODE2_START_I = 1'd1; 
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
    #20 MODE1_START_I = 1'd0; MODE2_START_I = 1'd1;
    #20 START_I = 'd1;
    #40 START_I = 'd0;

    // #20 rst_n               = 'd1;
    // #20 MODE1_START_I       = 1'd0; MODE2_START_I           = 1'd1; 
    // #20 START_I             = 'd1;
    // #20 START_I             = 'd0;

end

endmodule