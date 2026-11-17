# Optional synthesis entry; this does NOT claim functional or board readiness.
# Current shells may be optimized into constants. Implement modules first.
source [file join [file dirname [info script]] create_project.tcl]
launch_runs synth_1 -jobs 2
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
    error "Synthesis did not complete. Inspect build/vivado run logs."
}
open_run synth_1
report_utilization -file [file join $repo_root build utilization.rpt]
report_timing_summary -file [file join $repo_root build timing_synth.rpt]
puts "Synthesis finished; implementation, timing closure, DRC and board tests remain."
