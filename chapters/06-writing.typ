#import "../common.typ": *

= 写作：从草稿到可投版本 (Write the Paper)

到这一章，材料已经齐了：第 3 章的研究空白报告、第 4 章可复现的实验、
第 5 章 camera-ready 的图表。剩下的事是把它们组织成
*期刊能接受的表达*。AI 在这里最有价值的地方不是改语法，
而是在*不改变技术含义*的前提下统一句子风格与段落逻辑，
并在章节结构上当顾问——
把「会写」推进到「更快写成能投的版本」。分工仍是 @foundations:map
的那一列：AI 铺开改写候选，人逐行接受或拒绝。

== 本阶段研究基础

=== 结构复习：每一节回答一个问题

第 1 章说过，论文的固定结构是为跳读的审稿人设计的*接口约定*：
abstract 回答「这篇论文一句话是什么」，introduction 回答
「为什么该做、别人做到哪、你补上了什么」，methods 回答「怎么做的」，
results 回答「证据是什么」，conclusion 回答「所以呢」。
introduction 的经典推进是*背景 → 已有工作 → 空白 → 本文贡献*——
注意「空白」这一环不用现想：第 3 章报告里核对过的那几条空白，
就是 introduction 的骨架，related work 也从同一份报告展开。

=== 先结构后句子

新手最常见的低效方式，是逐句打磨一个结构还没定的段落——
句子磨得再亮，段落删掉重排时全部作废。正确的顺序是：
先搭骨架（每一节列出段落，每段只写一句话题句），
确认骨架能把 story 讲通；再往里填内容；最后才轮到句子。
AI 的参与也按这个顺序分层：结构层让它*当顾问*——
「这两段的顺序对吗」「这个实验放 results 还是 discussion」；
句子层它才*动手改*——下一节的 skill 干的就是句子层的活。

=== 技术内容必须自己先写

让 AI 从零生成正文，是写作阶段最大的陷阱：它不知道你的方法细节
和实验设计，只能编——而成段的 AI 生成正文也踩在第 1 章
学术诚信的披露线上。本章的用法自始至终是一句话：
*你写难看但正确的草稿，AI 把它改得像样*。
语言润色属于普遍接受的用法；内容必须出自你手。

三条基础合起来，就是本章的工作流（@writing:pipeline）：
人先搭骨架、写草稿，AI 在中段做风格对齐，出口前经过人逐行 review，
最后排版、核对文献，得到可投的初稿。

#figure(
  image("../figures/writing-pipeline.pdf", width: 100%),
  // caption stays on one source line: line breaks inside captions render as spaces
  caption: [写作工作流：空白报告与实验图表进场，人搭骨架、写出技术内容正确的草稿；AI 用 writing skill 做风格对齐，产出的修改由人逐行接受或拒绝，被拒绝的退回重改；最后排版并核对文献，得到可投初稿。],
) <writing:pipeline>

== 风格对齐：writing skill

第 5 章装 `apaper-plugin` 时，`writing` skill 已经一起装进来了
（当时只装了画图 skill 的话，用 `ocx add apaper/writing` 补上；
走插件市场安装的话，两个 skill 都已装好）。它把「学术论文的英语怎么写」固化成
一套 agent 自动取用的规矩，来源是
#link("https://github.com/isomoes/skills")[`isomoes/skills`]，
面向期刊（IEEE 风格）投稿场景。

=== 它固化了哪些规矩

挑几条最常用的——也建议你打开 skill 文件把规则完整读一遍，
它们本身就是一份浓缩的学术写作教程：

- *结论先行*（point-first）：每段第一句给出 claim，
  推理和证据跟在后面；从笔记直译过来的「背景先行」段落会被重组；
- *一段一件事*：一段只做一个论证，重复邻近内容的句子删掉；
- *措辞与证据成比例*：删掉 "it should be noted that" 这类空话、
  "novel"、"clearly" 这类断言词，换成具体的数字、比较和出处；
- *期刊惯例*：默认避免第一人称（"we propose" 改成
  "this paper proposes"，"our method" 改成 "the proposed
  method"）；contribution 列表用固定引入句；图表配「呈现」类
  动词——图 *shows*、表 *lists*，做研究的是作者，不是图表。

=== 用法与一个例子

用法三步：选一段*自己写好的*草稿，让 skill 对齐，逐行 review。
提示模板：

```text
用 writing skill 把下面的段落对齐到 IEEE 期刊风格：
不改变任何技术声明、数字与限定词；保留全部引用标记；
逐条列出修改及理由。
<粘贴你的段落>
```

看一个具体例子。对齐前——数字和范围都在，技术内容正确，
表达是草稿味：

