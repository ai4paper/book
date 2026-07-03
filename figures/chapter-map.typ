// Chapter relationship map for the AI4Paper preface (前言).
// Single-row lifecycle pipeline (Ch3–9) grouped into two dashed phase
// containers (研究阶段 / 发表阶段), resting on a spanning foundation band
// (Ch1 + Ch2, 全书基础) tied in by support arrows; dashed revise-resubmit
// loop Ch8→Ch6 above; subtle running-example over-bracket spanning Ch3–Ch7.
// Grayscale hierarchy: pipeline > containers/loop > foundation > bracket.

#import "@preview/cetz:0.3.4"

#set page(width: auto, height: auto, margin: 2mm)
#set text(font: ("New Computer Modern Sans", "Source Han Sans"), size: 9pt, fallback: true)

// Grayscale palette (print-friendly hierarchy)
#let fig-black = luma(0%)    // primary text
#let fig-dark  = luma(20%)   // pipeline borders + arrows, feedback loop
#let fig-num   = luma(38%)   // chapter-number captions, annotations
#let fig-mid   = luma(45%)   // support arrows
#let fig-cont  = luma(60%)   // phase containers (grouping dash, lighter than loop)
#let fig-soft  = luma(55%)   // running-example bracket line
#let fig-light = luma(85%)   // pipeline block fill
#let fig-pale  = luma(95%)   // foundation band fill

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  // ---- geometry parameters -------------------------------------------
  let w  = 1.80   // pipeline block width
  let h  = 0.98   // pipeline block height
  let g  = 0.32   // gap between blocks inside a container
  let p  = 0.08   // container side padding
  let G  = 0.36   // gap between the two containers

  // pipeline block centers (y = 0)
  let x3 = p + w/2
  let x4 = x3 + w + g
  let x5 = x4 + w + g
  let x6 = x5 + w + g
  let c1l = 0.0
  let c1r = x6 + w/2 + p
  let c2l = c1r + G
  let x7 = c2l + p + w/2
  let x8 = x7 + w + g
  let x9 = x8 + w + g
  let c2r = x9 + w/2 + p

  let blk-top = h/2
  let cont-top = 1.06
  let cont-bot = -0.70
  let fb-y = 1.38                     // feedback arc height
  let br-y = 1.72                     // running-example bracket height
  let band-top = -1.04
  let band-bot = -1.98
  let found-y = (band-top + band-bot) / 2

  // ---- helpers ---------------------------------------------------------
  let chapter(name, x, n, label) = {
    rect((x - w/2, -h/2), (x + w/2, h/2),
      fill: fig-light, stroke: 0.9pt + fig-dark, radius: 1.5pt, name: name)
    content((x, 0), align(center, stack(dir: ttb, spacing: 3.2pt,
      text(size: 7pt, fill: fig-num)[第 #n 章],
      text(size: 9pt, fill: fig-black)[#label],
    )))
  }

  let foundation(name, xc, bw, n, label) = {
    rect((xc - bw/2, found-y - 0.30), (xc + bw/2, found-y + 0.30),
      fill: white, stroke: 0.6pt + fig-mid, radius: 1.5pt, name: name)
    content((xc, found-y),
      text(size: 7pt, fill: fig-num)[第 #n 章　] + text(size: 9pt, fill: fig-dark)[#label])
  }

  let flow(from, to) = line(from, to,
    mark: (end: ">", fill: fig-dark, scale: 0.7),
    stroke: 0.9pt + fig-dark)

  // ---- foundation band (bottom layer) ----------------------------------
  rect((c1l, band-bot), (c2r, band-top),
    fill: fig-pale, stroke: 0.5pt + fig-soft, radius: 2pt, name: "band")
  content((0.95, found-y), text(size: 8pt, fill: fig-num, weight: "medium")[全书基础])
  foundation("f1", 4.95, 6.0, 1, [基础：研究 + LLM · 全局地图])
  foundation("f2", 11.75, 6.0, 2, [环境搭建：agent 工作环境])

  // support arrows: foundation band -> both phase containers
  for sx in (2.1, 6.3, 10.3, 13.5) {
    line((sx, band-top), (sx, cont-bot),
      mark: (end: ">", fill: fig-mid, scale: 0.6),
      stroke: 0.7pt + fig-mid)
  }
  content((2.24, (band-top + cont-bot) / 2), anchor: "west",
    text(size: 7pt, fill: fig-num)[支撑第 3–9 章])

  // ---- phase containers (loose light dash = grouping) -------------------
  rect((c1l, cont-bot), (c1r, cont-top),
    stroke: (paint: fig-cont, thickness: 0.55pt, dash: "loosely-dashed"), radius: 2pt,
    name: "phase1")
  content((c1l + 0.22, 0.80), anchor: "west",
    text(size: 8pt, fill: fig-dark, weight: "medium")[研究阶段])

  rect((c2l, cont-bot), (c2r, cont-top),
    stroke: (paint: fig-cont, thickness: 0.55pt, dash: "loosely-dashed"), radius: 2pt,
    name: "phase2")
  content((c2l + 0.22, 0.80), anchor: "west",
    text(size: 8pt, fill: fig-dark, weight: "medium")[发表阶段])

  // white breaks in the container tops where the feedback verticals cross
  line((x6 - 0.14, cont-top), (x6 + 0.14, cont-top), stroke: 2.5pt + white)
  line((x8 - 0.14, cont-top), (x8 + 0.14, cont-top), stroke: 2.5pt + white)

  // ---- pipeline blocks ---------------------------------------------------
  chapter("ch3", x3, 3, [选题])
  chapter("ch4", x4, 4, [实验])
  chapter("ch5", x5, 5, [数据与图表])
  chapter("ch6", x6, 6, [写作])
  chapter("ch7", x7, 7, [投稿])
  chapter("ch8", x8, 8, [修回])
  chapter("ch9", x9, 9, [发表之后])

  // ---- lifecycle arrows ---------------------------------------------------
  flow("ch3.east", "ch4.west")
  flow("ch4.east", "ch5.west")
  flow("ch5.east", "ch6.west")
  flow("ch6.east", "ch7.west")
  flow("ch7.east", "ch8.west")
  flow("ch8.east", "ch9.west")

  // ---- revise-resubmit feedback loop (short dark dash = flow) --------------
  line((x8, blk-top - 0.06), (x8, fb-y), (x6, fb-y), "ch6.north",
    mark: (end: ">", fill: fig-dark, scale: 0.7),
    stroke: (paint: fig-dark, thickness: 0.8pt, dash: "densely-dashed"))
  content(((x6 + x8)/2 - 0.62, fb-y),
    box(fill: white, inset: (x: 3pt, y: 2pt), text(size: 8pt, fill: fig-black)[按审稿意见修改]))

  // ---- running-example thread (subtle over-bracket, Ch3–Ch7) ----------------
  let brl = x3 - w/2 + 0.02
  let brr = x7 + w/2 - 0.02
  line((brl, br-y - 0.12), (brl, br-y), (brr, br-y), (brr, br-y - 0.12),
    stroke: 0.6pt + fig-soft)
  content(((brl + brr)/2, br-y + 0.24),
    text(size: 8pt, fill: luma(40%))[贯穿练习：自己的研究方向 #sym.arrow.r 可投初稿])
})
