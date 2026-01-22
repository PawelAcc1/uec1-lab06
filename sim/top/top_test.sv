module top_test;

wire logic tx, tx_done;
logic clk, rst_n;
logic [7:0] din = 8'h8A;

top u_tx (
    .tx(tx),
    .tx_done(tx_done), 
    .clk(clk),
    .rst_n(rst_n),
    .din(din)
);

task reset();
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) rst_n = 1'b1;
endtask 

initial begin
    clk = 1'b0;
    forever #5ns clk = ~clk;
end


initial begin
reset();

repeat(50000) begin
    @(negedge clk);
end
$finish;
end


endmodule