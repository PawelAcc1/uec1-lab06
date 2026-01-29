module rx_top_test;

//local params
localparam int CLK_FREQ = 100_000_000;
localparam int BAUD_RATE = 115_200;

logic clk, rst_n, rx_line;
logic [9:0] frame; //1 1001 0110 0 
wire logic [7:0] data_out;
wire logic rx_done_tick;

//top module instance
rx u_rx (
    .clk(clk),
    .rst_n,
    .rx(rx_line),
    .dout(data_out),
    .rx_done_tick(rx_done_tick)
);

//clock generation
initial begin
    clk = 1'b0;
    forever #5ns begin
        clk = ~clk;
    end
end

task reset();
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) rst_n = 1'b1;
endtask

localparam int CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
task send_serial_data(input [11:0] frame);
    int i;
    for(i=0;i<10;i++) begin
        //divide input clock according to baudrate
        repeat(CLKS_PER_BIT) @(negedge clk);
        rx_line = frame[i];
    end
endtask

initial begin
    frame = 10'b1_1001_0110_0;
    rx_line = 1'b1;
    reset();
    fork
        //watek 1
        begin
            send_serial_data(frame);
            rx_line = 1'b1;
        end
        //watek 2
        begin
            @(posedge rx_done_tick) begin
                $display("####################");
                assert (frame[8:1] == data_out) begin
                    $display("No error detected. Expected: %b; Recieved: %b", frame[8:1], data_out);
                end else begin
                    $display("Error detected! Expected: %b; Recieved: %b", frame[8:1], data_out);
                end
                $display("####################");
            end
        end
    join
    $finish;
end
endmodule