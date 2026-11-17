# 分工与开发任务

来源为 Project 层三人分工报告；保留 A/B/C 所有权与 F/E 编号。状态全部为“待实现/待验收”，框架文件存在不代表对应任务完成。原报告 40/40/40 是计划工作量，不是已实现贡献比例。

开发约定（2026-11-17 更新）：默认不新增或扩写 testbench、仿真脚本及专门的仿真验证报告，也不将其作为交付前置条件。已有基础仿真文件仅保留参考，明确要求时再调整或运行；功能通过代码检查、联调和实机操作核对。

| 成员 | 主文件 | 首轮交付 | 后续功能 |
|---|---|---|---|
| A | rtl/core/game_core.v | 输入 9 格、合法性、移动判定、计数 | FSM、通关、统计阶段、撤回、演示载入 |
| B | rtl/display/*.v | 固定棋盘扫描、提示、物理方向 | 初始化 E/空白、LED 切换、十进制统计、闪烁 |
| C | rtl/input、rtl/control、rtl/common、top、XDC、scripts | 输入事件、命令握手、模式清理 | 5 幕演示、背压、集成、实机和交付 |

共享常量与接口文档由 C 汇总，A/B/C 共同约定。A 自行判移动，不依赖 B 的 hint_mask。B 可按固定棋盘独立核对提示与显示逻辑；C 按命令接口独立开发，不等待完整核心。

## 官方功能覆盖清单

| ID | 任务 | 负责人 | 文件落点 |
|---|---|---|---|
| F01 | 各阶段复位、清空 | A；B/C 配合 | game_core、reset_sync、显示/路由 |
| F02 | 逐格初始化 | A/C | game_core、input_frontend |
| F03 | 0～8 与重复校验 | A | game_core |
| F04 | 初始化逐格保持显示 | B | display_frontend |
| F05 | 错误 E/第九格全亮/闪烁 | A/B | game_core、display_frontend |
| F06 | 前八格/第九格/0 空白 | B/C | display_frontend、seg_scan、top |
| F07 | 按编号移动与邻接判定 | A/C | game_core、input_frontend |
| F08 | 交换、有效计数 | A | game_core |
| F09 | 无效计数、闪烁 | A/B | game_core、display_frontend |
| F10 | 按编号提示可移动棋子 | B | hint_logic |
| F11 | 提示/二进制统计切换 | B/C | display_frontend、command_router |
| F12 | 通关并保留棋盘 | A/B | game_core、display_frontend |
| F13 | 再确认显示十进制统计 | A/B | game_core、display_frontend |
| F14 | 棋盘和统计同步撤回 | A/C | game_core、command_router |
| F15 | 游戏/演示模式 | C/B | input_frontend、router、display_frontend |
| F16 | 5 幕演示、末幕全灭 | C；A/B 配合 | demo_controller、router、core、显示 |
| F17 | 高级外设/模式/状态灯 | B/C | display_frontend、top |
| F18 | 多位输入输出高位在左 | B/C | top、seg_scan、ego1.xdc |

## 工程与交付

- E01：三人确认 interfaces.md 与 decisions.md，变更后同步顶层及测试。
- E02：C 完成同步、消抖、单次脉冲、稳定采样与复位处理。
- E03：B 完成扫描、字符译码、十进制转换与闪烁节拍。
- E04：每人说明预期输入输出和核对方法；默认不制作仿真验证文件。
- E05：C 组织综合、实现、时序、DRC、bitstream 与工程重建；各自修所属模块。
- E06：三人上 EGO1 逐项验收并留证据。
- E07：C 组织课程 GitHub Classroom；三人保留真实提交记录。
- E08：确认组队登记、week16 同一实验课全员到场安排。
- E09：跟进后续视频与报告通知，按正式要求提交。
- E10：分别归档 FSM、数据通路、操作说明、测试、构建资料。
- E11：三人分别准备电路开发考察与项目问答。

## 里程碑

1. M0：骨架编译/展开/基础仿真；团队确认接口。当前交付到此阶段，确认工作仍待团队完成。
2. M1：A/B/C 各自最小闭环测试通过。
3. M2：补齐全部评分功能，F01～F18 均有功能测试证据。
4. M3：真实集成、时序/DRC 与 EGO1 实机验收。
5. M4：按照后续课程通知提交视频、文档和仓库。
