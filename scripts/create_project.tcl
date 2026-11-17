# Run with: vivado -mode batch -source scripts/create_project.tcl
source [file join [file dirname [info script]] sources.tcl]
create_project -force puzzle_ego1 [file join $repo_root build vivado] -part xc7a35tcsg324-1
set_property target_language Verilog [current_project]
set_property simulator_language Mixed [current_project]
foreach f $rtl_files { add_files -norecurse [file join $repo_root $f] }
add_files -norecurse [file join $repo_root rtl include project_defs.vh]
set_property include_dirs [list [file join $repo_root rtl include]] [get_filesets sources_1]
add_files -fileset constrs_1 -norecurse [file join $repo_root constraints ego1.xdc]
foreach f $sim_files { add_files -fileset sim_1 -norecurse [file join $repo_root $f] }
set_property include_dirs [list [file join $repo_root rtl include]] [get_filesets sim_1]
set_property top top [get_filesets sources_1]
set_property top tb_top [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
puts "SKELETON project created. Functional TODOs and board checks remain."
