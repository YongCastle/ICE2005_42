module core_module
(
    input   clk,
    input   rst_n,

    //======== Preprocess ===================
    input wire [7:0]              data_0_0_i,        // (0,0)
    input wire [7:0]              data_0_1_i,        // (0,1) 
    input wire [7:0]              data_0_2_i,        // (0,2) 
    input wire [7:0]              data_1_0_i,        // (1,0) 
    input wire [7:0]              data_1_1_i,        // (1,1) 
    input wire [7:0]              data_1_2_i,        // (1,2) 
    input wire [7:0]              data_2_0_i,        // (2,0) 
    input wire [7:0]              data_2_1_i,        // (2,1) 
    input wire [7:0]              data_2_2_i,        // (2,2) 
    
    input wire                    core_en_i,         //enable signal    
    
    //output
    output wire [7:0]             pixel_o,              //output to accumulator
    output wire                   pixel_en_o
);


//wire
 // gx, gy : -1020 ~ 1020 -> 11-bits
reg [10:0]             gx;             //max (0~255) * (+ or -)(1+2+1) => 10-bits + 1-bit for sign => 11-bits
reg [10:0]             gy;             //max (0~255) * (+ or -)(1+2+1) => 10-bits + 1-bit for sign => 11-bits
reg                    core_en_i_d;
// abs gx,gy => G = |gx| + |gy|
wire [10:0]             abs_gx;
wire [10:0]             abs_gy;
// sum = G
wire [10:0]             sum;

// +-----------+
// |-1   0   1 |
// |-2   0   2 |
// |-1   0   1 |
// +-----------+
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        gx              <= 'd0;
        gy              <= 'd0;
        core_en_i_d     <= 'd0;
    end
    else begin
        core_en_i_d     <= core_en_i;
        if(core_en_i) begin
            gx          <= data_0_0_i * (-1) + data_0_1_i * (0) + data_0_2_i * (1)+ 
                           data_1_0_i * (-2) + data_1_1_i * (0) + data_1_2_i * (2)+          
                           data_2_0_i * (-1) + data_2_1_i * (0) + data_2_2_i * (1);

            gy          <= data_0_0_i * (1)  + data_0_1_i * (2)  + data_0_2_i * (1)+ 
                           data_1_0_i * (0)  + data_1_1_i * (0)  + data_1_2_i * (0)+          
                           data_2_0_i * (-1) + data_2_1_i * (-2) + data_2_2_i * (-1);
        end
        else begin
            gx          <= 'd0;
            gy          <= 'd0;
        end
    end
end


assign abs_gx       = gx[10]? (~gx + 1) : gx;
assign abs_gy       = gy[10]? (~gy + 1) : gy;
assign sum          = abs_gx + abs_gy;

assign pixel_o      = (sum > 'd255)? 8'b1111_1111 : 8'b0000_0000;
assign pixel_en_o   = core_en_i_d;


endmodule