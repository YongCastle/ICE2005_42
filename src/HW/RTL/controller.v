module controller
#(
    parameter       MAX_ROW = 540;
    parameter       MAX_COL = 540;
)
(
    //================================
    //             System
    //================================
    input   wire           clk,
    input   wire           rst_n,

    //================================
    //             Switch
    //================================
    // From
    input   wire           start_i,
    input   wire           vga_run_i,
    // To

    //================================
    //       Memory Controller
    //================================
    // From
    
    // To
    output  wire           fetch_run_o,
    //================================
    //        Preprocessor 
    //================================
    // From
    input   wire           fetch_done_i,
    input   wire           core_done_i,
    // To
    output  wire           

    //================================
    //             CORE
    //================================
    // From

    // To

    //================================
    //              VGA
    //================================
    // From

    // To

    //For Debugging
    
);

localparam          S_IDLE      = 3'd0,
                    S_FETCH     = 3'd1,           // BRAM --> (MEM CTR) --> BUFFER
                    S_CORE      = 3'd2,           // BUFFER --> CORE
                    S_VGA_RUN   = 3'd3,
                    S_DONE      = 3'd4;


reg     [3:0]       state,      state_n;

wire fetch_run;


always @(posedge clk) begin
    if(!rst_n) begin
        state               <= S_IDLE;
    end
    else begin
        state               <= state_n;
    end
end

always @(*) begin
    //Not For Make LATCH
    state_n                 = state;
    fetch_run               = 'd0;

    case(state)
        S_IDLE : begin
            if(start_i) begin
                state_n         = S_FETCH;

                fetch_run       = 1'd1;
            end
        end
        S_FETCH : begin
            if(fetch_done_i) begin
                state_n         = S_CORE;
        
                
            end
        end
        S_CORE : begin
            if(core_done_i) begin
                state_n         = S_FETCH;
                
            end
        end
    // S_VGA_RUN : begin
    //     if(vga_run_i) begin
    //         state_n         = S_VGA_RUN;
    //     end
    // end
    // S_DONE : begin
    //     state_n             = S_IDLE;
    // end
    endcase
end



// =============== Memory Controller ========
assign fetch_run_o          = fetch_run;
assign 


endmodule