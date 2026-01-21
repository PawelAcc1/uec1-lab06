module top #(
    parameter BIT_TICKS = 16,
    parameter DATA_LENGHT = 8
)(
    output logic tx,
    input logic clk,
    input logic rst_n,
    input logic [7:0] din
);

//inner connections
wire logic tick_ov;
wire logic tx_start_ov;

//tick counter
counter #(.RST_VALUE(BIT_TICKS)) u_counter_s_tick (
    .clk, 
    .rst_n, 
    .enable(1'b1), 
    .value(), 
    .overflow(tick_ov)
);

//TX start counter
counter #(.RST_VALUE(DATA_LENGHT)) u_counter_tx_start (
    .clk,
    .rst_n,
    .enable(1'b1),
    .value(),
    .overflow(tx_start_ov)
);

//uart
uart_tx u_uart_tx (
    .clk,
    .rst_n,
    .tx_start(tx_start_ov),
    .s_tick(tick_ov),
    .din,
    .tx_done_tick(),
    .tx
);

endmodule