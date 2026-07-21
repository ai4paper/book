// Ch.5 figure-generation loop: a structured prompt drives AI code
// generation; render -> human evaluate; failing issues are written back
// into the prompt (new constraints / anti-patterns) and the loop repeats
// until the figure is camera-ready. Prompt & final figure darkest;
// AI boxes pale, human boxes bold-bordered (same legend as ch.3/4).
#import "@preview/cetz:0.3.4"
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: ("New Computer Modern Sans", "Source Han Sans"), size: 9pt, fallback: true)

// Grayscale palette (print-friendly hierarchy)
#let fig-black = luma(0%)    // primary text
#let fig-dark  = luma(20%)   // borders, arrows
#let fig-num   = luma(38%)   // secondary / annotation text
#let fig-mid   = luma(50%)   // entry border, connectors
#let fig-light = luma(85%)   // prompt / final fill
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
  rect((-0.9, -0.26), (0.9, 0.26),
    fill: white, stroke: 0.6pt + fig-mid, radius: 1.5pt, name: "spec")
  content((0, 0), text(size: 7.5pt, fill: fig-dark)[构思 + 数据])

  node("prompt", 2.65, 1.25, [结构化提示], [约束 · 风格 · 反模式],
    fill: fig-light, bw: 1.1pt, bc: fig-black)
  node("gen",    5.5,  1.05, [AI · 生成], [绘图代码], fill: fig-pale)
  node("render", 8.05, 1.0,  [渲染],      [编译 → 预览])
  node("eval",  10.65, 1.05, [人 · 评估], [对照好图标准], bw: 1.1pt)
  node("final", 13.75, 1.3,  [camera-ready 图], [图源 + PDF],
    fill: fig-light, bw: 1.1pt, bc: fig-black)

  flow("spec.east",   "prompt.west")
  flow("prompt.east", "gen.west")
  flow("gen.east",    "render.west")
  flow("render.east", "eval.west")
  flow("eval.east",   "final.west")
  content((12.05, 0.22), text(size: 7pt, fill: fig-num)[达标])

  // ================= feedback loop ======================================
  line("eval.south", (10.65, -1.3), (2.65, -1.3),
    stroke: 0.85pt + fig-dark)
  line((2.65, -1.3), "prompt.south", mark: hook, stroke: 0.85pt + fig-dark)
  content((6.65, -1.08),
    text(size: 7pt, fill: fig-num)[不达标：把问题写回提示（新约束 / 反模式）])

  // ================= bottom legend ======================================
  rect((4.4, -2.12), (4.74, -1.9), fill: fig-pale, stroke: 0.6pt + fig-dark, radius: 1pt)
  content((4.86, -2.01), anchor: "west",
    text(size: 7pt, fill: fig-num)[AI · 加法（生成候选）])
  rect((8.2, -2.12), (8.54, -1.9), fill: white, stroke: 1.1pt + fig-dark, radius: 1pt)
  content((8.66, -2.01), anchor: "west",
    text(size: 7pt, fill: fig-num)[人 · 减法（评估与把关）])
})
