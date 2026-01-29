module rx_top #(
    parameter BIT_TICKS = 54
)(
    input logic clk,
    input logic rst_n,
    input logic rx,
    output logic rx_done_tick,
    output logic dout
);

wire logic s_tick_ov;

counter #(.RST_VALUE(BIT_TICKS)) u_counter_s_tick (
    .clk,
    .rst_n,
    .enable(1'b1),
    .overflow(s_tick_ov),
    .value()
);

uart_rx u_uart_rx (
    .clk,
    .rst_n,
    .s_tick(s_tick_ov),
    .rx(rx),
    .dout(dout),
    .rx_done_tick(rx_done_tick)
);

endmodule