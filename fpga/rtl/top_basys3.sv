module top_basys3 (
    input wire clk,
    input wire btnC,
    input wire [7:0] sw,
    output wire RsTx
);

top u_tx (
    .tx(tx),
    .tx_done(tx_done), 
    .clk(clk),
    .rst_n(btnC),
    .din(sw[7:0])
);

endmodule
