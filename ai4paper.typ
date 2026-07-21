#import "@preview/theorion:0.3.2": *

// Document configuration
#let title = "AI4Paper"
#let author = "isomoes"
#let date = datetime.today()

// Custom color scheme inspired by elegant academic style
#let primary-color = rgb("#20B2AA")  // Light sea green
#let secondary-color = rgb("#4682B4") // Steel blue
#let accent-color = rgb("#DC143C")    // Crimson
#let text-color = rgb("#2F4F4F")      // Dark slate gray

// Page setup with academic styling
#set page(
  paper: "a4",
  margin: (left: 2.5cm, right: 2.5cm, top: 3cm, bottom: 3cm),
  number-align: center,
  header: context {
    if counter(page).get().first() > 1 {
      align(center, line(length: 100%, stroke: 0.5pt + gray))
      v(-0.75em)
      align(center, text(size: 10pt, fill: gray, title))
    }
  },
)

// Typography setup
#set text(
  font: ("New Computer Modern", "Source Han Serif"),
  size: 11pt,
  fill: text-color,
  lang: "zh",
  fallback: true,
)

#set par(
  justify: true,
  leading: 0.65em,
  spacing: 1.2em,
)

// Heading numbering
#set heading(numbering: "1.1")

// Heading styles
#show heading.where(level: 2): it => {
  v(1.5em)
  block[
    #set text(size: 16pt, weight: "bold", fill: secondary-color)
    #if it.numbering != none [
      #counter(heading).display(it.numbering)
      #h(0.5em)
    ]
    #it.body
    #v(0.5em)
    #line(length: 100%, stroke: 1pt + secondary-color)
  ]
  v(1em)
}

#show heading.where(level: 3): it => {
  v(1em)
  block[
    #set text(size: 14pt, weight: "bold", fill: text-color)
    #if it.numbering != none [
      #counter(heading).display(it.numbering)
      #h(0.5em)
    ]
    #it.body
  ]
  v(0.75em)
}

// Configure theorem environments with theorion
#show: show-theorion

// Collapse the spurious space a source line break leaves between CJK characters
#import "@preview/cjk-unbreak:0.1.1": remove-cjk-break-space
#show: remove-cjk-break-space

// Style all links with blue color and underline
#show link: it => {
  set text(fill: rgb("#1E90FF"))
  underline(it)
}

// Customize reference display to show section number and title
#show ref: it => {
  let styled-content = if it.element != none and it.element.func() == heading {
    let el = it.element
    let number = if el.numbering != none {
      numbering(el.numbering, ..counter(heading).at(el.location()))
    }
    if number != none {
      link(it.target)[#number #el.body]
    } else {
      link(it.target)[#el.body]
    }
  } else {
    it
  }

  // Apply blue color and underline to all references
  set text(fill: rgb("#1E90FF"))
  underline(styled-content)
}

// Let table figures break across pages instead of leaving large gaps
#show figure.where(kind: table): set block(breakable: true)

// Figure and table numbering (chapter-based, resets per chapter)
#set figure(numbering: num => {
  let h = counter(heading).get().first()
  numbering("1.1", h, num)
})

// Reset figure counter at each level 1 heading
#show heading.where(level: 1): it => {
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: raw)).update(0)

  pagebreak(weak: true)
  v(2em)
  block[
    #set align(center)
    #set text(size: 20pt, weight: "bold", fill: primary-color)
    #if it.numbering != none [
      #counter(heading).display(it.numbering)
      #h(0.5em)
    ]
    #upper(it.body)
    #v(1em)
    #line(length: 60%, stroke: 2pt + primary-color)
  ]
  v(1.5em)
}

// Math equation numbering
#set math.equation(numbering: "(1)")

// Bibliography setup
#let bibliography-file = "references.bib"

// Custom functions for colored text shortcuts
#let redt(content) = text(fill: rgb("#DC143C"), content)
#let bluet(content) = text(fill: rgb("#1E90FF"), content)
#let greent(content) = text(fill: rgb("#32CD32"), content)

