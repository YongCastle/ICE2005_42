module core_module
(
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

// abs gx,gy => G = |gx| + |gy|
reg [10:0]             abs_gx;
reg [10:0]             abs_gy;
// sum = G
reg [10:0]             sum;

// +-----------+
// |-1   0   1 |
// |-2   0   2 |
// |-1   0   1 |
// +-----------+
assign gx = (core_en_i)? (data_0_0_i * (-1) + data_0_1_i * (0) + data_0_2_i * (1)+ 
                          data_1_0_i * (-2) + data_1_1_i * (0) + data_1_2_i * (2)+          
                          data_2_0_i * (-1) + data_2_1_i * (0) + data_2_2_i * (1)) : 'd0; 

assign gy = (core_en_i)? (data_0_0_i * (1)  + data_0_1_i * (2)  + data_0_2_i * (1)+ 
                          data_1_0_i * (0)  + data_1_1_i * (0)  + data_1_2_i * (0)+          
                          data_2_0_i * (-1) + data_2_1_i * (-2) + data_2_2_i * (-1)) : 'd0; 


assign abs_gx       = gx[10]? (~gx + 1) : gx;
assign abs_gy       = gy[10]? (~gy + 1) : gy;
assign sum          = abs_gx + abs_gy;

assign pixel_o      = (sum > 'd255)? 8'b1111_1111 : 8'b0000_0000;
assign pixel_en_o   = core_en_i;


endmodule