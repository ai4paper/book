#import "../common.typ": *

= 写作：从草稿到可投版本 (Write the Paper)

实验结果出来后，真正耗时的往往是把内容整理成*期刊能接受的表达方式*。
AI 在这里最有价值的地方不是改语法，而是帮我们统一
*句子风格、段落逻辑、章节结构*——把「会写」推进到*更快写成能投的版本*。

== 本阶段研究基础

- 论文结构复习：abstract / introduction / methods / results / conclusion
  各自回答什么问题（对应第一章「论文这种文体」）。
- 先结构后句子：常见的低效方式是逐句打磨还没定结构的段落。
- Introduction 的经典推进：背景 → 空白 → 本文贡献。

== 风格对齐：ieee-journal-writing skill

- 仓库地址：#link("https://github.com/isomoes/skills")[`https://github.com/isomoes/skills`]
- 目标不是凭空生成内容，而是在*不改变技术含义*的前提下，
  把草稿改成更接近投稿的样子：
  - *Sentence style*：更正式、紧凑、符合 IEEE 风格；
  - *Section structure*：让各章节更有层次。
- 使用方式：先自己把技术内容写出来，再交给 AI 做期刊风格对齐；
  逐行 review AI 的修改，接受或拒绝。

== 排版与文献管理

- LaTeX / Typst 模板：直接复用 `typesetting` 仓库中的学术模板。
- `references.bib` 管理：让 agent 补全、去重、统一格式；
  *每一条 AI 生成的引用都必须核对真实存在*——假引用是最常见的幻觉。

== 本章练习

- 从贯穿示例的草稿中选一节（建议 introduction），
  用写作 skill 做一次期刊风格对齐：
  交付一份逐行可接受/拒绝的 diff，并记下 AI 哪些修改动了技术含义（应拒绝）。
