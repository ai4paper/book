#import "../common.typ": *

= 环境搭建 (Environment Setup)

本章目标：搭好一个能用 agent 检索论文、阅读 PDF 的工作环境。
这是后面所有章节的前提。

== 模型入口：aiapi

- AI API proxy：#link("https://aiapi.isomoes.site/")[`https://aiapi.isomoes.site/`]
- 先把模型调用入口整理好，切换模型、接入不同服务时更方便。

== Agent 运行时：opencode / Claude Code

- 选择一个 agent runtime 作为日常工作界面。
- 与 VS Code 等编辑器的集成方式。

== MCP 工具安装与配置

- All-in-MCP 安装步骤。
- `apaper-mcp` 配置：#link("https://github.com/ai4paper/apaper-mcp")[`https://github.com/ai4paper/apaper-mcp`]
- 常见配置问题与排查。

== 本章检查点

搭建完成的标准（下一章开始前必须全部通过）：

- agent 能通过 MCP 工具检索到一篇最近发表的论文；
- agent 能读入一个本地 PDF 并给出内容摘要；
- 你知道去哪里看 agent 每一步实际调用了什么工具。
