#import "../common.typ": *

= 环境搭建 (Environment Setup)

第 1 章把工具拆成了三层：LLM 是「预测下一个词」的引擎，agent 是围绕它的执行循环，
MCP 是让循环接上外部世界的插座。这一章就是把这三层各自接上电——
到本章结束，你会有一个能*检索论文、读入 PDF、而且每一步都能被你查看*的 agent。
它不是流水线上的某一段，而是让整条流水线开动起来的*前提*，
所以它没有出现在 @foundations:map 那张分工地图里。

先给一个让人安心的结论：*这一步选的工具不会把你锁死*。
第 1 章强调 MCP 是「标准协议」，好处此刻兑现——
论文检索、PDF 下载这些能力一旦实现成一个 MCP server，
换 agent 运行时、换模型都不必重搭。所以本章之后各章的操作，
不管你现在选下面哪一套 runtime，都同样适用。

三层对应三步，是本章的骨架：

#align(center)[
  *模型入口（给引擎供电）→ agent 运行时（执行循环）→ MCP 工具（外部插座）*
]

== 模型入口：模型 API

agent 每走一步都要请求一次模型，所以第一件事是拿到一个*模型 API*——
某个模型服务的 *API key* 加它的*访问地址*。用哪家都行，只要接口兼容 OpenAI
或 Anthropic 的调用风格（主流服务几乎都兼容）；本书拿 *DeepSeek* 当例子，
因为它便宜、公开、注册即用，opencode 和 Claude Code 都好接。

#note-box[
  为什么能随便换：runtime 说的是 OpenAI / Anthropic 那套标准接口，
  任何讲同一套接口的服务都能顶上去——官方 API、聚合代理（如 OpenRouter）、
  乃至自建网关，对 runtime 来说都只是「一个 base URL + 一个 key + 一个模型名」。
  下面的配置换个服务时，改的永远是这三个值，结构不动。
]

具体两步：在 #link("https://platform.deepseek.com/")[DeepSeek 平台] 注册，创建一个 API key 记下来。
它的访问地址是现成的——Anthropic 风格用 `https://api.deepseek.com/anthropic`，
模型名用 `deepseek-chat`（下一节按 runtime 填进去）。换别的服务时，
去它的控制台照样拿这三样（key / 地址 / 模型名）即可。

至于*选哪个模型、怎么付费*，其实是同一个决定的两面，拿到模型访问大致两条路。
一是*按量付费的 API*：上面 DeepSeek 就是这条，按 key 用量结算；
第三方聚合代理（如 OpenRouter）也算这条，一个 key 打通多家、想换就换。
二是*订阅制的 code plan*：如 Claude Code Pro、OpenAI Codex，
固定月费换一份带频率上限的额度，稳定的单 agent 日常最划算；
走这条时让 runtime 直接登录订阅、连 API key 都不用配。
一次复杂的 agent 会话在贵的官方模型上大约要 1 到 3 美元，这正是便宜渠道和订阅都存在的理由。
经验法则很简单：*难的活交给最强的模型，量大又简单的活分给便宜的*——
本书大多是单 agent、单任务的节奏，不必一开始纠结，先用一个够强的模型跑起来，嫌贵再往下降配。

== Agent 运行时：opencode / Claude Code

有了模型入口，接下来选一个 *agent 运行时*（runtime）作为日常界面——
它就是第 1 章说的那个「执行循环」：接收你的指令，调用模型和工具，
看到结果再决定下一步。两个成熟的选择，任选其一即可，本书对两者都适用：

/ opencode: 开源、不绑定厂商，支持 75+ 模型 provider；DeepSeek、KIMI、Qwen 等都能接、想换就换。
  适合还没有 Claude 订阅、或想在多模型间自由切换的人。
/ Claude Code: Anthropic 官方 CLI，单一模型下体验最完整；
  通过环境变量指向任一 Anthropic 兼容端点（DeepSeek，或 Anthropic 官方）。适合有 Claude 订阅、想要最顺一条路的人。

两者都能装进 VS Code（在扩展市场里搜索并安装官方扩展，`Ctrl+Shift+X`），MCP 的配置方式也几乎一致。
下面各给一份接 DeepSeek 的最小配置，选一套跟着做即可；后文示例默认用 opencode。

=== opencode

安装（脚本，或包管理器）后验证版本：

```bash
curl -fsSL https://opencode.ai/install | bash   # 或 npm i -g opencode-ai / brew install opencode
opencode --version
```

DeepSeek 是 opencode 内置的 provider，所以配置很短——在项目根目录的 `opencode.json`
（或全局 `~/.config/opencode/opencode.json`）里登记一下：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "deepseek": {
      "models": { "deepseek-chat": {} }
    }
  }
}
```

启动后用 `/connect` 选 DeepSeek、填入 API key（key 存到本地，不写进配置文件），
再用 `/models` 切换模型。若你用的是自建网关或聚合器这类*非内置*的 OpenAI 兼容端点，
把 provider 换成一个自定义项——`"npm": "@ai-sdk/openai-compatible"`，
在 `options.baseURL` 填端点地址、`apiKey` 用 `{env:...}` 从环境变量取，`models` 里写它的模型名。

=== Claude Code

安装后用环境变量把它指向 DeepSeek 的 Anthropic 兼容端点：

```bash
npm install -g @anthropic-ai/claude-code

