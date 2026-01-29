module uart_tx_out_buffer (
    input  logic clk,
    input  logic rst_n,
    input  logic tx_in,
    input  logic tx_done_tick_in,
    output logic tx_out,
    output logic tx_done_tick_out
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_out <= 1'b1; // UART w IDLE musi być w stanie wysokim
            tx_done_tick_out <= 1'b0;
        end else begin
            tx_out <= tx_in;
            tx_done_tick_out <= tx_done_tick_in;
        end
    end
endmodule