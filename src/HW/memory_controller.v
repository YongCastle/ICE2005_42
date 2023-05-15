module memory_controller
(
    input       

    output       fetch_done_o,
);

reg [1:0] cnt_buf_row;
reg [9:0] cnt_buf_col; 




assign fetch_done_o     = ((cnt_buf_row == 3-1) && (cnt_buf_col == 540-1));

endmodule