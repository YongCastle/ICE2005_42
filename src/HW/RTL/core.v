`timescale 1ns / 1ps
module core_module
(
    //input
    // 3x3 matrix elements
    input [7:0]              data_0_0_i,        // (0,0)
    input [7:0]              data_0_1_i,        // (0,1) 
    input [7:0]              data_0_2_i,        // (0,2) 
    input [7:0]              data_1_0_i,        // (1,0) 
    input [7:0]              data_1_1_i,        // (1,1) 
    input [7:0]              data_1_2_i,        // (1,2) 
    input [7:0]              data_2_0_i,        // (2,0) 
    input [7:0]              data_2_1_i,        // (2,1) 
    input [7:0]              data_2_2_i,        // (2,2) 
    
    input                     clk,                // CLK for synchronous

    input                    core_en_i,         //enable signal
    input reg  [9:0]         cnt_col_i,
    input reg  [9:0]         cnt_row_i,            
    
    //output
    output reg [7:0]         pixel_o,        //output to accumulator
    output reg               core_en_o,       // ++ pixel 계산이 끝나면, core_en_o 내보내줌.
    output reg  [9:0]         cnt_col_o,
    output reg  [9:0]         cnt_row_o       
);


//wire
 // gx, gy : -1020 ~ 1020 -> 11-bits
reg [10:0]             gx;             //max (0~255) * (+ or -)(1+2+1) => 10-bits + 1-bit for sign => 11-bits
reg [10:0]             gy;             //max (0~255) * (+ or -)(1+2+1) => 10-bits + 1-bit for sign => 11-bits

// abs gx,gy => G = |gx| + |gy|
reg [10:0]             abs_gx;
reg [10:0]             abs_gy;
// sum = G
reg [10:0]             sum;

always @ (posedge clk,core_en_i)
begin
    if(core_en_i)
    begin
        gx <= (data_0_0_i * (-1) + data_0_1_i * (0) + data_0_2_i * (1)+  // -1 | 0 | 1
               data_1_0_i * (-2) + data_1_1_i * (0) + data_1_2_i * (2)+  // -2 | 0 | 2
               data_2_0_i * (-1) + data_2_1_i * (0) + data_2_2_i * (1)); // -1 | 0 | 1
              
        gy <= (data_0_0_i * (1)  + data_0_1_i * (2)  + data_0_2_i * (1)+        //  1 |  2  |  1
               data_1_0_i * (0)  + data_1_1_i * (0)  + data_1_2_i * (0)+        //  0 |  0  |  0
               data_2_0_i * (-1) + data_2_1_i * (-2) + data_2_2_i * (-1));      // -1 | -2  | -1
    end           
    else
    begin 
        gx = 'd0;
        gy = 'd0;
    end     
end

always @ (gx,gy)
begin
    abs_gx <= (gx[10]? ~gx + 1 : gx);
    abs_gy <= (gy[10]? ~gy + 1 : gy);
end
               
always @ (abs_gx,abs_gy)
begin
    sum <= abs_gx + abs_gy;
end

always @ (sum,clk)
begin
    if (clk == 1'b1)
    begin
        pixel_o <= (sum > 255)? 8'b1111_1111 : 8'b0000_0000;
        core_en_o <= 1'b1;
        cnt_col_o <= cnt_col_i;
        cnt_row_o <= cnt_row_i;
    end
    else
        core_en_o <= 1'b0;
end
 
endmodule