module mem_ctr_A
#(
    parameter        MAX_ROW = 360,
    parameter        MAX_COL = 540 
)
(
    input wire              clk,
    input wire              rst_n,

    //============== BRAM ====================
    output wire             ena_o,
    output wire             wea_o,               // 1 : Write , 0 : READ
    output wire [17:0]      addra_o,
    output wire [7:0]       d2mema_o,           

    input wire  [7:0]       mem2da_i,           // Not Using. Do Not READ

    //============== PIXEL INPUT ====================
    input wire [7:0]        pixel_i,
    input wire              pixel_en_i

);



//BRAM

reg [17:0] addr;

//ADDR CNT
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        addr        <= 'd0;
    end
    else begin
        if(ena_o) begin
            if(addr == MAX_COL*MAX_ROW -1) begin
                addr    <=  'd0;
            end
            else begin
                addr    <=  addr + 'd1;
            end
        end
    end
end


assign addra_o      = addr;
assign ena_o        = pixel_en_i;
assign wea_o        = 1'd1;
assign d2mema_o     = (pixel_en_i)? pixel_i : 'd0;

endmodule