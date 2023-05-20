`timescale 1ns / 1ps

module accumulator_module // vga를 켜주는역활
#(
    parameter       MAX_ROW = 540, // 그림의 size = 540x540
    parameter       MAX_COL = 540
)
(
    input wire                 clk,

    // from core        
    input wire                 en_i,                      // EN=1일때(core에서 계산이 끝나면) data_i가 accumulator에 채워짐
    
    // from core
    input wire  [7:0]          data_i,                   // EN=1일때, core에서 계산이 끝난 data가 accumulator에 채워짐
    
    // from preprocesser
    input wire  [9:0]         cnt_col,
    input wire  [9:0]         cnt_row,                  

    // to vga
    output reg   [7:0]       data_o[0:539],                     // buffer에 하나씩 저장된값이 다 채워지면, 1줄을 내보냄

    // to preprocesser
    output reg                vga_done,                 // core에서 들어오는 cnt_col = 539일때, vga에 1줄을 내보내줌
    output reg  [9:0]         seg_done,                  // core에서 들어오는 cnt_row = seg_done으로 , 7-segment에 보낼수 있도록함.   
    output reg                buf_done       
);

reg [7:0] memory [0:539];


always @ (posedge clk,en_i) // asynchronuous EN
begin
    if(en_i)
    begin
        if(cnt_col != 539)
        begin
            memory[cnt_col] <= data_i; // EN='1'일때, memory[cnt_row] = data_i 가 저장됨
        end
        else
        begin
            data_o <= memory; // cnt_col = 539일때, core에서 들어온 539개의 pixel들이 data_o에 으로 출력댐
        end
    end
end

always @ (cnt_col)
begin
    if(cnt_col == 539)
    begin
        vga_done <= 1'b1; // cnt_col = 539일때, vga_done =1 -> vga에 1줄 출력
        buf_done <= 1'b1;
    end
    else
    begin
        vga_done <= 1'b0; // cnt_col = 539이 아닐때,  vga_done =0 -> vga에 출력x
        buf_done <= 1'b0;
    end   
end

always @ (cnt_row)
begin  
    seg_done <= cnt_row; // core에서 들어온 cnt_row = seg_done으로 되어, seg_done에서 integer로 사용가능..?
end

endmodule