# Specify waves to be saved during the simulation
# log_wave *      # top module signals only
log_wave -r * # all the design signals

# Run the simulation untill $finish
run all

# Show waveforms
add_wave /      # top module signals only
# add_wave -r / # all the design signals
