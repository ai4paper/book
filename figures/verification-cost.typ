// Verification-cost heuristic: a horizontal 易验证→难验证 spectrum showing where
// AI truly saves time (left: easy-to-verify outputs, machine-checkable chips) vs
// where it is dangerous (right: hard-to-verify judgment calls). A mid divider
// splits 机器可自动验证 from 只能靠人判断; a bottom principle line anchors it.
// Grayscale hierarchy: danger-zone chips + label darkest > left chips > divider/axis.

#import "@preview/cetz:0.3.4"

#set page(width: auto, height: auto, margin: 2mm)
#set text(font: ("New Computer Modern Sans", "Source Han Sans"), size: 9pt, fallback: true)

// Grayscale palette (print-friendly hierarchy)
#let fig-black = luma(0%)    // primary text, principle line
#let fig-dark  = luma(20%)   // axis, arrows, danger-zone chip borders + 危险区
#let fig-num   = luma(38%)   // secondary text, verify-method annotations
#let fig-mid   = luma(50%)   // left chip borders
#let fig-cont  = luma(60%)   // dashed mid divider
#let fig-light = luma(85%)   // left (easy) chip fill
#let fig-pale  = luma(95%)   // right-region wash

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  // ---- geometry ----------------------------------------------------------
  let w = 2.9    // uniform chip width
  let h = 0.95   // uniform chip height

  let colA = 1.55
  let colB = 4.55
  let rowT = 2.45
  let rowB = 1.15

  let rxA = 8.60          // right chip centers
  let rxB = 11.60
  let ry  = 1.80

  let divx = 6.55         // mid divider x
  let axy  = -0.55        // axis y
  let ax0  = -0.10        // axis left
  let ax1  = 13.20        // axis right

  // ---- danger-region subtle wash (bottom layer) --------------------------
  rect((divx + 0.20, -0.28), (13.15, 3.02),
    fill: fig-pale, stroke: none, radius: 2pt)

  // ---- mid divider (loose dash grouping) ---------------------------------
  line((divx, -0.35), (divx, 3.05),
    stroke: (paint: fig-cont, thickness: 0.55pt, dash: "loosely-dashed"))

  // ---- consequence labels (top) ------------------------------------------
  content((3.05, 3.28), text(size: 9pt, fill: fig-num)[AI 真正省时间])
  content((10.10, 3.28), text(size: 9pt, fill: fig-dark, weight: "medium")[危险区])

  // ---- left (易验证) chips: machine-checkable ----------------------------
  let lchip(x, y, prod, meth) = {
    rect((x - w/2, y - h/2), (x + w/2, y + h/2),
      fill: fig-light, stroke: 0.7pt + fig-mid, radius: 2pt)
    content((x, y), text(size: 8pt)[#text(fill: fig-black, weight: "medium")[#prod] #text(fill: fig-num)[#sym.arrow.r #meth]])
  }
  lchip(colA, rowT, [代码], [跑测试])
  lchip(colB, rowT, [引用], [查文献库])
  lchip(colA, rowB, [格式], [编译检查])
  lchip(colB, rowB, [改写], [逐句对读])

  // ---- right (难验证) chips: only human judgment --------------------------
  let rchip(x, claim, meth) = {
    rect((x - w/2, ry - h/2), (x + w/2, ry + h/2),
      fill: white, stroke: 0.9pt + fig-dark, radius: 2pt)
    content((x, ry), align(center, stack(dir: ttb, spacing: 4.5pt,
      text(size: 8pt, fill: fig-black, weight: "medium")[#claim],
      text(size: 7pt, fill: fig-num)[#sym.arrow.r 靠专业判断],
    )))
  }
  rchip(rxA, [「这个方向值得做」], none)
  rchip(rxB, [「这个实验公平」], none)

  // ---- zone labels flanking the divider ----------------------------------
  content((4.75, 0.18), text(size: 7pt, fill: fig-num)[机器可自动验证])
  content((8.35, 0.18), text(size: 7pt, fill: fig-num)[只能靠人判断])

  // ---- spectrum axis -----------------------------------------------------
  line((ax0, axy), (ax1, axy),
    mark: (end: ">", fill: fig-dark, scale: 0.7),
    stroke: 0.9pt + fig-dark)

  // end labels below axis
  content((0.55, -0.92), text(size: 8pt, fill: fig-dark, weight: "medium")[易验证])
  content((12.55, -0.92), text(size: 8pt, fill: fig-dark, weight: "medium")[难验证])

  // ---- principle line (bottom, emphasized) -------------------------------
  content((6.55, -1.42),
    text(size: 8pt, fill: fig-black, weight: "medium")[AI 做加法，人做减法])
})
