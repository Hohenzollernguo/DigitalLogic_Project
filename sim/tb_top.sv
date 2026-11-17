`timescale 1ns / 1ps
module tb_top;
    reg sys_clk_in = 0;
    always #5 sys_clk_in = ~sys_clk_in;
    reg reset_pin = 1;
    reg [3:0] tile_sw = 0, btn_pin = 0;
    reg mode_sw = 0;
    wire [15:0] led_pin;
    wire [7:0] seg_cs_pin, seg_data_0_pin, seg_data_1_pin;
    top dut(.*);
    integer i;
    initial begin
        #2 reset_pin = 0;
        #1;
        if (dut.rst !== 1) $fatal(1, "Reset must assert asynchronously");
        repeat (3) @(negedge sys_clk_in);
        reset_pin = 1;
        @(posedge sys_clk_in); #1;
        if (dut.rst !== 1) $fatal(1, "Reset released too early");
        @(posedge sys_clk_in); #1;
        if (dut.rst !== 0) $fatal(1, "Reset failed to release after two clocks");
        if (dut.u_core.board !== 0 || dut.u_core.filled_count !== 0)
            $fatal(1, "Top reset wiring mismatch");
        if ({led_pin, seg_cs_pin, seg_data_0_pin, seg_data_1_pin} !== '0)
            $fatal(1, "Skeleton outputs must remain dark");

        // Exercise wiring independently of B's unimplemented renderer.
        force dut.output_blank = 0;
        force dut.info_leds = 8'b10010110;
        force dut.tile9_leds = 4'b1010;
        force dut.advanced_led = 0;
        force dut.game_led = 1;
        force dut.demo_led = 0;
        force dut.status_led = 1;
        #1;
        for (i = 0; i < 8; i = i + 1)
            if (led_pin[i] !== dut.info_leds[7-i]) $fatal(1, "Info LED order mismatch");
        for (i = 0; i < 4; i = i + 1)
            if (led_pin[8+i] !== dut.tile9_leds[3-i]) $fatal(1, "Tile9 LED order mismatch");
        if (led_pin[15:12] !== 4'b1010) $fatal(1, "Status LED mapping mismatch");
        force dut.output_blank = 1;
        #1;
        if (led_pin !== 0) $fatal(1, "Blank must override mode/status LEDs too");
        release dut.output_blank;
        release dut.info_leds; release dut.tile9_leds;
        release dut.advanced_led; release dut.game_led;
        release dut.demo_led; release dut.status_led;
        $display("PASS: tb_top (reset, LED wiring, blank; game flow NOT tested)");
        $finish;
    end
    initial begin #100000; $fatal(1, "Watchdog timeout"); end
endmodule
