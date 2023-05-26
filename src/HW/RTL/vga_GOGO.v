`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/22 14:37:59
// Design Name: 
// Module Name: lcd_rgb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lcd_rgb(clk, rst, sw1, sw2, sw3, HSYNC, VSYNC, R_data, G_data, B_data);

input        clk;
input        rst;
input        sw1;
input        sw2;
input        sw3;
output       HSYNC;
output       VSYNC;
output [3:0] R_data;
output [3:0] G_data;
output [3:0] B_data;

	
	reg			[1:0]		tft_clk_cnt;
	reg						tft_iclk, hsync_1, vsync_1, movclk, xr, yr;

	reg	        [3:0]   	R_reg;
    reg         [3:0]      G_reg;
    reg         [3:0]      B_reg;

	reg			[2:0]		h, v;
	
	reg			[15:0]	x, y;
	reg			[15:0]	tx, ty;
 
	integer					hsync_cnt, vsync_cnt, movcnt;
	
	parameter				HSYNC_BACK_PORCH = 40;
	parameter				HSYNC_FRONT_PORCH = 40;
	parameter				VSYNC_BACK_PORCH = 31;
	parameter				VSYNC_FRONT_PORCH = 17;
	parameter				hsync_width = 928;
	parameter				vsync_width = 525;
	
	parameter				box_width = 70; // 움직이는 상자 가로길이
	parameter				box_height = 70; // 움직이는상자 세로길이

	wire lcd_data_en = (~hsync_1 & ~vsync_1);
	wire hsync_load = (hsync_cnt >= (hsync_width - 1)) ? 1'b1 : 1'b0;
	wire vsync_load = (vsync_cnt >= (vsync_width - 1)) ? 1'b1 : 1'b0;

	always @(posedge clk or negedge rst) begin // 상자 프레임 (속도클록) 생성 - 대략  
		if(!rst) begin
			movcnt <= 0;
			movclk <= 1'b0;
		end
		else begin
			if(movcnt >= 100000) begin
				movcnt <= 0;
				movclk <= ~movclk;
			end
			else begin
				movcnt <= movcnt + 1;
			end
		end
	end

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			tft_iclk <= 1'b0;
			tft_clk_cnt <= 2'b00;
		end
		else begin
			if(tft_clk_cnt == 2'b10) begin
				tft_iclk <= 1'b1;
				tft_clk_cnt <= 2'b00;
			end
			else begin
				tft_iclk <= 1'b0;
				tft_clk_cnt <= tft_clk_cnt + 1;
			end
		end
	end

	always @(posedge tft_iclk or negedge rst) begin
		if(!rst)	hsync_cnt <= 0;
		else begin
			if(hsync_load)	hsync_cnt <= 0;
			else				hsync_cnt <= hsync_cnt + 1;
		end
	end
	
	always @(posedge tft_iclk or negedge rst) begin
		if(!rst)	hsync_1 <= 1'b1;
		else begin
			if((hsync_cnt >= HSYNC_BACK_PORCH) & (hsync_cnt <= (hsync_width - (HSYNC_FRONT_PORCH - 1)))) begin
					hsync_1 <= 1'b0;
			end
			else	hsync_1 <= 1'b1;
		end
	end

	always @(posedge tft_iclk or negedge rst) begin
		if(!rst)	vsync_cnt <= 0;
		else begin
			if(hsync_load) begin
				if(vsync_load)	vsync_cnt <= 0;
				else				vsync_cnt <= vsync_cnt + 1;
			end
			else vsync_cnt <= vsync_cnt;
		end
	end
	
	always @(posedge tft_iclk or negedge rst) begin
		if(!rst)	vsync_1 <= 1'b1;
		else begin
			if((vsync_cnt >= VSYNC_BACK_PORCH) & (vsync_cnt <= (vsync_width - (VSYNC_FRONT_PORCH - 1)))) begin
					vsync_1 <= 1'b0;
			end
			else	vsync_1 <= 1'b1;
		end
	end

	// 밑의 두 always문은 도형을 그리기 위한 연산.
	always @(posedge tft_iclk or negedge rst) begin
		if(!rst)	begin
			v <= 0;
		end
		else begin
			if(vsync_cnt <= (y + VSYNC_BACK_PORCH)) v <= 0; 	
			else if( (vsync_cnt > (y + VSYNC_BACK_PORCH)) & (vsync_cnt <= ((y + box_height) + VSYNC_BACK_PORCH)) ) v <= 7;
			else v <= 0;
		end
	end

	always @(posedge tft_iclk or negedge rst) begin
		if(!rst)	begin
			h <= 0;
		end
		else begin
			if(hsync_cnt <= (x + HSYNC_BACK_PORCH)) h <= 0;
			else if( (hsync_cnt > (x + HSYNC_BACK_PORCH)) & (hsync_cnt <= ((x + box_width) + HSYNC_BACK_PORCH)) ) h <= 7;
			else h <= 0;
		end
	end

	// 밑의 두 always문은 도형의 움직임을 제어하기 위한 연산임.
	always @(posedge movclk or negedge rst) begin
		if(!rst)	begin
			x <= 2;
			y <= 2;
		end
		else begin
			if(xr)	x <= x - 1;
			else		x <= x + 1;
			if(yr)	y <= y - 1;
			else		y <= y + 1;
		end
	end

	always @(posedge movclk or negedge rst) begin
		if(!rst)	begin
			xr <= 0;
			yr <= 0;
		end
		else begin
			if((x + box_width) >= 800)	xr <= 1;
			else if(x <= 1)				xr <= 0;
			if((y + box_height) >= 480)yr <= 1;
			else if(y <= 1)				yr <= 0;
		end
	end

	// 버튼에 따른 도형색상 지정 
	always @(posedge tft_iclk or negedge rst) begin
		if(!rst) G_reg <= 4'b1111;
		else begin
			if(!sw1 & sw2 & sw3) begin
				R_reg <= 4'b1111;
				G_reg <= 4'b0000;
				B_reg <= 4'b0000;
			end
			else if(sw1 & !sw2 & sw3) begin
				R_reg <= 4'b0000;
				G_reg <= 4'b1111;
				B_reg <= 4'b0000;
			end
			else if(sw1 & sw2 & !sw3) begin
				R_reg <= 4'b0000;
				G_reg <= 4'b0000;
				B_reg <= 4'b1111;
			end
		end
	end


	assign HSYNC = hsync_1;
	assign VSYNC = vsync_1;
	
	// 픽셀 제어파트
	assign R_data = (lcd_data_en) ? ( (v[0] & h[0]) ? R_reg : 4'b0000) : 4'b0000;
	assign G_data = (lcd_data_en) ? ( (v[1] & h[1]) ? G_reg : 4'b0000) : 4'b0000;
	assign B_data = (lcd_data_en) ? ( (v[2] & h[2]) ? B_reg : 4'b0000) : 4'b0000;
endmodule
