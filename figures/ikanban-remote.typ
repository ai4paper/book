// Ch.4 ikanban remote mode: a browser (hosted app, any device) drives an
// OpenCode server running on a remote workstation over HTTP; the server
// hosts multiple parallel agent sessions. Human actions ride the link:
// send prompts, approve permissions, review diffs.
// Grayscale hierarchy: serve box darkest > browser > agent sessions.
#import "@preview/cetz:0.3.4"
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: ("New Computer Modern Sans", "Source Han Sans"), size: 9pt, fallback: true)

// Grayscale palette (print-friendly hierarchy)
#let fig-black = luma(0%)    // primary text
#let fig-dark  = luma(20%)   // borders, arrows
#let fig-num   = luma(38%)   // secondary / annotation text
#let fig-mid   = luma(50%)   // agent borders, spokes
#let fig-cont  = luma(60%)   // dashed host container
#let fig-light = luma(85%)   // serve fill
#let fig-pale  = luma(95%)   // browser fill

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let hook = (end: ">", start: ">", fill: fig-dark, scale: 0.7)

  // ================= left: browser (hosted app) ==========================
  rect((-1.45, 0.15), (1.45, 1.35),
    fill: fig-pale, stroke: 0.9pt + fig-dark, radius: 2pt, name: "web")
  content((0, 0.75), align(center, stack(dir: ttb, spacing: 3.2pt,
    text(size: 8pt, fill: fig-black, weight: "medium")[浏览器 · ikanban],
    text(size: 6pt, fill: fig-num)[`isomoes.github.io/ikanban`],
  )))
  content((0, -0.15), text(size: 7pt, fill: fig-num)[笔记本 / 任何设备])

  // ================= right: remote host (dashed container) ==============
  rect((4.5, -2.05), (10.1, 1.75),
    stroke: (paint: fig-cont, thickness: 0.55pt, dash: "loosely-dashed"),
    radius: 2pt, name: "host")
  content((4.65, 1.52), anchor: "west",
    text(size: 7.5pt, fill: fig-dark, weight: "medium")[远程工作站 · GPU 服务器 / WSL / SSH])

  // opencode serve (darkest, solid)
  rect((5.3, 0.35), (9.3, 1.15),
    fill: fig-light, stroke: 1.1pt + fig-black, radius: 2pt, name: "serve")
  content((7.3, 0.75), align(center, stack(dir: ttb, spacing: 3pt,
    text(size: 8pt, fill: fig-black, weight: "medium")[opencode serve],
    text(size: 6pt, fill: fig-num)[`--port <PORT> --cors ...`],
  )))

  // parallel agent sessions under the server
  let agent(name, x, label) = {
    rect((x - 0.72, -1.5), (x + 0.72, -0.75),
      fill: white, stroke: 0.6pt + fig-mid, radius: 1.5pt, name: name)
    content((x, -1.125), text(size: 7pt, fill: fig-dark, label))
  }
  agent("a1", 5.85, [agent A])
  agent("a2", 7.3,  [agent B])
  agent("a3", 8.75, [agent C])
  for x in (5.85, 7.3, 8.75) {
    line((7.3, 0.35), (x, -0.75), stroke: 0.6pt + fig-mid)
  }
  content((7.3, -1.76),
    text(size: 6.5pt, fill: fig-num)[并行推进实验的 agent session])

  // ================= HTTP link (two-way) =================================
  line((1.45, 0.75), (5.3, 0.75), mark: hook, stroke: 0.85pt + fig-dark)
  content((3.375, 1.0),
    text(size: 7pt, fill: fig-dark, weight: "medium")[HTTP])
  content((3.375, 0.42),
    box(fill: white, inset: (x: 2pt, y: 1.5pt),
      text(size: 6.5pt, fill: fig-num)[发提示 · 审批权限 · review diff]))
})
