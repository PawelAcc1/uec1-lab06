module uart_module #(
    parameter int BIT_TICKS = 54
)(
    input logic clk,
    input logic rst_n,
    input logic rx,
    input logic rd_uart,
    input logic [7:0] w_data,
    input logic wr_uart,
    output logic tx,
    output logic [7:0] r_data,
    output logic rx_empty,
    output logic tx_full
);

wire logic [7:0] dout;
wire logic rx_done_tick;
wire logic tx_done_tick;
wire logic [7:0] din;
wire logic s_tick_ov;
wire logic tx_fifo_empty;

counter #(.RST_VALUE(BIT_TICKS)) u_baud_rate_generator (
    .clk(clk),
    .rst_n(rst_n),
    .enable(1'b1),
    .overflow(s_tick_ov),
    .value()
);

//reciever section
uart_rx u_reciever (
    .clk(clk),
    .rst_n(rst_n),
    .rx(rx),
    .s_tick(s_tick_ov),
    .dout(dout),
    .rx_done_tick(rx_done_tick)
);

fifo u_reciever_fifo (
    .clk(clk),
    .rst_n(rst_n),
    .w_data(dout),
    .wr(rx_done_tick),
    .r_data(r_data),
    .rd(rd_uart),
    .empty(rx_empty),
    .full()
);

//transciever section
uart_tx u_tranciever (
    .clk(clk),
    .rst_n(rst_n),
    .tx(tx),
    .din(din),
    .s_tick(s_tick_ov),
    .tx_done_tick(tx_done_tick),
    .tx_start(!tx_fifo_empty)
);

fifo u_tranciever_fifo(
    .clk(clk),
    .rst_n(rst_n),
    .w_data(w_data),
    .wr(wr_uart),
    .rd(tx_done_tick),
    .empty(tx_fifo_empty),
    .full(tx_full),
    .r_data(din)
);

endmodule