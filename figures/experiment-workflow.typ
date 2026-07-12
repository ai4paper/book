// Ch.4 experiment workflow: one-page brief -> writing-plans decomposition ->
// three parallel subagents (dashed container) -> human review & integrate ->
// one-click reproduction -> trusted evidence. An ikanban supervision bar
// (dashed) spans the parallel + review stages with dotted droppers.
// Grayscale hierarchy: evidence & plan darkest > chain boxes > containers.
#import "@preview/cetz:0.3.4"
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: ("New Computer Modern Sans", "Source Han Sans"), size: 9pt, fallback: true)

// Grayscale palette (print-friendly hierarchy)
#let fig-black = luma(0%)    // primary text
#let fig-dark  = luma(20%)   // borders, arrows
#let fig-num   = luma(38%)   // secondary / annotation text
#let fig-mid   = luma(50%)   // connectors
#let fig-cont  = luma(60%)   // dashed containers, droppers
#let fig-light = luma(85%)   // brief / evidence fill
#let fig-pale  = luma(95%)   // AI-box fill

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let hook = (end: ">", fill: fig-dark, scale: 0.7)
  let flow(a, b) = line(a, b, mark: hook, stroke: 0.85pt + fig-dark)

  // ---- node helper: two-line box centred at (x, y) ----------------------
  let node(name, x, y, main, sub, w: 1.05, fill: white, bw: 0.9pt) = {
    rect((x - w, y - 0.45), (x + w, y + 0.45),
      fill: fill, stroke: bw + fig-dark, radius: 1.5pt, name: name)
    content((x, y), align(center, stack(dir: ttb, spacing: 3.2pt,
      text(size: 8pt, fill: fig-black, weight: "medium", main),
      text(size: 6.5pt, fill: fig-num, sub),
    )))
  }

  // ================= 1. one-page brief (human input, solid) ==============
  node("brief", 0, 0, [一页纸任务书], [claim · baseline · 判据],
    w: 1.35, fill: fig-light, bw: 1.1pt)

  // ================= 2. plan decomposition (AI) ==========================
  node("plan", 2.95, 0, [writing-plans], [计划：小任务清单], fill: fig-pale)
  flow("brief.east", "plan.west")

  // ================= 3. parallel subagents (dashed container) ============
  rect((5.35, -2.0), (9.0, 1.75),
    stroke: (paint: fig-cont, thickness: 0.55pt, dash: "loosely-dashed"),
    radius: 2pt, name: "par")
  content((5.5, 1.52), anchor: "west",
    text(size: 7.5pt, fill: fig-dark, weight: "medium")[并行 subagent · 互不依赖])

  node("t1", 7.2,  0.9, [subagent A], [baseline 复现], w: 1.3, fill: fig-pale)
  node("t2", 7.2, -0.25, [subagent B], [消融实验], w: 1.3, fill: fig-pale)
  node("t3", 7.2, -1.4, [subagent C], [数据预处理], w: 1.3, fill: fig-pale)

  // fan-out / fan-in
  flow("plan.east", "t1.west")
  flow("plan.east", "t2.west")
  flow("plan.east", "t3.west")

  // ================= 4. human review & integrate =========================
  node("rev", 10.75, 0, [人 · review 整合], [逐段审 diff · 查冲突], w: 1.45, bw: 1.1pt)
  flow("t1.east", "rev.west")
  flow("t2.east", "rev.west")
  flow("t3.east", "rev.west")

  // ================= 5. reproduce -> evidence =============================
  node("rep", 13.7, 0, [一键复现], [重跑 · 数字一致], w: 1.2, bw: 1.1pt)
  flow("rev.east", "rep.west")
  rect((15.35, -0.5), (17.35, 0.5),
    fill: fig-light, stroke: 1.1pt + fig-black, radius: 2pt, name: "ev")
  content((16.35, 0), align(center, stack(dir: ttb, spacing: 3.2pt,
    text(size: 8pt, fill: fig-black, weight: "medium")[可信证据],
    text(size: 6.5pt, fill: fig-num)[支撑一条 claim],
  )))
  flow("rep.east", "ev.west")

  // ---- human gate under plan: 先过目再放行 ------------------------------
  content((2.95, -1.1),
    box(inset: (x: 4pt, y: 2.5pt), radius: 3pt,
      stroke: (paint: fig-cont, thickness: 0.5pt, dash: "loosely-dashed"),
      text(size: 7pt, fill: fig-num)[人先读计划，再放行]))
  line((2.95, -0.85), (2.95, -0.45),
    mark: hook, stroke: (paint: fig-cont, thickness: 0.6pt, dash: "dotted"))

  // ================= ikanban supervision bar (dashed, above) =============
  rect((5.35, 2.35), (12.4, 3.25),
    stroke: (paint: fig-cont, thickness: 0.55pt, dash: "loosely-dashed"),
    radius: 2pt, name: "kb")
  content((8.875, 2.8), align(center, stack(dir: ttb, spacing: 3pt,
    text(size: 8pt, fill: fig-black, weight: "medium")[ikanban 看板（本地或远程浏览器）],
    text(size: 6.5pt, fill: fig-num)[Home board · Task graph · Review flow · 权限审批],
  )))
  // dotted droppers: board watches the parallel container and the review box
  line((7.2, 2.35), (7.2, 1.75),
    stroke: (paint: fig-cont, thickness: 0.6pt, dash: "dotted"))
  line((10.75, 2.35), (10.75, 0.45),
    stroke: (paint: fig-cont, thickness: 0.6pt, dash: "dotted"))
})
