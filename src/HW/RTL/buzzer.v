`timescale 1ns / 1ps

module buzzer_module (
   // Input Signal Define
   input wire            clk,
   input wire            rst_n,
   input wire            play_tone_i,

   // Output Signal Define
   output wire           buzzer_out_o
);

// Parameter Definition
localparam HOST_HZ             = 27'd100_000_000; // HOST Hertz
localparam Mute                = 27'd3000000;
localparam Do                  = HOST_HZ / 27'd523 / 2;
localparam Re                  = HOST_HZ / 27'd587 / 2;
localparam Mi                  = HOST_HZ / 27'd659 / 2;
localparam Pa                  = HOST_HZ / 27'd699 / 2;
localparam Sol                 = HOST_HZ / 27'd784 / 2;
localparam Ra                  = HOST_HZ / 27'd880 / 2;
localparam Si                  = HOST_HZ / 27'd988 / 2;
localparam Hi_Do               = HOST_HZ / 27'd1047 / 2;

// Reg Definition
reg [26:0]            hz_sel;
reg [26:0]            hz_cnt;
reg                   tone_out;
reg                   play_tone_i_reg;

always @(posedge clk) begin
   if (!rst_n) begin
      hz_cnt               <= 0;
      tone_out             <= 1'b0;
      play_tone_i_reg      <= 1'b0;
   end
   else begin
      if (play_tone_i == 1'b0) begin
         hz_cnt               <= 0;
         tone_out             <= 1'b0;
         play_tone_i_reg      <= 1'b0;
      end
      else begin
         hz_sel               <= Do;
         tone_out             <= 1'b1;
         play_tone_i_reg      <= 1'b1;
      end
   end
end

assign buzzer_out_o      = tone_out;

endmodule