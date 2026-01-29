module top_uart (
    input logic clk,
    input logic rst_n,
    input logic sw_in,
    input logic rx,
    output logic tx,
    output logic rx_empty,
    output logic tx_full
);

wire logic [7:0] r_data;
wire logic [7:0] w_data = r_data + 1;
wire logic debounce_out;

debounce u_debounce(
    .clk(clk),
    .rst_n(rst_n),
    .sw(sw_in),
    .db_tick(debounce_out),
    .db_level()
);

uart_module u_uart_module (
    .clk(clk),
    .rst_n(rst_n),
    .rx(rx),
    .tx(tx),
    .r_data(r_data),
    .w_data(w_data),
    .rd_uart(debounce_out),
    .wr_uart(debounce_out),
    .rx_empty(),
    .tx_full()
);
endmodule