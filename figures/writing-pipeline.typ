// Ch.6 writing workflow: gap report + experiment figures enter; the human
// builds the outline and drafts the technical content; AI aligns style
// (writing skill); the human reviews the diff line by line, rejected
// edits loop back; typesetting + reference checks yield the submittable
// draft. AI boxes pale, human boxes bold-bordered (same legend as ch.3/4).
#import "@preview/cetz:0.3.4"
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: ("New Computer Modern Sans", "Source Han Sans"), size: 9pt, fallback: true)

// Grayscale palette (print-friendly hierarchy)
#let fig-black = luma(0%)    // primary text
#let fig-dark  = luma(20%)   // borders, arrows
#let fig-num   = luma(38%)   // secondary / annotation text
#let fig-mid   = luma(50%)   // input border, connectors
#let fig-light = luma(85%)   // final-draft fill
#let fig-pale  = luma(95%)   // AI-box fill

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let hook = (end: ">", fill: fig-dark, scale: 0.7)
  let flow(a, b) = line(a, b, mark: hook, stroke: 0.85pt + fig-dark)

  // ---- two-line node helper -------------------------------------------
  let node(name, x, hw, main, sub, fill: white, bw: 0.9pt, bc: fig-dark) = {
    rect((x - hw, -0.45), (x + hw, 0.45),
      fill: fill, stroke: bw + bc, radius: 1.5pt, name: name)
    content((x, 0), align(center, stack(dir: ttb, spacing: 3.2pt,
      text(size: 8pt, fill: fig-black, weight: "medium", main),
      text(size: 6.5pt, fill: fig-num, sub),
    )))
  }

  // ================= chain ==============================================
  node("mat",    0,    1.15, [输入材料],     [空白报告 · 实验图表],
    bw: 0.6pt, bc: fig-mid)
  node("skel",   2.8,  1.05, [人 · 搭骨架],  [每段一句话题句], bw: 1.1pt)
  node("draft",  5.35, 1.05, [人 · 写草稿],  [技术内容自己写], bw: 1.1pt)
  node("align",  8.0,  1.15, [AI · 风格对齐], [writing skill], fill: fig-pale)
  node("review", 10.75, 1.05, [人 · review], [逐行接受 / 拒绝], bw: 1.1pt)
  node("final", 13.65, 1.25, [可投初稿],     [排版 · 文献核对],
    fill: fig-light, bw: 1.1pt, bc: fig-black)

  flow("mat.east",    "skel.west")
  flow("skel.east",   "draft.west")
  flow("draft.east",  "align.west")
  flow("align.east",  "review.west")
  flow("review.east", "final.west")

  // ================= reject loop ========================================
  line("review.south", (10.75, -1.15), (8.0, -1.15),
    stroke: 0.85pt + fig-dark)
  line((8.0, -1.15), "align.south", mark: hook, stroke: 0.85pt + fig-dark)
  content((9.38, -1.42),
    text(size: 7pt, fill: fig-num)[拒绝的修改退回重改])

  // ================= bottom legend ======================================
  rect((2.9, -2.12), (3.24, -1.9), fill: fig-pale, stroke: 0.6pt + fig-dark, radius: 1pt)
  content((3.36, -2.01), anchor: "west",
    text(size: 7pt, fill: fig-num)[AI · 加法（改写候选）])
  rect((6.7, -2.12), (7.04, -1.9), fill: white, stroke: 1.1pt + fig-dark, radius: 1pt)
  content((7.16, -2.01), anchor: "west",
    text(size: 7pt, fill: fig-num)[人 · 减法（结构与把关）])
})
