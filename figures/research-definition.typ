// Definition matrix for "研究 = 新问题 + 证据": a 2x2 quadrant over two axes,
// 问题 (旧→新, horizontal) and 证据 (无→有, vertical). Four cells name the
// result of each combination; the 新问题×有证据 cell (研究) is the hero —
// darkest fill, heavier border, bold — while 旧×无 (闲谈) is drawn faintest.
// Grayscale hierarchy: 研究 cell > other cells > axis arrows/labels.

#import "@preview/cetz:0.3.4"

#set page(width: auto, height: auto, margin: 2mm)
#set text(font: ("New Computer Modern Sans", "Source Han Sans"), size: 9pt, fallback: true)

// Grayscale palette (print-friendly hierarchy)
#let fig-black = luma(0%)    // primary text
#let fig-dark  = luma(20%)   // cell borders, hero border
#let fig-num   = luma(38%)   // axis + secondary annotation
#let fig-mid   = luma(50%)   // axis arrows, faint-cell text
#let fig-cont  = luma(60%)   // dashed grouping (unused here)
#let fig-soft  = luma(55%)   // subtle marks
#let fig-light = luma(85%)   // hero cell fill
#let fig-pale  = luma(95%)   // neighbour cell fill

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  // ---- geometry ---------------------------------------------------------
  let w = 3.10          // cell width
  let h = 1.55          // cell height
  let gp = 0.16         // gap between cells
  let lx = 0.0          // left column centre x
  let rx = w + gp       // right column centre x
  let by = 0.0          // bottom row centre y
  let ty = h + gp       // top row centre y

  let gl = lx - w/2     // grid left edge
  let gr = rx + w/2     // grid right edge
  let gb = by - h/2     // grid bottom edge
  let gt = ty + h/2     // grid top edge

  // ---- cell helper ------------------------------------------------------
  let cell(x, y, fill, stroke, body) = {
    rect((x - w/2, y - h/2), (x + w/2, y + h/2),
      fill: fill, stroke: stroke, radius: 2pt)
    content((x, y), body)
  }

  // bottom-left (旧问题, 无证据): 闲谈 — faintest quadrant
  cell(lx, by, white, 0.6pt + fig-mid,
    text(size: 9pt, fill: fig-mid)[闲谈])

  // bottom-right (新问题, 无证据): 观点
  cell(rx, by, fig-pale, 0.9pt + fig-dark,
    align(center, stack(dir: ttb, spacing: 3.4pt,
      text(size: 9pt, fill: fig-black)[观点],
      text(size: 7pt, fill: fig-num)[有主张，没证明],
    )))

  // top-left (旧问题, 有证据): 练习 / 作业
  cell(lx, ty, fig-pale, 0.9pt + fig-dark,
    align(center, stack(dir: ttb, spacing: 3.4pt,
      text(size: 9pt, fill: fig-black)[练习 / 作业],
      text(size: 7pt, fill: fig-num)[（如 B+ 树作业）],
    )))

  // top-right (新问题, 有证据): 研究 — HERO
  cell(rx, ty, fig-light, 1.2pt + fig-black,
    align(center, stack(dir: ttb, spacing: 3.6pt,
      text(size: 10pt, fill: fig-black, weight: "medium")[研究],
      text(size: 7pt, fill: fig-num)[novelty + evidence],
    )))
  // hero mark
  content((rx + w/2 - 0.26, ty + h/2 - 0.24),
    text(size: 9pt, fill: fig-dark, weight: "medium")[#sym.checkmark])

  // ---- Y axis (证据, 无→有) ---------------------------------------------
  let ax = gl - 0.30
  line((ax, gb), (ax, gt),
    mark: (end: ">", fill: fig-mid, scale: 0.6),
    stroke: 0.7pt + fig-mid)
  content((ax - 0.14, by), anchor: "east", text(size: 7pt, fill: fig-num)[无])
  content((ax - 0.14, ty), anchor: "east", text(size: 7pt, fill: fig-num)[有])
  content((ax - 0.52, (gb + gt)/2), anchor: "center",
    text(size: 8pt, fill: fig-num, weight: "medium")[证#linebreak()据])

  // ---- X axis (问题, 旧→新) ---------------------------------------------
  let ay = gb - 0.30
  line((gl, ay), (gr, ay),
    mark: (end: ">", fill: fig-mid, scale: 0.6),
    stroke: 0.7pt + fig-mid)
  content((lx, ay - 0.28), text(size: 7pt, fill: fig-num)[旧（已被回答）])
  content((rx, ay - 0.28), text(size: 7pt, fill: fig-num)[新（还没人回答）])
  content(((gl + gr)/2, ay - 0.70),
    text(size: 8pt, fill: fig-num, weight: "medium")[问题])
})