// Title page
#align(center)[
  #v(2cm)
  #text(size: 24pt, weight: "bold", fill: primary-color)[
    #upper(title)
  ]
  #v(1cm)
  #text(size: 14pt, fill: secondary-color)[
    AI 工具助力论文写作与发表全流程 \
    从选题到发表 · from finding a problem to getting published
  ]
  #v(2cm)
  #text(size: 12pt)[
    *Author:* #author \
    *Date:* #date.display("[month repr:long] [day], [year]")
  ]
  #v(1cm)
  #line(length: 50%, stroke: 1pt + primary-color)
]

#pagebreak()

// Table of contents with Roman numerals
#set page(numbering: "i")
#counter(page).update(1)

#outline(
  title: [Table of Contents],
  indent: auto,
  depth: 2,
)

#pagebreak()

// Preface (unnumbered)
#heading(numbering: none)[前言]

#warning-box[
  本书仍在写作迭代中，*尚未正式发布*：章节结构和内容后续都可能有较大改动。
  书中涉及的 AI 工具与相关结论，以本版本的编译日期
  （#date.display("[year] 年 [month padding:none] 月 [day padding:none] 日")）为准——
  这个领域变化很快，请注意时效。
]

这本书写给两类读者：一类是*科研新手*——还没有做过研究、也不清楚研究流程本身的同学，
可以在这本书里同时学会「怎么做研究」和「怎么用 AI 工具做研究」；
另一类是已经在写论文、但还没有把 AI 工具接进工作流的研究者，
可以跳过每章开头的科研基础部分，直接看 AI 工具如何切进具体环节。

这本书关心的问题不是「AI 能不能回答问题」，而是
*AI 能不能切进研究流程里的具体环节*——哪里真的省时间，哪里只是看起来很聪明。
所以全书按研究的完整生命周期组织：
选题 → 实验 → 数据与图表 → 写作 → 投稿 → 修回 → 发表。
每个阶段一章，每章都先讲清楚这个阶段本身是干什么的、做好的标准是什么，
然后再引入 AI 工具，最后以一个可以上手的练习收尾。

第一章会给出一张*全局地图*：把整个研究流程画成一条流水线，
标出每个环节上 AI 做什么、人做什么、哪些结果必须由人来验证。
后面的每一章都是对这张地图上一个格子的放大，
读者在任何一章里都能知道自己处在整个流程的哪个位置。

全书还有一条贯穿的主线：从第三章开始，读者选定一个自己的（小的）真实研究方向，
带着它走完全部章节——到投稿一章时，手里应该已经有一份可投的初稿。
每一章结束时我们都问同一个问题：
*AI 在这里到底帮我们省了什么，哪些东西仍然必须自己验证？*

#figure(
  image("figures/chapter-map.pdf", width: 100%),
  caption: [
    全书章节关系：第 1、2 章是全书基础，第 3–9 章沿研究生命周期推进；
    虚线为「修回 → 写作」循环，顶部括线为贯穿练习主线。
  ],
  numbering: none,
)

关于排版：本书使用 _typst_ 排版引擎@typst2024documentation，
可以很好地处理中英文混排；正文各章按主题拆分为独立文件，
由主文件统一引用，方便维护，也方便让 LLM 分章处理。

#pagebreak()

// Reset page numbering to Arabic numerals for main content
#set page(numbering: "1")
#counter(page).update(1)

// ============================================================================
// Content Sections - Include chapter files
// One chapter per research phase; split a chapter into a folder when it grows
// ============================================================================

#include "chapters/01-foundations.typ"
#include "chapters/02-setup.typ"
#include "chapters/03-find-problem.typ"
#include "chapters/04-experiments.typ"
#include "chapters/05-data-figures.typ"
#include "chapters/06-writing.typ"
#include "chapters/07-submit.typ"
#include "chapters/08-revision.typ"
#include "chapters/09-after-acceptance.typ"

#pagebreak()

// Bibliography
#bibliography(bibliography-file, style: "ieee")
