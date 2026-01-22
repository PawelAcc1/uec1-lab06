# Copyright (C) 2026  AGH University of Krakow
# MTM UEC
# Author: Piotr Kaczmarczyk
# Modifications: Lukasz Kadlubowski
#
# Description:
# Tcl script being sourced to Vivado to build a project from sources and
# generate a bitstream.

set build_dir $env(FPGA_BUILD_DIR)

# Read project configuration file
source $env(FPGA_DIR)/config/project.tcl

proc create_new_project {project_name target top_module build_dir} {
    create_project ${project_name} ${build_dir} -part ${target} -force

    # read files from the variables provided by the configuration file
    if {[info exists ::xdc_files]} {read_xdc ${::xdc_files}}
    if {[info exists ::sv_files]} {read_verilog -sv ${::sv_files}}

    set_property top ${top_module} [current_fileset]
    update_compile_order -fileset sources_1
}

proc generate_bitstream {} {
    # Run synthesis
    reset_run synth_1
    launch_runs synth_1 -jobs 8
    wait_on_run synth_1

    # Run implementation up to bitstream generation
    launch_runs impl_1 -to_step write_bitstream -jobs 8
    wait_on_run impl_1
}

puts $sv_files
create_new_project $project_name $target $top_module $build_dir
generate_bitstream
exit
