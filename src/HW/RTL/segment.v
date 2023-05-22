module segment
 (
input              rstb,
input              clk,  
input   reg [3:0]    seg_memory,

output  reg [6:0]      seg_data,
output  reg [3:0]      digit
);
       
/*****************************************************
*****************************************************/
always @(posedge clk) begin 
   if (!rstb) begin
      digit <= 4'b0000;   end
  else begin
      digit <= seg_memory;
    end
end

/*****************************************************
*****************************************************/
always @(posedge clk) begin 
   if (!rstb) begin
      seg_data  <= 7'd0;   end
   else 
     case(digit)   // 선택한 자리에 원하는 숫자 데이타 출력
               4'b0000 : seg_data  <= 7'b111_1110;  // 0출력
               4'b0001 : seg_data  <= 7'b011_0010;  // 1출력
               4'b0010 : seg_data  <= 7'b110_1101;  // 2출력
               4'b0011 : seg_data  <= 7'b111_1001;  // 3출력
               4'b0100 : seg_data  <= 7'b011_0011;  // 4출력
               4'b0101 : seg_data  <= 7'b101_1011;  // 5출력
               4'b0110 : seg_data  <= 7'b101_1111;  // 6출력
               4'b0111 : seg_data  <= 7'b111_0010;  // 7출력
               4'b1000 : seg_data  <= 7'b111_1111;  // 8출력
               4'b1001 : seg_data  <= 7'b111_1011;  // 9출력
               default : seg_data  <= 7'd0;
      endcase
end

endmodule