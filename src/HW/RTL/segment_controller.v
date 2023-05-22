module segment_control(
    input wire              clk,
    input wire              rstb,
    input wire [9:0]        cnt_row,

    output wire [3:0]       seg_memory_0_o,
    output wire [3:0]       seg_memory_1,
    output wire [3:0]       seg_memory_2,
    output wire [3:0]       seg_memory_3,
    output wire [3:0]       seg_memory_4,
    output wire [3:0]       seg_memory_5,
    output wire [3:0]       seg_memory_6,
    output wire [3:0]       seg_memory_7
);

reg [3:0] seg_memory_0;

always @(posedge clk) 
begin 
   if (!rstb) 
   begin
      seg_memory_0 <= 4'b0000;
      seg_memory_1 <= 4'b0000;
      seg_memory_2 <= 4'b0000;
      seg_memory_3 <= 4'b0000;
      seg_memory_4 <= 4'b0000;
      seg_memory_5 <= 4'b0000;
      seg_memory_6 <= 4'b0000;
      seg_memory_7 <= 4'b0000; 
   end 
   else begin
        if (cnt_row < 10) // 한자리 cnt_row
        begin
            seg_memory_0 <= (cnt_row / 1) % 10;
            seg_memory_1 <= 4'b0000;
            seg_memory_2 <= 4'b0000;
            seg_memory_3 <= 4'b0000;
            seg_memory_4 <= 4'b0000;
            seg_memory_5 <= 4'b0000;
            seg_memory_6 <= 4'b0000;
            seg_memory_7 <= 4'b0000; 
        end
        else if (cnt_row < 100) // 두자리 cnt_row
        begin
            seg_memory_0 <= (cnt_row / 1) % 10;
            seg_memory_1 <= (cnt_row / 10) % 10;
            seg_memory_2 <= 4'b0000;
            seg_memory_3 <= 4'b0000;
            seg_memory_4 <= 4'b0000;
            seg_memory_5 <= 4'b0000;
            seg_memory_6 <= 4'b0000;
            seg_memory_7 <= 4'b0000; 
        end
        else if (cnt_row < 1000) // 세자리 cnt_row
        begin
            seg_memory_0 <= (cnt_row / 1) % 10;
            seg_memory_1 <= (cnt_row / 10) % 10;
            seg_memory_2 <= (cnt_row / 100) % 10;
            seg_memory_3 <= 4'b0000;
            seg_memory_4 <= 4'b0000;
            seg_memory_5 <= 4'b0000;
            seg_memory_6 <= 4'b0000;
            seg_memory_7 <= 4'b0000; 
        end
        else
        begin
            seg_memory_0 <= 4'b0000;
            seg_memory_1 <= 4'b0000;
            seg_memory_2 <= 4'b0000;
            seg_memory_3 <= 4'b0000;
            seg_memory_4 <= 4'b0000;
            seg_memory_5 <= 4'b0000;
            seg_memory_6 <= 4'b0000;
            seg_memory_7 <= 4'b0000; 
        end
    end        
end

assign seg_memory_0_o     = seg_memory_0;

endmodule