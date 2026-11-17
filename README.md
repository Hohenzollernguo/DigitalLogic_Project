# CS207 数字华容道：EGO1 项目框架

当前为 **M0 开发骨架**，按三人分工采用基础外设方案。源码接口和顶层连接已建立，游戏功能尚未实现，不能用于课程功能验收。所有未实现位置带 `TODO(A/...)`、`TODO(B/...)` 或 `TODO(C/...)`。

## 从哪里开始

1. 阅读 [接口约定](docs/interfaces.md)、[分工与任务](docs/work_packages.md)。
2. 查看 [待确认事项](docs/decisions.md)，不要在各自模块中采用互相冲突的解释。
3. 运行基础仿真，然后从自己负责的模块和 testbench 开始开发。
4. 按 [测试清单](docs/test_plan.md) 补齐功能测试，在 [验收记录](docs/verification.md) 中登记证据。

## 目录

```text
rtl/
  include/project_defs.vh       共同常量：命令、阶段、棋盘、显示符号
  common/reset_sync.v           C：内部复位同步释放
  core/game_core.v             A：棋盘、阶段、计数、错误、撤回
  display/hint_logic.v         B：可移动棋子提示
  display/display_frontend.v   B：显示排版、LED 信息、视图切换
  display/seg_scan.v           B：双组数码管扫描
  input/input_frontend.v       C：同步、消抖、事件及拨码采样
  control/command_router.v     C：命令仲裁、模式清理
  control/demo_controller.v    C：演示步骤
  top.v                       C：顶层连接及 LED 物理位序
constraints/ego1.xdc           C：本项目使用的 51 个 IO、100 MHz 时钟
sim/tb_*.sv                   A/B/C：独立测试入口与顶层基础检查
scripts/                      工程创建、仿真、综合入口
docs/                         接口、任务、IO、歧义、测试与验证记录
deliverables/                 后续视频、报告、操作说明的归档约定
build/                        工具生成结果，已忽略，不提交
```

RTL 使用 Verilog-2001；testbench 使用 SystemVerilog，便于断言和失败退出。默认器件 `xc7a35tcsg324-1`，顶层 `top`，时钟 100 MHz。没有复制原始 PDF，也没有创建 Git 提交或连接 Classroom。

## 运行基础仿真

在本仓库目录打开 PowerShell；将路径改为本机实际 Vivado 安装位置：

```powershell
./scripts/run_sim.ps1 -VivadoBin 'D:/App/Vivado/2018.3/bin'
./scripts/run_sim.ps1 -VivadoBin 'D:/App/Vivado/2018.3/bin' -Test tb_game_core
```

已设置 `XILINX_VIVADO` 或在 PATH 中找到 `xvlog.bat` 时，可省略 `-VivadoBin`。日志位于 `build/sim/`。脚本遇到编译、展开、仿真失败或缺少 PASS 标记会报错。当前 PASS 只代表框架检查；各 testbench 会说明未测试的功能。

## 创建 Vivado 工程

在仓库目录用 Vivado 命令环境执行：

```text
vivado -mode batch -source scripts/create_project.tcl
```

也可以在 Vivado Tcl Console 中执行 `source {绝对路径/scripts/create_project.tcl}`。脚本生成 `build/vivado/puzzle_ego1.xpr`，加入 RTL、头文件、XDC 和四个仿真入口。默认仿真顶层为 `tb_top`，可在 Simulation Sources 切换；新建模块时同步修改 `scripts/sources.tcl`。

功能补全后，可使用 `vivado -mode batch -source scripts/build.tcl` 运行综合并导出报告。综合空壳可能被优化为常量；这不代表游戏已经实现。实现、时序收敛、DRC、生成 bitstream 和实机验证尚待 C 在集成阶段完成。

## 当前边界

- 已提供：模块端口、顶层接线、公共常量、复位同步器、视图选择寄存器、引脚约束、脚本和测试入口。
- 待实现：初始化、移动、计数、通关、撤回、提示、显示、消抖、命令路由和演示序列。
- 空壳核心 `cmd_ready=0`，命令控制不产生请求；`output_blank=1`，全部板上输出保持灭。
- 引脚分配依据随项目提供的 XDC。S6 极性、拨码物理左右方向、数码管位序必须按 [IO 表](docs/io_map.md) 实机核实。

依据：Project 层的《项目任务清单与三人分工报告.md》及《CS207_2026Project.pdf》§3～4；官方细则优先，本文中的接口命名与开发结构属于团队方案。
