module controller_module
#(
    parameter       MAX_ROW = 360,
    parameter       MAX_COL = 540
)
(
    //============== SYSTEM ====================
    input   wire           clk,
    input   wire           rst_n,

    //======================= Switch ================
    // From
    input   wire           mode1_start_i,       // 레버
    input   wire           mode2_start_i,       // 레버 
    input   wire           start_i,             // SW
    // To
    //======================= LED ===================
    output  wire           led_idle_o,
    //============ Memory Controller ==================
    // From
    input   wire           fetch_done_i,        //mode12_Done
    input   wire [9:0]     cnt_img_row_i,

    input   wire           mode1_done_i,        //model2_done
    // To
    output  wire           is_mode1_o,
    output  wire           mode1_run_o,         //mode1 run
    output  wire           is_mode2_o,          
    output  wire           fetch_run_o,         //mode2 run2
    output  wire [19:0]    cnt_len_o,

    //=============== Preprocessor ==================
    // From
    input   wire           core_done_i,
    // To
    output  wire           core_run_o,

    //================ 7-Segment ==========================
    output wire [9:0]      cnt_img_row_o,
    //==================== For Debugging ============================
    output wire [2:0]       state_o

);

localparam          S_IDLE      = 3'd0,
                    S_MODE1     = 3'd1,
                    S_MODE1_RUN = 3'd2,
                    S_MODE2     = 3'd3,
                    S_FETCH     = 3'd4,           // BRAM --> (MEM CTR) --> BUFFER
                    S_CORE      = 3'd5,           // BUFFER --> CORE
                    S_DONE      = 3'd6;


reg     [2:0]       state,      state_n;

reg    is_mode1;
reg    is_mode2;
reg    mode1_run;
reg    fetch_run;
reg    core_run;
reg    done;

reg    led_idle;
reg [19:0] cnt_len;


always @(posedge clk or negedge rst_n) begin
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

    is_mode1                = 'd0;
    is_mode2                = 'd0;
    mode1_run               = 'd0;
    fetch_run               = 'd0;
    core_run                = 'd0;
    done                    = 'd0;
    cnt_len                 = 'd0;
    led_idle                = 'd0;

    case(state)
        S_IDLE : begin
            if(mode1_start_i & !mode2_start_i) begin
                state_n             = S_MODE1;
            end
            else if(!mode1_start_i & mode2_start_i) begin
                state_n             = S_MODE2;
            end
        end
        S_MODE1 : begin
            is_mode1            = 'd1;
            if(!mode1_start_i & mode2_start_i & !start_i) begin
                state_n             = S_MODE2;
            end
            else if(start_i) begin
                state_n             = S_MODE1_RUN;
            end
        end  
        S_MODE1_RUN : begin
            is_mode1            = 'd1;
            mode1_run           = 1'd1;
            cnt_len             = 'd194400;
            if(mode1_done_i) begin
                state_n             = S_DONE;
            end
        end           
        S_MODE2 : begin
            is_mode2            = 'd1;
            if(mode1_start_i & !mode2_start_i & !start_i) begin
                state_n             = S_MODE1;
            end
            else if(start_i) begin
                state_n             = S_FETCH;
            end
        end
        S_FETCH : begin
            is_mode2            = 'd1;
            fetch_run           = 1'd1;
            cnt_len             = 'd1620;
            if(fetch_done_i) begin
                state_n             = S_CORE;
            end
        end
        S_CORE : begin
            is_mode2            = 'd1;
            core_run            = 1'd1;
            if(core_done_i) begin
                if(cnt_img_row_i == MAX_ROW - 1) begin
                    state_n             = S_DONE;
                end
                else begin
                    state_n             = S_FETCH;
                end
            end
        end
        S_DONE : begin
            done                = 1'd1;
            led_idle            = 1'd1;
            if(start_i) begin
                state_n             = S_IDLE;
            end
        end
    endcase
end


// =============== Memory Controller ========
assign mode1_run_o          = mode1_run;
assign fetch_run_o          = fetch_run;
assign cnt_len_o            = cnt_len;

assign is_mode1_o            = is_mode1;
assign is_mode2_o            = is_mode2;
// =============== Preprocess ========
assign core_run_o           = core_run;

// =============== 7-Segment ================
assign cnt_img_row_o        = cnt_img_row_i;

// ===========DEBUG ========
assign state_o        = state;
assign state_n_o      = state_n;

// =========== LED ===================
assign led_idle_o     = led_idle;

endmodule