```text
It should be noted that our novel method is very effective.
We conducted extensive experiments on five datasets: on
average our method reduces the end-to-end latency by 38%,
and it clearly outperforms the strongest baseline on four
of the five datasets.
```

对齐后：

```text
The proposed method reduces end-to-end latency by 38% on
average across five datasets (Section V), outperforming the
strongest baseline on four of them.
```

三句并成一句，每处改动都对得上规矩：删掉 "it should be noted
that"（空话）；删掉 "very effective" 和 "clearly"——数字和
范围本来就在场，断言词只是在给它们注水（措辞与证据成比例）；
"our novel method" 降为 "the proposed method"——novelty
由审稿人判断，不由作者宣称；结论先行，证据指向 Section V。
注意所有数字和限定词原封未动：skill 的规矩明写着不许编造数据——
草稿里没有数字时，它的正确行为是标注「此处缺证据」让你去补，
而不是替你发明一个。

=== review 的红线：技术含义

再看一个*应当拒绝*的修改。草稿写的是：

```text
The method achieves up to 2.1x speedup on two of the five
datasets.
```

AI 改成了：

```text
The method achieves a 2.1x speedup.
```

句子确实更干净——但 "up to"（最好情形）和 "on two of the five
datasets"（适用范围）被删掉，一条谨慎的结果声明变成了普遍成立的
强 claim。这不是润色，是*改结果*。逐行 review 时盯住四类东西：
*数字与单位*、*限定词*（up to / on average / in most cases）、
*因果还是相关*、*claim 的强度*。这四类只要被动过，默认拒绝，
除非你确认新表述仍然为真。

#warning-box[
  为什么必须逐行：风格对齐的输出*整体上*几乎总是更顺的，
  顺到让人想整段接受——而技术含义的漂移恰恰藏在最顺的那几句里。
  经验规则：AI 改十处，九处是纯表达，一处动了含义，
  你的工作就是找出那一处。用 diff 视图（`git diff` 或编辑器的
  对比模式）逐处过，比通读两遍可靠得多。
]

== 排版与文献管理

=== 模板：不要从零排版

排版的正确起点是一份现成模板。论文正文一律以目标期刊或会议的
官方模板为准；期刊没有官方 Typst 模板时，Typst Universe 上有
社区维护的期刊风格模板可用。论文之外的周边文书——学术报告、
审稿意见、rebuttal、幻灯片——可以直接复用
#link("https://github.com/isomoes/typesetting")[`typesetting`]
仓库里的模板（Typst，含中文支持）。
第 5 章产出的图以 PDF 原尺寸插入，
不要在插入时缩放——那条「图内文字等于正文字号」的规矩，
在排版阶段最容易被一句 `width: 80%` 悄悄破坏。

=== references.bib：从源头杜绝假引用

文献管理的正道在第 3 章已经铺好：检索用 `apaper-mcp`，
DBLP / arXiv 查到即带回 BibTeX——每条引用都从*检索结果*进入
`references.bib`，而不是从模型记忆里冒出来。
写作阶段让 agent 做维护性的整理：

```text
整理 references.bib：
1. 去重——同一论文的 arXiv 版和正式发表版只保留正式版，
   正文中引用被删条目的地方改指保留的那条；
2. 统一 citation key 风格为 <作者+年份>，同步更新正文里的引用；
3. 列出正文引用了但 bib 里没有、以及 bib 里有但正文没引用的条目；
4. 不许新增任何一条检索工具没有返回过的文献。
```

#warning-box[
  第 1 章关于假引用的警告，就是在「写作时顺手补一条文献」的场景里
  兑现的。规矩收紧成两条：一、模型*凭记忆*给出的文献一律不进
  bib——必须经 `apaper-mcp` 检索确认真实存在；二、每条引用
  在正文里支撑的说法，抽查回原文，确认原文真的说过。
  宁可留一个 `TODO` 待查，不可放一条没核对的引用进稿子。
]

== 本章练习

#exercise[
  对贯穿示例做一次完整的写作循环，建议从 introduction 开始：
  + *搭骨架*：列出 introduction 的段落，每段一句话题句；
    「空白」一段直接使用第 3 章报告里核对过的空白；
  + *写草稿*：自己把每段写满——难看没关系，正确就行；
  + *风格对齐*：用 `writing` skill 对齐，产出一份逐行可
    接受 / 拒绝的 diff；
  + *逐行 review*：记录接受与拒绝的数量；重点找出至少一处
    「更顺了但含义变了」的修改并拒绝——一处都找不到，
    多半说明没有逐行读；
  + *文献*：让 agent 按上面的模板整理 `references.bib`，
    新增条目逐条核对存在性。
  交付：对齐前后的两版 introduction，加上 review 记录
  （拒绝了哪些、为什么）。这份稿子，下一章拿去选刊与投稿。
]