export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic   # 换服务时改这三个值
export ANTHROPIC_AUTH_TOKEN=<你的 DeepSeek API key>
export ANTHROPIC_MODEL=deepseek-chat
claude                                                         # 在项目目录里启动
```

就是把 Claude Code 从默认的 Anthropic 官方接口，改指到任一 Anthropic 兼容端点——
换掉 base URL、token、model 三个值即可。（有 Claude 订阅的话跳过这三行，直接 `claude` 用官方额度。）

== MCP 工具：apaper-mcp

runtime 自己只会读写本地文件、跑命令；要让它*检索论文*，得给它接上一个 MCP 工具。
本书用 #link("https://github.com/ai4paper/apaper-mcp")[`apaper-mcp`]——
一个专做学术检索的 MCP server，覆盖 *arXiv、IACR ePrint、DBLP、Google Scholar、CNKI*，
既能搜索，也能把论文 PDF 下载到本地。它就是第 1 章那个「插座」的具体样子。

安装（需要 Node 环境；全局装，或配置里用 `npx` 直接跑、免安装）：

```bash
npm install -g @ai4paper/apaper-mcp
```

opencode 就在上面那个 `opencode.json` 里，和 `provider` 并列再加一个 `mcp` 键
（是往同一个文件里补，别用下面这块把刚配好的 `provider` 整个替换掉）：

```json
{
  "mcp": {
    "apaper-mcp": {
      "type": "local",
      "command": ["npx", "@ai4paper/apaper-mcp"],
      "enabled": true
    }
  }
}
```

Claude Code 则把它写进项目根的 `.mcp.json`：

```json
{
  "mcpServers": {
    "apaper-mcp": { "command": "npx", "args": ["@ai4paper/apaper-mcp"] }
  }
}
```

再在项目的 `.claude/settings.json`（或全局 `~/.claude/settings.json`）里加一行
`"enableAllProjectMcpServers": true`，启动时就会自动拉起项目里的 MCP server；
不加也行——Claude Code 首次启动会问你要不要信任它。

接好之后，agent 手里会多出 `search_arxiv_papers`、`download_arxiv_paper`、
`search_dblp_papers` 等一组工具。想确认它是否真的连上：Claude Code 用 `/mcp` 命令
列出已连接的 server 和它暴露的工具；opencode 没有这个命令，直接让 agent 调一次工具、
在 TUI 里逐条看它的工具调用即可（`/details` 切换详情）。

#tip-box[
  分工要记清：`apaper-mcp` 只负责*检索与下载*，把 PDF 落到本地，它自己并不解析 PDF。
  *读 PDF、写摘要*是 runtime 加模型的事，而这一步成不成，取决于你接入的模型
  是否支持*文档输入*：真正的 Claude 这类文档能力模型，Claude Code 能把 PDF 直接送进去读；
  换成只吃文本的模型（DeepSeek / GLM / Qwen 等）、或者用 opencode，就先补一步
  `pdftotext paper.pdf paper.txt`，再让 agent 读那个 `.txt`。所以「读一篇本地 PDF 并总结」
  考的是这一整套是否接通，而不是某一个工具单独够不够。
]

== 复用层：command、agent 与 skill

三步搭完，环境已经能用了。最后认识一层长在 runtime 之上的东西——
它不改动「模型 + 循环 + 工具」这套骨架，只是把*反复要做的动作固化下来*，
让你下次一句话就能唤起。后面几章交给你的现成工具，大多属于这一层：

/ command: 一条标准化快捷指令，用 `/名字` 触发。把你反复敲的那段提示词存成文件
  （opencode 放 `.opencode/command/`，Claude Code 放 `.claude/commands/`），
  下次一句 `/find-paper "..."` 就跑完一整套检索。适合*步骤固定、每次都想要同样表现*的活。
/ agent（subagent）: 一个带独立指令、独立工具权限的自主助手，你把一类任务整个托付给它，
  它自己判断、多步执行（opencode 放 `.opencode/agent/`，Claude Code 放 `.claude/agents/`）。
  适合*需要临场判断*的活，比如「做一遍这个方向的文献综述」。
/ skill: 一包可复用的专门知识，agent 在任务对得上时自动取用——
  比如一个「按 IEEE 期刊风格改写」的写作 skill（见
  #link("https://github.com/isomoes/skills")[`isomoes/skills`]）。本书自己就是用几个 skill 写成的。

一句话分辨：command 和 agent 偏「你主动触发一段流程」，
skill 偏「模型在合适的时机自己拿起一套规矩」。
现在不必建任何一个，只要知道这层槽位在哪、文件该放进哪个目录——
从第 4 章起会陆续给出现成的 skill（计划执行、画图、写作），
装进这些目录就能直接用。

== 本章检查点

这一章没有练习，只有一份*验收清单*——三条全部通过，才算这套环境真的能用，
下一章带着自己的研究问题上路时才不会卡在工具上：

#exercise[
  + *检索*：让 agent 用 `apaper-mcp` 检索一篇最近发表的论文并下载到本地——
    确认它真的调用了检索工具、拿回了真实结果，而不是凭记忆编出一条。
  + *读入*：让 agent 读入这篇（或任意一篇）本地 PDF，给出它方法部分的摘要
    （文档能力模型可直接读；opencode 或纯文本模型先 `pdftotext paper.pdf paper.txt` 再读 `.txt`）。
  + *可观测*：找到*在哪里看 agent 每一步到底调用了什么工具*——
    opencode 的 TUI 会逐条列出工具调用，Claude Code 会在终端里展开每次调用，
    VS Code 的 MCP 面板也能看到 server 的输入与输出。
]

第三条最容易被跳过，却最重要，因为它接着第 1 章那句话：
*验证 AI 的产出，常常要从验证它的过程开始*。
一份「没真的检索、没真的读 PDF」就写出来的摘要，再流畅也不可信；
而只要你知道去哪里看它每一步做了什么，这种不可信就无处藏身。
三条通过，环境即就位——从下一章起，我们带上一个具体的研究问题，让它真正跑起来。
