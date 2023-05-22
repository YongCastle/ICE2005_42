`timescale 1ns / 1ps

reg clk;
reg rstb;
reg [9:0] cnt_row;

reg [3:0] seg_memory_0;
reg [3:0] seg_memory_1;
reg [3:0] seg_memory_2;
reg [3:0] seg_memory_3;
reg [3:0] seg_memory_4;
reg [3:0] seg_memory_5;
reg [3:0] seg_memory_6;
reg [3:0] seg_memory_7;

wire [3:0] digit_0;
wire [3:0] digit_1;
wire [3:0] digit_2;
wire [3:0] digit_3;
wire [3:0] digit_4;
wire [3:0] digit_5;
wire [3:0] digit_6;
wire [3:0] digit_7;

wire [6:0] seg_data_0;
wire [6:0] seg_data_1;
wire [6:0] seg_data_2;
wire [6:0] seg_data_3;
wire [6:0] seg_data_4;
wire [6:0] seg_data_5;
wire [6:0] seg_data_6;
wire [6:0] seg_data_7;

module segment_top(
    input clk,
    input rstb,
    input [9:0] cnt_row,
    
    output [3:0] digit_0,
    output [3:0] digit_1,
    output [3:0] digit_2,
    output [3:0] digit_3,
    output [3:0] digit_4,
    output [3:0] digit_5,
    output [3:0] digit_6,
    output [3:0] digit_7,
    
    output reg [6:0] seg_data_0,
    output reg [6:0] seg_data_1,
    output reg [6:0] seg_data_2,
    output reg [6:0] seg_data_3,
    output reg [6:0] seg_data_4,
    output reg [6:0] seg_data_5,
    output reg [6:0] seg_data_6,
    output reg [6:0] seg_data_7
    );
    
segment_control segment_cont 
(
    .clk(clk),
    .rstb(rstb),
    .cnt_row(cnt_row),
    .seg_memory_0(seg_memory_0),
    .seg_memory_1(seg_memory_1),
    .seg_memory_2(seg_memory_2),
    .seg_memory_3(seg_memory_3),
    .seg_memory_4(seg_memory_4),
    .seg_memory_5(seg_memory_5),
    .seg_memory_6(seg_memory_6),
    .seg_memory_7(seg_memory_7)
);

segment segment_0
(
    .rstb(rst),
    .clk(clk),
    .seg_memory(seg_memory_0),
    .seg_data(seg_data_0),
    .digit(digit_0)
);

segment segment_1
(
    .rstb(rst),
    .clk(clk),
    .seg_memory(seg_memory_1),
    .seg_data(seg_data_1),
    .digit(digit_1)
);

segment segment_2
(
    .rstb(rst),
    .clk(clk),
    .seg_memory(seg_memory_2),
    .seg_data(seg_data_2),
    .digit(digit_2)
);

segment segment_3
(
    .rstb(rst),
    .clk(clk),
    .seg_memory(seg_memory_3),
    .seg_data(seg_data_3),
    .digit(digit_3)
);

segment segment_4
(
    .rstb(rst),
    .clk(clk),
    .seg_memory(seg_memory_4),
    .seg_data(seg_data_4),
    .digit(digit_4)
);

segment segment_5
(
    .rstb(rst),
    .clk(clk),
    .seg_memory(seg_memory_5),
    .seg_data(seg_data_5),
    .digit(digit_5)
);

segment segment_6
(
    .rstb(rst),
    .clk(clk),
    .seg_memory(seg_memory_6),
    .seg_data(seg_data_6),
    .digit(digit_6)
);

segment segment_7
(
    .rstb(rst),
    .clk(clk),
    .seg_memory(seg_memory_7),
    .seg_data(seg_data_7),
    .digit(digit_7)
);

endmodule