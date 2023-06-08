module buzzer_module
#(
parameter HOST_HZ = 27'd100_000_000 // HOST Hertz
)
(
/*****************************************************
** Input Signal Define **
*****************************************************/
input wire clk ,
input wire rst_n ,
 
input wire       buzzer_mode_i, // 3
input wire [9:0] cnt_row_i,
/*****************************************************
** Output Signal Define **
*****************************************************/ 
output buzzer_out_o /*,
output tone_sel*/
);

reg tone_out;
reg [2:0] tone_sel;
reg [31:0] tmp;
reg cnt_clk;
reg [2:0] cnt;


always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tmp             <= 0;
        cnt_clk         <= 0;
        end
        else begin
        if ( tmp == 'd8) begin
            tmp         <= 0;
            cnt_clk     <= ~cnt_clk;
        end
        else begin
            tmp         <= tmp + 1;
            cnt_clk     <= cnt_clk;
        end
    end
end // cnt_clk 생성

// Add two new registers
reg [31:0] note_duration_counter;
reg [31:0] rest_duration_counter;

// Define the duration of each note and rest
localparam NOTE_DURATION = 27'd2000000; // adjust these values based on your needs
localparam REST_DURATION = 27'd500000; // adjust these values based on your needs

always @ (posedge clk or negedge rst_n)
begin
  if(!rst_n || !buzzer_mode_i) 
  begin
    tone_sel <= 0;
    note_duration_counter <= 0;
    rest_duration_counter <= 0;
  end
  else
  begin
    if(note_duration_counter < NOTE_DURATION)
    begin
      note_duration_counter <= note_duration_counter + 1;
    end
    else if(rest_duration_counter < REST_DURATION)
    begin
      rest_duration_counter <= rest_duration_counter + 1;
    end
    else
    begin
      note_duration_counter <= 0;
      rest_duration_counter <= 0;
      if(tone_sel < 3'b111)
        tone_sel <= cnt_row_i + 1;
      else
        tone_sel <= 0;
    end
  end
end

/*****************************************************
** Parameter Definition **
*****************************************************/
localparam Mute =   27'd3000000;
localparam Do =     HOST_HZ / 27'd523 / 2;
localparam Re =     HOST_HZ / 27'd597 / 2;
localparam Mi =     HOST_HZ / 27'd659 / 2;
localparam Pa =     HOST_HZ / 27'd699 / 2;
localparam Sol =    HOST_HZ / 27'd784 / 2;
localparam Ra =     HOST_HZ / 27'd880 / 2;
localparam Si =     HOST_HZ / 27'd988 / 2;
localparam Hi_Do =  HOST_HZ / 27'd1047 / 2;
 
/*****************************************************
** Reg Definition **
*****************************************************/
reg [26:0] hz_sel ;
reg [26:0] hz_cnt ;
reg [02:0] tone_sel_buf;

/*****************************************************
** Musical Scale Select
*****************************************************/
always @(*) begin 
    case (tone_sel)
       4'd0 : hz_sel <= Mute ;
       4'd1 : hz_sel <= Do ;
       4'd2 : hz_sel <= Re ;
       4'd3 : hz_sel <= Mi ;
       4'd4 : hz_sel <= Pa ;
       4'd5 : hz_sel <= Sol ;
       4'd6 : hz_sel <= Ra ;
       4'd7 : hz_sel <= Si ;
       default : hz_sel <= Mute;
    endcase
end

/*****************************************************
** Generate Tone Pulse
*****************************************************/
always @(posedge clk or negedge rst_n) begin 
   if (!rst_n) begin
       hz_cnt <= 'd0;
       tone_out <= 1'b0;
       tone_sel_buf <= 3'd0;
 end
 else begin
    tone_sel_buf <= tone_sel;
 
    if (tone_sel != tone_sel_buf) begin
       hz_cnt <= 'd0;
       tone_out <= 1'b0;
    end
    else if (Mute == hz_sel) begin
       hz_cnt <= 'd0;
       tone_out <= 1'b0;
    end
    else if (hz_sel == hz_cnt) begin
       hz_cnt <= 'd0;
       tone_out <= ~tone_out;
    end
    else begin
       hz_cnt <= hz_cnt + 1;
       tone_out <= tone_out;
       end
    end
end

assign buzzer_out_o = tone_out;

endmodule