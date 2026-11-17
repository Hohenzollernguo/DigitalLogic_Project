# 验证记录

## 框架检查（2026-11-17）

状态：框架检查通过。工具为本机 Vivado / XSim 2018.3。仅检查结构与基础行为，不是官方功能验收。

| 检查 | 结果 | 范围 |
|---|---|---|
| RTL 编译与顶层展开 | 通过 | xvlog 按 Verilog 编译 9 个 RTL 模块；测试单独按 SystemVerilog 编译；xelab 展开通过 |
| 4 个基础仿真入口 | 全部 PASS | tb_game_core、tb_display、tb_control、tb_top；复位/空闲、全灭、LED 位序 |
| Vivado 工程重建 | 通过 | create_project.tcl 退出码 0；生成 build/vivado/puzzle_ego1.xpr，器件、源文件、XDC、仿真顶层已加入 |
| XDC 管脚检查 | 通过（静态） | 51 个实际端口位全部覆盖，51 个独立引脚，逐项匹配原约束；存在 10 ns 时钟约束 |
| 游戏功能测试 | 未执行 | 功能模块仍为骨架 |
| 综合/实现/时序/DRC/bitstream | 未执行 | 后续集成任务 |
| EGO1 实机 | 未执行 | 极性、方向及功能仍待核实 |

复现命令见 README。仿真证据位于 `build/sim/tb_game_core.log`、`tb_display.log`、`tb_control.log`、`tb_top.log`，每份包含对应 PASS 标记；最终一轮使用独立 Verilog/SystemVerilog 编译入口，顶层用非对称 LED 图样检查位序。

Vivado 启动时报告本机 Tcl Store 目录无写权限（Common 17-741），自动回退安装目录；工程创建仍成功退出。此环境提示不属于游戏功能验证结果。未运行综合或实现，因此静态引脚检查也不等同于 Vivado 实现阶段 DRC。

## 后续记录模板

日期 / 负责人 / 版本或提交 / 测试编号 / 输入 / 预期 / 实际 / 结论 / 证据路径。
