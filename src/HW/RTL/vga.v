/*-------------------------------------------------------------------------
--                                                                         
--   Copyright (c) Libertron Co., LTD. 2016                               
--   ALL RIGHTS RESERVED                                                   
--                                                                         
--   THIS PROGRAM IS THE PROPERTY OF Libertron Co., LTD. AND IS            
--   BEING PROVIDED TO YOU PURSUANT TO A LICENSE AGREEMENT THAT            
--   SETS FORTH CERTAIN TERMS AND CONDITIONS FOR USE OF THIS PROGRAM.      
--   YOU MAY NOT COPY, DISTRIBUTE, USE OR OTHERWISE CREATE DERIVATIVES     
--   OF THIS SOFTWARE EXCEPT AS PROVIDED IN THE LICENSE AGREEMENT.         
-- IP Name       :                                       
-- IP Revision   :                                                         
-- File Name     : pattern_gen.v                                            
-- File Revision : 1.0                                                     
-- Date          : 2016/04/21                                              
-- Authors       : Libertron R&D Center                                    
--                                                                         
-------------------------------------------------------------------------*/
`timescale 1ns/ 1ps

module vga
#(
parameter Tvw       = 12'd6   ,   //VSYNC Pulse Width
parameter Tvbp      = 12'd29  ,   //VSYNC Back Porch
parameter Tvfp      = 12'd3   ,   //Vertical Front Porch
parameter Tvdw      = 12'd768 ,   //Vertical valid data width
parameter Thw       = 12'd136 ,   //HSYNC Pulse Width        
parameter Thbp      = 12'd160 ,   //HSYNC Back Porch         
parameter Thfp      = 12'd24  ,   //Horizontal Front Porch     
parameter Thdw      = 12'd1024,   //Horizontal valid data width
parameter Vsync_pol = 1'b1    ,   //VSync Polarity, 0 = Active High, 1 = Active Low
parameter Hsync_pol = 1'b1    ,   //HSync Polarity, 0 = Active High, 1 = Active Low

parameter Pixel     = 10'd540 ,
parameter Pixel_vol = 19'd291600
)
(
/*****************************************************
** Input Signal Define                              **
*****************************************************/
input  wire             clk         ,
input  wire             rstb        ,
input  wire [7:0]       pixel_i     ,  
/*****************************************************
** Output Signal Define                             **
*****************************************************/ 
output wire             vga_vs      ,
output wire             vga_hs      ,
output wire [3:0]       vga_r       ,
output wire [3:0]       vga_g       ,
output wire [3:0]       vga_b       , 
output wire             bram_en_o  
);


/*****************************************************
** Parameter Definition                             **
*****************************************************/
localparam Tvp       = Tvw + Tvbp + Tvfp + Tvdw;//VSYNC Period   
localparam Thp       = Thw + Thbp + Thfp + Thdw;//HSYNC Period     
localparam VSYNC_ACT = ~Vsync_pol;
localparam HSYNC_ACT = ~Hsync_pol;

           
/*****************************************************
** Reg Definition                                  **
*****************************************************/
reg   [11:0]   hcnt        ;
reg   [11:0]   vcnt        ;
reg   [11:0]   pat_hcnt    ;
reg   [11:0]   pat_vcnt    ;
reg            pat_vs      ;
reg            pat_hs      ;
reg            pat_de      ;
reg   [3:0]    pat_r       ;
reg   [3:0]    pat_g       ;
reg   [3:0]    pat_b       ;
reg         [1:0]      tft_clk_cnt;
reg                  tft_iclk;
reg            bram_en;

//65 비바도기능
// wire          clk_65          ;

//   clk_wiz_0 clock_gen_65
//    (
//     // Clock out ports
//     .clk_out1(clk_65),     // output clk_out1
//    // Clock in ports
//     .clk_in1(clk)); 

//25
 always @(posedge clk or negedge rstb) begin
      if(!rstb) begin
         tft_iclk <= 1'b0;
         tft_clk_cnt <= 2'b00;
      end
      else begin
         if(tft_clk_cnt == 2'b11) begin
            tft_iclk <= 1'b1;
            tft_clk_cnt <= 2'b00;
         end
         else begin
            tft_iclk <= 1'b0;
            tft_clk_cnt <= tft_clk_cnt + 1;
         end
      end
   end


/*****************************************************
** HSYNC Period/VSYNC Period Count
*****************************************************/
always @(posedge tft_iclk or negedge rstb) begin 
   if (!rstb) begin
       hcnt   <= 12'd0;
       vcnt   <= 12'd0;
   end
   else begin
      /** HSYNC Period **/
      if (hcnt == (Thp - 1)) begin
         hcnt <= 12'd0;
      end
      else begin
         hcnt <= hcnt + 1'b1;
      end
      /** VSYNC Period **/
      if (hcnt == (Thp - 1)) begin
         if (vcnt == (Tvp - 1)) begin
            vcnt <= 12'd0;
         end
         else begin
            vcnt <= vcnt + 1'b1;
         end
      end
   end
end


/*****************************************************
** VSYNC Signal Gen.
*****************************************************/
always @(posedge tft_iclk or negedge rstb) begin 
   if (!rstb) begin
       pat_vs       <= VSYNC_ACT;
   end
   else begin
      if (hcnt == (Thp - 1)) begin
         if (vcnt == (Tvw - 1)) begin
            pat_vs <= ~VSYNC_ACT;
         end
         else if (vcnt == (Tvp - 1)) begin
            pat_vs <= VSYNC_ACT;
         end
      end
   end
end


/*****************************************************
** HSYNC Signal Gen.
*****************************************************/
always @(posedge tft_iclk or negedge rstb) begin 
   if (!rstb) begin
       pat_hs <= HSYNC_ACT;
   end
   else begin
      if (hcnt == (Thw - 1)) begin
         pat_hs <= ~HSYNC_ACT;
      end
      else if (hcnt == (Thp - 1)) begin
         pat_hs <= HSYNC_ACT;
      end
   end
end


/*****************************************************
** HSYNC/VSYNC Data Enable Signal Gen.
*****************************************************/
always @(posedge tft_iclk or negedge rstb) begin 
   if (!rstb) begin
       pat_de   <= 1'b0;
   end
   else begin
      if ((vcnt >= (Tvw + Tvbp)) && (vcnt <= (Tvp - Tvfp - 1))) begin
         if (hcnt == (Thw + Thbp - 1)) begin
            pat_de <= 1'b1;
         end
         else if (hcnt == (Thp - Thfp - 1))begin
            pat_de <= 1'b0;
         end
      end
   end
end


/*****************************************************
** Horizontal Valid Pixel Count
*****************************************************/
always @(posedge tft_iclk or negedge rstb) begin 
   if (!rstb) begin
      pat_hcnt    <= 'd0;
   end
   else begin
      if (pat_de) begin
         pat_hcnt <= pat_hcnt + 'b1;
      end
      else begin
         pat_hcnt <= 'd0;
      end 
   end
end


/*****************************************************
** Vertical Valid Pixel Count
*****************************************************/
always @(posedge tft_iclk or negedge rstb) begin 
   if (!rstb) begin
      pat_vcnt <= 'd0;
   end
   else begin
      if ((vcnt >= (Tvw + Tvbp)) && (vcnt <= (Tvp - Tvfp - 1))) begin
         if (hcnt == (Thp - 1)) begin
            pat_vcnt <= pat_vcnt + 'd1;
         end
      end
      else begin
         pat_vcnt <= 'd0;
      end
   end
end



always @(posedge tft_iclk or negedge rstb) begin
   if (!rstb) begin
      bram_en <= 1'b0;
      if (pat_de & pat_hcnt <= 537 & pat_vcnt <= 539 ) begin
         bram_en <= 1'b1;
      end
      else begin
         bram_en <= 1'b0;
      end
   end
end

always @(posedge tft_iclk or negedge rstb) begin
   if (!rstb) begin
      pat_r    <= 4'b0000;
      pat_g    <= 4'b0000;
      pat_b    <= 4'b0000;
   end
   else begin
      if (pat_de) begin
         if (pat_hcnt <= 539 & pat_vcnt <= 539) begin
            if (pixel_i == 8'b1111_1111) begin
               pat_r <= 4'b1111;
               pat_g <= 4'b1111;
               pat_b <= 4'b1111;
            end
            else begin
               pat_r <= 4'b0000;
               pat_g <= 4'b0000;
               pat_b <= 4'b0000;
            end
         end
      end
      else begin
         pat_r <= 4'b0000;
         pat_g <= 4'b0000;
         pat_b <= 4'b0000;
      end
   end
end

/*****************************************************
** Signal Interconnect
*****************************************************/
assign vga_vs  = pat_vs;
assign vga_hs  = pat_hs;
assign vga_r   = (pat_de == 1'b1) ? pat_r : 4'b0000;
assign vga_g   = (pat_de == 1'b1) ? pat_g : 4'b0000;
assign vga_b   = (pat_de == 1'b1) ? pat_b : 4'b0000;
assign bram_en_o = bram_en;

endmodule        