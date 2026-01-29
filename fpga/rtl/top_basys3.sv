module top_basys3 (
    input  logic clk,
    input  logic btnC,         
    input  logic RsRx,          
    input  logic [7:0] sw,       
    output logic RsTx,            
    output logic [7:0] led,       
    output logic [1:0] JB           
);

    /* 1. Sygnały wewnętrzne */
    logic rst_level;
    logic tx_wire;
    logic tx_done_wire;
    logic [7:0] rx_data_wire;

    /* 2. Debouncer dla Resetu (Stabilizacja przycisku) */
    debounce #(.N(22)) u_debounce_reset (
        .clk      (clk),
        .rst_n    (1'b1), 
        .sw       (btnC),
        .db_level (rst_level),
        .db_tick  ()
    );

    /* 3. Główna logika UART */
    top #(
        .MAX_CNT(20'd54),    
        .START(20'd10_800), 
        .DBIT(8),
        .SB_TICK(16)
    ) u_top (
        .clk          (clk),
        .rst_n        (~rst_level), 
        .rx           (RsRx),       
        .din          (sw),       
        .tx           (tx_wire),   
        .tx_done_tick (tx_done_wire),
        .dout         (rx_data_wire) 
    );

    
    assign RsTx  = tx_wire;
    assign led   = rx_data_wire;    
    
    assign JB[0] = tx_wire;
    assign JB[1] = tx_done_wire;

endmodule
