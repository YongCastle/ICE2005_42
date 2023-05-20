`timescale 1ns / 1ps

module buzzer_module
#(
   parameter HOST_HZ    = 27'd100_000_000    // HOST Hertz
)
(
   // ============= System ===================
   input  wire             clk           ,
   input  wire             rst_n         ,

   // ============ Acc_BUF ======================
   
   //                     _____________
   // buzzer_on_i   _____|  
   input  wire             buzzer_on_i  ,

   // ============= Output Signal Define ==================
   output                  buzzer_out_o
);

reg [9:0]      cnt_img_row;      // Which is 540, (540x540 Image Using)
reg tone_out;

assign buzzer_out_o = tone_out;

/*****************************************************
** Parameter Definition                             **
*****************************************************/
localparam Mute      = 27'd3000000;
localparam Do        = HOST_HZ / 27'd523 / 2;
localparam Re        = HOST_HZ / 27'd597 / 2;
localparam Mi        = HOST_HZ / 27'd659 / 2;
localparam Pa        = HOST_HZ / 27'd699 / 2;
localparam Sol       = HOST_HZ / 27'd784 / 2;
localparam Ra        = HOST_HZ / 27'd880 / 2;
localparam Si        = HOST_HZ / 27'd988 / 2;
localparam Hi_Do     = HOST_HZ / 27'd1047 / 2;

           
/*****************************************************
** Reg Definition                                  **
*****************************************************/
reg   [26:0]   hz_sel      ;
reg   [26:0]   hz_cnt      ;
reg   [03:0]   tone_sel_buf;


/*****************************************************
** Count Run Signal For ROW                         **
*****************************************************/
always @(posedge clk) begin
   if(!rst_n) begin
      cnt_img_row    <= 'd0;
   end
   else begin
      if(buzzer_on_i) begin
         cnt_img_row = cnt_img_row + 'd1;
      end
   end
end


/*****************************************************
** Musical Scale Select
*****************************************************/
always @(*) begin 
   case (tone_sel_i)
      4'd0 : hz_sel  = Mute  ;
      4'd1 : hz_sel  = Do    ;
      4'd2 : hz_sel  = Re    ;
      4'd3 : hz_sel  = Mi    ;
      4'd4 : hz_sel  = Pa    ;
      4'd5 : hz_sel  = Sol   ;
      4'd6 : hz_sel  = Ra    ;
      4'd7 : hz_sel  = Si    ;
      4'd8 : hz_sel  = Hi_Do ;
      default : hz_sel  = Mute;
   endcase
end


/*****************************************************
** Generate Tone Pulse
*****************************************************/
always @(posedge clk) begin 
   if (!rst_n) begin
      hz_cnt         <= 'd0;
      tone_out       <= 1'b0;
      tone_sel_buf   <= 4'd0;
   end
   else begin
      tone_sel_buf   <= tone_sel_i;
      
      if (tone_sel_i != tone_sel_buf) begin
         hz_cnt      <= 'd0;
         tone_out    <= 1'b0;
      end
      else if (Mute == hz_sel) begin
         hz_cnt      <= 'd0;
         tone_out    <= 1'b0;
      end
      else if (hz_sel == hz_cnt) begin
         hz_cnt      <= 'd0;
         tone_out    <= ~tone_out;
      end
      else begin
         hz_cnt      <= hz_cnt + 1;
         tone_out    <= tone_out;
      end
   end
end


endmodule