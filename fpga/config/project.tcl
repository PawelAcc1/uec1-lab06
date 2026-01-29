# Vivado project configuration file

set project_name top_basys3
set top_module top_basys3
set target xc7a35tcpg236-1

set xdc_files {
    constraints/top_basys3.xdc
}

set sv_files {
    ../rtl/uart/counter.sv
    ../rtl/uart/uart_tx.sv
    ../rtl/uart/uart_rx.sv
    ../rtl/uart_tx_out_buffer.sv
    ../rtl/top.sv
    rtl/top_basys3.sv
}
