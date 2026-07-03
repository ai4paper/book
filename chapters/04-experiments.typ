#import "../common.typ": *

= 实验：让 agent 并行执行 (Run the Experiments)

研究问题明确之后，下一步不是继续聊天，而是*执行计划、写实现、跑验证*。
本章讲如何把实验流程从「单线程手工推进」变成*多 agent 协同推进*。

== 本阶段研究基础

- 实验在研究里的角色：为你的 claim 提供证据，而不是「跑个程序」。
- 什么叫一个可信的实验：baseline、对照、可复现。
- 先写实验计划再动手：要验证什么、和谁比、怎么算「成功」。

== 核心思路：拆开流程，多 agent 并行

- 按任务拆分：*plan / implement / verify* 各由不同 agent 负责。
- 一个 agent 拆计划，一个写脚本或实现，一个跑检查和验证。
- 人不退出流程，而是在关键节点*看板式地检查、筛选和接管*。

== 工具：ikanban

- 项目地址：#link("https://github.com/isomoes/ikanban")[`https://github.com/isomoes/ikanban`]，
  详细介绍见 #link("https://github.com/isomoes/ikanban/tree/main/docs")[`/docs`]
- 本质是一个 *multi-agent coding workspace*：
  - *Home board*：集中看当前 session 状态，追踪实验整体进度；
  - *Review flow*：直接查看改动和 diff，快速检查实现是否合理;
  - *Task graph*：看 parent / child agent 结构，知道每个 agent 在做什么。

== 验证原则

- agent 写的每一段实验代码，合入前必须人工 review diff。
- 结果数字要能从脚本一键复现，不接受「agent 说结果是这样」。

== 本章练习

- 为贯穿示例设计一个最小实验，用 agent 分工推进：
  一个 agent 出计划，一个实现，一个验证；
  最后交付：经过你 review 的 diff + 一键复现脚本。
