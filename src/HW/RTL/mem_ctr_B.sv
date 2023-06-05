module mem_ctr_B
#(
    parameter        MAX_ROW = 360,
    parameter        MAX_COL = 540 
)
(

    input wire              clk,
    input wire              rst_n,

    //------------ BRAM ----------------------------
    output wire             enb_o,
    output wire             web_o,
    output wire [17:0]      addrb_o,
    output wire [7:0]       d2memb_o,             // Not Using. We Do Not Write

    input wire  [7:0]       mem2db_i,

    // ------------ VGA ---------------------------------
    input wire              bram_en_i,

    output wire [7:0]       RGB_o,
    output wire             RGB_en_o
);

reg [17:0] addr;

// Address
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        addr     <= 'd0;
    end
    else begin
        if(bram_en_i) begin
            if(addr == MAX_COL*MAX_ROW -1) begin
                addr    <= 'd0;
            end
            else begin
                addr     <= addr + 'd1;
            end
        end
    end
end

reg  bram_en_d; 
reg  bram_en_2d;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        bram_en_d   <= 'd0; 
        bram_en_2d  <= 'd0;
    end
    else begin
        bram_en_d   <= bram_en_i;
        bram_en_2d  <= bram_en_d;
    end
end

assign enb_o            = bram_en_i;
assign web_o            = 1'd0;         //REAMD
assign addrb_o          = addr;
assign d2memb_o         = 'd0;

assign RGB_o            = (RGB_en_o)? mem2db_i : 'd0;
assign RGB_en_o         = bram_en_2d;
    

endmodule
