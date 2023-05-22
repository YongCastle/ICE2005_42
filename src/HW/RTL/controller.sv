module controller_module
#(
    parameter       MAX_ROW = 540,
    parameter       MAX_COL = 540
)
(
    //============== SYSTEM ====================
    input   wire           clk,
    input   wire           rst_n,

    //======================= Switch ================
    // From
    input   wire           start_i,
    // To

    //============ Memory Controller ==================
    // From
    input   wire           fetch_done_i,
    input   wire [9:0]     cnt_img_row_i,
    // To
    output  wire           fetch_run_o,
    output  wire [19:0]    cnt_len_o,

    //=============== Preprocessor ==================
    // From
    input   wire           core_done_i,
    // To
    output  wire           core_run_o,


    //==================== For Debugging ============================
    output wire [2:0]       state_o,    
    output wire [2:0]       state_n_o
    
);

localparam          S_IDLE      = 3'd0,
                    S_FETCH     = 3'd1,           // BRAM --> (MEM CTR) --> BUFFER
                    S_CORE      = 3'd2,           // BUFFER --> CORE
                    S_DONE      = 3'd3;


reg     [2:0]       state,      state_n;

reg    fetch_run;
reg    core_run;
reg    done;

reg [19:0] cnt_len;


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
    core_run                = 'd0;
    done                    = 'd0;
    cnt_len                 = 'd0;

    case(state)
        S_IDLE : begin
            if(start_i) begin
                state_n             = S_FETCH;
            end
        end
        S_FETCH : begin
            fetch_run           = 1'd1;
            cnt_len             = 'd1620;
            if(fetch_done_i) begin
                state_n             = S_CORE;
            end
        end
        S_CORE : begin
            core_run            = 1'd1;

            if(core_done_i) begin
                if(cnt_img_row_i == MAX_ROW - 3) begin
                    state_n             = S_DONE;
                end
                else begin
                    state_n             = S_FETCH;
                end
            end
        end
        S_DONE : begin
            done                = 1'd1;

            if(start_i) begin
                state_n             = S_IDLE;
            end
        end
    endcase
end



// =============== Memory Controller ========
assign fetch_run_o          = fetch_run;
assign cnt_len_o            = cnt_len;
// =============== Preprocess ========
assign core_run_o           = core_run;


// ===========DEBUG ========
assign state_o        = state;
assign state_n_o      = state_n;

endmodule