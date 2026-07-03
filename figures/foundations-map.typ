// Whole-book global map: a swimlane across the 7-phase research lifecycle.
// Top strip = 7 phases linked by lifecycle arrows (+ dashed 修回->写作 revise loop);
// three lanes = AI·加法 (generate) / 人·判断 (select) / 人·验证 (gate) — the last
// carries a heavier gate border. Per column: AI adds, humans judge & verify.
// Grayscale hierarchy: phase strip & gate line darkest > headers > cells > dividers.

#import "@preview/cetz:0.3.4"

#set page(width: auto, height: auto, margin: 2mm)
#set text(font: ("New Computer Modern Sans", "Source Han Sans"), size: 9pt, fallback: true)

// Grayscale palette (print-friendly hierarchy)
#let fig-black = luma(0%)    // primary text
#let fig-dark  = luma(20%)   // borders, arrows, gate line
#let fig-num   = luma(38%)   // secondary / annotation text
#let fig-mid   = luma(50%)   // header/body separator
#let fig-cont  = luma(60%)   // interior grid dividers, droppers
#let fig-soft  = luma(55%)   // subtle
#let fig-light = luma(85%)   // header + phase-box fill
#let fig-pale  = luma(95%)   // AI lane band tint

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  // ---- geometry -------------------------------------------------------
  let lane-w = 2.10          // left lane-header column width
  let col-w  = 2.30          // each phase column width
  let pbw    = 1.70          // phase-header box width
  let cellw  = 2.02          // wrap width for cell text (cm)
  let R      = lane-w + 7 * col-w        // right edge
  let pcol(i) = lane-w + i * col-w + col-w / 2   // column center x

  let strip-cy = 0.0
  let strip-h  = 0.25        // phase-box half height
  let fb-y     = 0.90        // feedback loop height
  let leg-y    = 0.62        // legend baseline

  let grid-top = -0.55
  let lh       = 1.12        // lane height
  let l1t = grid-top
  let l1b = grid-top - lh
  let l2t = l1b
  let l2b = l1b - lh
  let l3t = l2b
  let l3b = l2b - lh
  let grid-bot = l3b
  let cy1 = (l1t + l1b) / 2
  let cy2 = (l2t + l2b) / 2
  let cy3 = (l3t + l3b) / 2

  // ---- helpers --------------------------------------------------------
  let celltext(body) = box(width: cellw * 1cm, {
    set par(leading: 0.42em)
    set text(size: 7pt, fill: fig-black)
    align(center, body)
  })

  let flow(from, to) = line(from, to,
    mark: (end: ">", fill: fig-dark, scale: 0.7),
    stroke: 0.85pt + fig-dark)

  // ---- 1. lane bands (cell area) --------------------------------------
  rect((lane-w, l1b), (R, l1t), fill: fig-pale, stroke: none)   // AI lane tint
  // lanes 2 & 3 stay white (page default)

  // ---- 2. lane-header column blocks (stacked) -------------------------
  for (yt, yb) in ((l1t, l1b), (l2t, l2b), (l3t, l3b)) {
    rect((0, yb), (lane-w, yt), fill: fig-light, stroke: none)
  }

  // ---- 3. interior column dividers ------------------------------------
  for k in range(1, 7) {
    let x = lane-w + k * col-w
    line((x, grid-bot), (x, grid-top), stroke: 0.5pt + fig-cont)
  }
  // header | body separator (slightly stronger)
  line((lane-w, grid-bot), (lane-w, grid-top), stroke: 0.6pt + fig-mid)

  // ---- 4. horizontal lane dividers ------------------------------------
  line((0, l1b), (R, l1b), stroke: 0.5pt + fig-cont)           // AI | 人·判断
  // gate line (lane 3 top) — heavier, signals the verification gate
  line((0, l3t), (R, l3t), stroke: 1.1pt + fig-dark)

  // ---- 5. outer border ------------------------------------------------
  rect((0, grid-bot), (R, grid-top), fill: none,
    stroke: 0.7pt + fig-dark, radius: 2pt)

  // ---- 6. cell content ------------------------------------------------
  let ai = (
    [检索最新工作，\ 提取空白],
    [plan/implement/\ verify 拆分并行],
    [生成可重跑的\ 处理/绘图脚本],
    [句子风格/结构\ 对齐目标期刊],
    [候选期刊、合规\ 检查、模拟审稿],
    [解析审稿意见，\ 起草逐条回复],
    [终稿校对，生成\ slides 等衍生],
  )
  let hu = (
    [选定问题],
    [设计实验，\ 关键节点审查],
    [定每张图的结论],
    [技术内容与论点],
    [最终选刊],
    [科学层面的答辩],
    [决定传播口径],
  )
  let ve = (
    [每条空白\ 回原文核对],
    [review 每段\ diff；可复现],
    [图中数字与\ 原始数据一致],
    [语义不变；\ 每条引用真实],
    [到官网核对\ scope/状态/政策],
    [承诺的修改\ 都已落地],
    [衍生内容\ 不夸大结论],
  )
  for i in range(7) {
    content((pcol(i), cy1), celltext(ai.at(i)))
    content((pcol(i), cy2), celltext(hu.at(i)))
    content((pcol(i), cy3), celltext(ve.at(i)))
  }

  // ---- 7. lane-header labels ------------------------------------------
  let lanehdr(cy, lab, sub) = content((lane-w / 2, cy), align(center,
    stack(dir: ttb, spacing: 3.5pt,
      text(size: 8.5pt, fill: fig-black, weight: "medium", lab),
      text(size: 6.5pt, fill: fig-num, sub),
    )))
  lanehdr(cy1, [AI · 加法], [检索·生成·起草])
  lanehdr(cy2, [人 · 判断], [筛选·决定])
  lanehdr(cy3, [人 · 验证], [把关])
  // gate check-mark cue above the 验证 header
  line((lane-w/2 - 0.10, l3t - 0.19), (lane-w/2 - 0.03, l3t - 0.26),
       (lane-w/2 + 0.12, l3t - 0.08),
    stroke: (paint: fig-dark, thickness: 1.2pt, cap: "round"))

  // ---- 8. phase-header strip ------------------------------------------
  let names = ([选题], [实验], [数据与图表], [写作], [投稿], [修回], [发表])
  for i in range(7) {
    let x = pcol(i)
    rect((x - pbw/2, strip-cy - strip-h), (x + pbw/2, strip-cy + strip-h),
      fill: fig-light, stroke: 0.7pt + fig-dark, radius: 2pt, name: "p" + str(i))
    content((x, strip-cy), text(size: 8.5pt, fill: fig-black, weight: "medium", names.at(i)))
    // subtle dropper tying header to its column
    line((x, strip-cy - strip-h), (x, grid-top), stroke: 0.4pt + fig-cont)
  }

  // ---- 9. lifecycle arrows across the strip ----------------------------
  for i in range(6) {
    flow("p" + str(i) + ".east", "p" + str(i + 1) + ".west")
  }

  // ---- 10. revise -> writing feedback loop (dashed, above strip) --------
  line((pcol(5), strip-cy + strip-h), (pcol(5), fb-y),
       (pcol(3), fb-y), (pcol(3), strip-cy + strip-h),
    mark: (end: ">", fill: fig-dark, scale: 0.7),
    stroke: (paint: fig-dark, thickness: 0.8pt, dash: "densely-dashed"))
  content((pcol(4), fb-y),
    box(fill: white, inset: (x: 3pt, y: 2pt),
      text(size: 7.5pt, fill: fig-black)[按审稿意见修改]))

  // ---- 11. per-cell vertical-flow legend (top-left key) -----------------
  content((0.08, leg-y), anchor: "west",
    box(inset: (x: 5pt, y: 2.5pt), radius: 3pt,
      stroke: (paint: fig-cont, thickness: 0.5pt, dash: "loosely-dashed"),
      text(size: 7pt, fill: fig-num)[每一格 #sym.arrow.b AI 生成 #sym.arrow.r 人筛选 #sym.arrow.r 人验证]))
})
