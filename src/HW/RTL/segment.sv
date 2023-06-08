module segment
(
    input wire clk,
    input wire rst_n,
    input wire [9:0] cnt_row_i,

    output wire [3:0] digit_o,
    output wire [6:0] seg_data_o
);

reg [3:0] digit;
reg [6:0] seg_data;

reg [3:0] seg_memory_0;
reg [3:0] seg_memory_1;
reg [3:0] seg_memory_2;
reg [3:0] seg_memory_3;


always @(posedge clk or negedge rst_n) 
begin 
   if (!rst_n) 
   begin
      seg_memory_0          <= 4'b0000;
      seg_memory_1          <= 4'b0000;
      seg_memory_2          <= 4'b0000;
      seg_memory_3          <= 4'b0000;
   end 
   else begin
        if (cnt_row_i < 10) // 한자리 cnt_row
        begin
            seg_memory_0    <= (cnt_row_i / 1) % 10;
            seg_memory_1    <= 4'b0000;
            seg_memory_2    <= 4'b0000;
            seg_memory_3    <= 4'b0000;
        end
        else if (cnt_row_i < 100) // 두자리 cnt_row
        begin
            seg_memory_0    <= (cnt_row_i / 1) % 10;
            seg_memory_1    <= (cnt_row_i / 10) % 10;
            seg_memory_2    <= 4'b0000;
            seg_memory_3    <= 4'b0000;
        end
        else if (cnt_row_i < 1000) // 세자리 cnt_row
        begin
            seg_memory_0    <= (cnt_row_i / 1) % 10;
            seg_memory_1    <= (cnt_row_i / 10) % 10;
            seg_memory_2    <= (cnt_row_i / 100) % 10;
            seg_memory_3    <= 4'b0000;
        end
        else begin
            seg_memory_0    <= 4'b0000;
            seg_memory_1    <= 4'b0000;
            seg_memory_2    <= 4'b0000;
            seg_memory_3    <= 4'b0000;
        end
    end        
end



always @(posedge clk or negedge rst_n) 
    begin 
    if (!rst_n) begin
        seg_data        <= 7'd0;
        digit           <= 4'b1000;
    end
    else begin
        case (digit)
            4'b1111: // AT RESET
                seg_data <= 7'b111_1111;
            4'b1000: begin
                case (seg_memory_3)
                    4'b0000 : seg_data <= ~7'b1000000; // 0
                    4'b0001 : seg_data <= ~7'b1111001; // 1
                    4'b0010 : seg_data <= ~7'b0100100; // 2
                    4'b0011 : seg_data <= ~7'b0110000; // 3
                    4'b0100 : seg_data <= ~7'b0011001; // 4
                    4'b0101 : seg_data <= ~7'b0010010; // 5
                    4'b0110 : seg_data <= ~7'b0000010; // 6
                    4'b0111 : seg_data <= ~7'b1111000; // 7
                    4'b1000 : seg_data <= ~7'b0000000; // 8
                    4'b1001 : seg_data <= ~7'b0010000; // 9
                endcase
            end
            4'b0100: begin
                case (seg_memory_2)
                    4'b0000 : seg_data <= ~7'b1000000; // 0
                    4'b0001 : seg_data <= ~7'b1111001; // 1
                    4'b0010 : seg_data <= ~7'b0100100; // 2
                    4'b0011 : seg_data <= ~7'b0110000; // 3
                    4'b0100 : seg_data <= ~7'b0011001; // 4
                    4'b0101 : seg_data <= ~7'b0010010; // 5
                    4'b0110 : seg_data <= ~7'b0000010; // 6
                    4'b0111 : seg_data <= ~7'b1111000; // 7
                    4'b1000 : seg_data <= ~7'b0000000; // 8
                    4'b1001 : seg_data <= ~7'b0010000; // 9
                endcase
            end
            4'b0010: begin
                case (seg_memory_1)
                    4'b0000 : seg_data <= ~7'b1000000; // 0
                    4'b0001 : seg_data <= ~7'b1111001; // 1
                    4'b0010 : seg_data <= ~7'b0100100; // 2
                    4'b0011 : seg_data <= ~7'b0110000; // 3
                    4'b0100 : seg_data <= ~7'b0011001; // 4
                    4'b0101 : seg_data <= ~7'b0010010; // 5
                    4'b0110 : seg_data <= ~7'b0000010; // 6
                    4'b0111 : seg_data <= ~7'b1111000; // 7
                    4'b1000 : seg_data <= ~7'b0000000; // 8
                    4'b1001 : seg_data <= ~7'b0010000; // 9
                endcase
            end
            4'b0001: begin
                case (seg_memory_0)
                    4'b0000 : seg_data <= ~7'b1000000; // 0
                    4'b0001 : seg_data <= ~7'b1111001; // 1
                    4'b0010 : seg_data <= ~7'b0100100; // 2
                    4'b0011 : seg_data <= ~7'b0110000; // 3
                    4'b0100 : seg_data <= ~7'b0011001; // 4
                    4'b0101 : seg_data <= ~7'b0010010; // 5
                    4'b0110 : seg_data <= ~7'b0000010; // 6
                    4'b0111 : seg_data <= ~7'b1111000; // 7
                    4'b1000 : seg_data <= ~7'b0000000; // 8
                    4'b1001 : seg_data <= ~7'b0010000; // 9
                endcase
            end
        endcase

        digit           <= digit >> 1;

        if (digit == 4'b0000) begin
            digit       <= 4'b1000;
        end
    end
end

assign seg_data_o   = seg_data;
assign digit_o      = digit;

endmodule 