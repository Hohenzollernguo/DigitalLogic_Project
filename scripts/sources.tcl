# Shared source manifest; no mock core is ever added to synthesis.
set repo_root [file normalize [file join [file dirname [info script]] ..]]
set rtl_files [list \
    rtl/common/reset_sync.v \
    rtl/core/game_core.v \
    rtl/display/hint_logic.v \
    rtl/display/display_frontend.v \
    rtl/display/seg_scan.v \
    rtl/input/input_frontend.v \
    rtl/control/demo_controller.v \
    rtl/control/command_router.v \
    rtl/top.v]
set sim_files [list sim/tb_game_core.sv sim/tb_display.sv sim/tb_control.sv sim/tb_top.sv]
