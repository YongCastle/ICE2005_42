`timescale 1ns / 1ps

module vga_port_module
(
	input        	clk;
	input        	rst;
	input        	sw1;
	input        	sw2;
	input        	sw3;
	output       	HSYNC;
	output       	VSYNC;
	output [3:0] 	R_data;
	output [3:0] 	G_data;
	output [3:0] 	B_data;
);
	
	reg			[1:0]		tft_clk_cnt;
	reg						tft_iclk, hsync_1, vsync_1, movclk, xr, yr;
	reg	        [3:0]       R_reg, R_reg_1;
    reg         [3:0]      G_reg, G_reg_1;
    reg         [3:0]      B_reg, B_reg_1;

	integer                hsync_cnt, vsync_cnt, movcnt;
	
//***********************************************************************
//***********************  parameter Definition **********************
//***********************************************************************	
	parameter				HSYNC_BACK_PORCH = 40;
	parameter				HSYNC_FRONT_PORCH = 40;
	parameter				VSYNC_BACK_PORCH = 31;
	parameter				VSYNC_FRONT_PORCH = 17;
	parameter				hsync_width = 928;
	parameter				vsync_width = 525;
	
	wire lcd_data_en = (~hsync_1 & ~vsync_1);
	wire hsync_load = (hsync_cnt >= (hsync_width - 1)) ? 1'b1 : 1'b0;
	wire vsync_load = (vsync_cnt >= (vsync_width - 1)) ? 1'b1 : 1'b0;

//***********************************************************************
//***********************  pixcel Clock Generation **********************
//***********************************************************************
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

//***********************************************************************
//*********************** Hsync Generation **********************
//***********************************************************************

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

//***********************************************************************
//*********************** Vsync Generation **********************
//***********************************************************************

	always @(posedge tft_iclk or negedge rst) begin
		if(!rst)	vsync_cnt <= 0;
		else begin
			if(hsync_load) begin
				if(vsync_load)	vsync_cnt <= 0;
				else			vsync_cnt <= vsync_cnt + 1;
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


//***********************************************************************
//*********************** Color output Generation **********************
//***********************************************************************
	assign HSYNC = hsync_1;
	assign VSYNC = vsync_1;

	assign R_data = ((lcd_data_en) & (sw1)) ? 4'b1111 : 4'b0000;
    assign G_data = ((lcd_data_en) & (sw2)) ? 4'b1111 : 4'b0000;
    assign B_data = ((lcd_data_en) & (sw3)) ? 4'b1111 : 4'b0000;
               
endmodule

