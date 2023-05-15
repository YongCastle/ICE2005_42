module controller
(
    //From Switch
    input           start_i,

    //From Memory Controller (버퍼꽉차면)
    input           fetch_done_i,

    //From CORE
    input           core_done_i,

    //From Preprocessor
    input           cnt_row_i,
    input           cnt_col_i,
    
);




endmodule