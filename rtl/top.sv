module top #(
    parameter logic [19:0] MAX_CNT = 20'd54,  
    parameter logic [19:0] START   = 20'd10_800, 
    parameter int DBIT = 8,
    parameter int SB_TICK = 16 
)(
    input  logic clk,
    input  logic rst_n,
    input  logic rx,           
    input  logic [7:0] din,      
    output logic tx,            
    output logic tx_done_tick,
    output logic [7:0] dout      
);


    logic s_tick;       
    logic rx_done;     
    logic [7:0] rx_data; 
    
    logic timer_tick;     
    logic tx_start;     
    logic [7:0] tx_din; 
    
    logic tx_internal;    
    logic tx_done_internal;


    counter #(.RST_VALUE(MAX_CNT)) u_counter_s_tick (
        .clk(clk), .rst_n(rst_n), .enable(1'b1), .value(), .overflow(s_tick)
    );


    counter #(.RST_VALUE(START)) u_counter_tx_start (
        .clk(clk), .rst_n(rst_n), .enable(1'b1), .value(), .overflow(timer_tick)
    );


    uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) u_uart_rx (
        .clk(clk), .rst_n(rst_n), .rx(rx), .s_tick(s_tick),
        .rx_done_tick(rx_done), .dout(rx_data)
    );


    assign tx_start = rx_done || timer_tick;
    assign tx_din   = rx_done ? rx_data : din;
    
    assign dout = rx_data;

    
    uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) u_uart_tx (
        .clk(clk), .rst_n(rst_n), .tx_start(tx_start), .s_tick(s_tick),
        .din(tx_din), .tx(tx_internal), .tx_done_tick(tx_done_internal)
    );

    uart_tx_out_buffer u_uart_tx_out_buffer (
        .clk(clk), .rst_n(rst_n), .tx_in(tx_internal), .tx_done_tick_in(tx_done_internal),
        .tx_out(tx), .tx_done_tick_out(tx_done_tick)
    );

endmodule