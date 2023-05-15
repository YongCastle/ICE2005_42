`timescale 1ns / 1ps

module buzzer_test
#(
   parameter HOST_HZ    = 27'd100_000_000    // HOST Hertz
)
(
   /*****************************************************
   ** Input Signal Define                              **
   *****************************************************/
   input  wire             clk         ,
   input  wire             rstb        ,
   
   //input  wire [03:0]      tone_sel    ,
   input  wire [02:0]      tone_sel    ,   // dip_sw 1, 2, 3
   /*****************************************************
   ** Output Signal Define                             **
   *****************************************************/ 
   output                  buzzer_out
);

reg tone_out;

assign buzzer_out = tone_out;
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
** Musical Scale Select
*****************************************************/
always @(*) begin 
   case (tone_sel)
      4'd0 : hz_sel  <= Mute  ;
      4'd1 : hz_sel  <= Do    ;
      4'd2 : hz_sel  <= Re    ;
      4'd3 : hz_sel  <= Mi    ;
      4'd4 : hz_sel  <= Pa    ;
      4'd5 : hz_sel  <= Sol   ;
      4'd6 : hz_sel  <= Ra    ;
      4'd7 : hz_sel  <= Si    ;
      4'd8 : hz_sel  <= Hi_Do ;
      default : hz_sel  <= Mute;
   endcase
end


/*****************************************************
** Generate Tone Pulse
*****************************************************/
always @(posedge clk or negedge rstb) begin 
   if (!rstb) begin
      hz_cnt         <= 'd0;
      tone_out       <= 1'b0;
      tone_sel_buf   <= 4'd0;
   end
   else begin
      tone_sel_buf   <= tone_sel;
      
      if (tone_sel != tone_sel_buf) begin
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