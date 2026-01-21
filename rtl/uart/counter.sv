/* Copyright (C) 2025  AGH University of Krakow */

module counter #(
    parameter logic [9:0] RST_VALUE = 20'd500_000
)(
    input logic clk,
    input logic rst_n,
    input logic enable,
    output logic [19:0] value,
    output logic overflow
);


/* Local variables and signals */

logic [19:0] value_nxt;
logic overflow_nxt;

/* Module internal logic */

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        value <= 20'b0;
        overflow <= 1'b0;
    end else begin
        value <= value_nxt;
        overflow <= overflow_nxt;
    end
end

always_comb begin
    value_nxt = value;
    overflow_nxt = 1'b0;
    if (enable) begin
        if(value < RST_VALUE) begin
            value_nxt = value + 1;
        end
        else begin
            value_nxt = 20'b0;
            overflow_nxt = 1'b1;
        end
    end

end

endmodule
