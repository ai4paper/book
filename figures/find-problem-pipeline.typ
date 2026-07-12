// Ch.3 topic-finding pipeline: five literature sources feed apaper-mcp;
// step 1 (AI searches latest work -> human filters top-5) and step 2
// (AI reads PDFs for gap analysis -> human verifies against originals)
// alternate AI/human boxes, ending in the research-gap report.
// Grayscale hierarchy: mcp hub & report darkest > chain boxes > sources.
#import "@preview/cetz:0.3.4"
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: ("New Computer Modern Sans", "Source Han Sans"), size: 9pt, fallback: true)

// Grayscale palette (print-friendly hierarchy)
#let fig-black = luma(0%)    // primary text
#let fig-dark  = luma(20%)   // borders, arrows
#let fig-num   = luma(38%)   // secondary / annotation text
#let fig-mid   = luma(50%)   // source borders, connectors
#let fig-cont  = luma(60%)   // dashed step containers
#let fig-light = luma(85%)   // hub / report fill
#let fig-pale  = luma(95%)   // AI-box fill

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let hook = (end: ">", fill: fig-dark, scale: 0.7)
  let flow(a, b) = line(a, b, mark: hook, stroke: 0.85pt + fig-dark)

  // ---- chain-box helper: two-line node --------------------------------
  let node(name, x, main, sub, fill: white, bw: 0.9pt) = {
    rect((x - 1.05, -0.45), (x + 1.05, 0.45),
      fill: fill, stroke: bw + fig-dark, radius: 1.5pt, name: name)
    content((x, 0), align(center, stack(dir: ttb, spacing: 3.2pt,
      text(size: 8pt, fill: fig-black, weight: "medium", main),
      text(size: 6.5pt, fill: fig-num, sub),
    )))
  }

  // ================= five literature sources (left, lightest) ===========
  content((0, 2.12), text(size: 7.5pt, fill: fig-num, weight: "medium")[五个文献来源])
  let src(name, y, label) = {
    rect((-1.1, y - 0.26), (1.1, y + 0.26),
      fill: white, stroke: 0.6pt + fig-mid, radius: 1.5pt, name: name)
    content((0, y), text(size: 7.5pt, fill: fig-dark, label))
  }
  src("s0",  1.6, [arXiv])
  src("s1",  0.8, [DBLP])
  src("s2",  0.0, [Google Scholar])
  src("s3", -0.8, [IACR ePrint])
  src("s4", -1.6, [CNKI 知网])

  // ================= apaper-mcp hub (dark, solid) ========================
  rect((2.05, -0.5), (4.05, 0.5),
    fill: fig-light, stroke: 1.1pt + fig-black, radius: 2pt, name: "mcp")
  content((3.05, 0), align(center, stack(dir: ttb, spacing: 3.2pt,
    text(size: 8pt, fill: fig-black, weight: "medium")[apaper-mcp],
    text(size: 6.5pt, fill: fig-num)[统一检索 · 下载],
  )))

  // socket connectors: sources -> plug dot -> hub west edge
  let socket(x, y) = { circle((x, y), radius: 0.05, fill: fig-mid, stroke: none) }
  for y in (1.6, 0.8, 0.0, -0.8, -1.6) {
    line((1.1, y), (1.8, 0), stroke: 0.6pt + fig-mid)
    socket(1.1, y)
  }
  circle((1.8, 0), radius: 0.055, fill: fig-dark, stroke: none)
  line((1.8, 0), (2.05, 0), stroke: 0.7pt + fig-mid)

  // ================= step containers (dashed) ============================
  rect((4.2, -0.8), (9.15, 1.15),
    stroke: (paint: fig-cont, thickness: 0.55pt, dash: "loosely-dashed"),
    radius: 2pt)
  content((4.35, 0.93), anchor: "west",
    text(size: 7.5pt, fill: fig-dark, weight: "medium")[第一步 · 跟踪最新工作])
  rect((9.45, -0.8), (14.4, 1.15),
    stroke: (paint: fig-cont, thickness: 0.55pt, dash: "loosely-dashed"),
    radius: 2pt)
  content((9.6, 0.93), anchor: "west",
    text(size: 7.5pt, fill: fig-dark, weight: "medium")[第二步 · 提取剩余空白])

  // ================= alternating AI / human chain ========================
  node("a1",  5.55, [AI · 检索],   [最新工作清单], fill: fig-pale)
  node("h1",  7.85, [人 · 筛选],   [最相关 5 篇], bw: 1.1pt)
  node("a2", 10.8,  [AI · 读 PDF], [逐篇空白分析], fill: fig-pale)
  node("h2", 13.1,  [人 · 核对],   [每条空白回原文], bw: 1.1pt)

  // ================= research-gap report (final, darkest) ===============
  rect((14.75, -0.5), (17.35, 0.5),
    fill: fig-light, stroke: 1.1pt + fig-black, radius: 2pt, name: "rep")
  content((16.05, 0), align(center, stack(dir: ttb, spacing: 3.2pt,
    text(size: 8pt, fill: fig-black, weight: "medium")[研究空白报告],
    text(size: 6.5pt, fill: fig-num)[过三关 → 选定切入点],
  )))

  // ---- chain arrows -----------------------------------------------------
  flow("mcp.east", "a1.west")
  flow("a1.east",  "h1.west")
  flow("h1.east",  "a2.west")
  flow("a2.east",  "h2.west")
  flow("h2.east",  "rep.west")

  // ================= bottom legend ========================================
  rect((6.6, -1.62), (6.94, -1.4), fill: fig-pale, stroke: 0.6pt + fig-dark, radius: 1pt)
  content((7.06, -1.51), anchor: "west",
    text(size: 7pt, fill: fig-num)[AI · 加法（生成候选）])
  rect((10.1, -1.62), (10.44, -1.4), fill: white, stroke: 1.1pt + fig-dark, radius: 1pt)
  content((10.56, -1.51), anchor: "west",
    text(size: 7pt, fill: fig-num)[人 · 减法（筛选与核对）])
})
