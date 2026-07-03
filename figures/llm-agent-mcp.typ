// Layering intuition: LLM engine -> agent execution loop -> MCP tool sockets.
// Center-left solid box = LLM engine (darkest). A dashed container = the agent
// loop, wrapping the engine with a clockwise cycle (决定 -> 调用 -> 看结果).
// Right, outside the loop = MCP tools plugged in via socket-dot connectors.
// Grayscale hierarchy: engine darkest/solid > loop medium > tools light.
#import "@preview/cetz:0.3.4"
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: ("New Computer Modern Sans", "Source Han Sans"), size: 9pt, fallback: true)

// Grayscale palette (print-friendly hierarchy)
#let fig-black = luma(0%)    // primary text
#let fig-dark  = luma(20%)   // engine border, loop arrows
#let fig-num   = luma(38%)   // secondary / annotation text
#let fig-mid   = luma(50%)   // tool borders, connectors
#let fig-cont  = luma(60%)   // dashed agent container
#let fig-soft  = luma(55%)   // subtle cues
#let fig-light = luma(85%)   // engine block fill
#let fig-pale  = luma(95%)   // (unused fill reserve)

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  // ---- loop arrow helper ------------------------------------------------
  let hook = (end: ">", fill: fig-dark, scale: 0.7)

  // ================= LAYER 2 : agent execution loop (container) =========
  rect((-2.9, -2.75), (4.3, 2.75),
    stroke: (paint: fig-cont, thickness: 0.55pt, dash: "loosely-dashed"),
    radius: 2pt, name: "agent")
  content((-2.75, 2.42), anchor: "west",
    text(size: 8pt, fill: fig-dark, weight: "medium")[agent · 执行循环])

  // ================= LAYER 1 : LLM engine (darkest, most solid) =========
  rect((-1.4, -0.7), (1.4, 0.7),
    fill: fig-light, stroke: 1.1pt + fig-black, radius: 2pt, name: "llm")
  content((0, 0), align(center, stack(dir: ttb, spacing: 3.2pt,
    text(size: 9pt, fill: fig-black, weight: "medium")[LLM · 引擎],
    text(size: 7pt, fill: fig-num)[预测下一个词],
  )))

  // ---- three cycle steps around the engine (white step boxes) ----------
  let step(name, x, y, label) = {
    rect((x - 0.95, y - 0.34), (x + 0.95, y + 0.34),
      fill: white, stroke: 0.9pt + fig-dark, radius: 1.5pt, name: name)
    content((x, y), text(size: 8pt, fill: fig-black)[#label])
  }
  step("decide", 0, 2.0, [决定下一步])   // top
  step("call",   3.1, 0, [调用工具])     // right
  step("obs",    0, -2.0, [看结果])      // bottom

  // ---- clockwise loop arrows -------------------------------------------
  // engine drives the loop
  line((0, 0.7), (0, 1.66), mark: hook, stroke: 0.85pt + fig-dark)
  // 决定下一步 -> 调用工具 (top -> right)
  bezier("decide.east", "call.north", (3.1, 2.0),
    mark: hook, stroke: 0.85pt + fig-dark)
  // 调用工具 -> 看结果 (right -> bottom)
  bezier("call.south", "obs.east", (3.1, -2.0),
    mark: hook, stroke: 0.85pt + fig-dark)
  // 看结果 -> 决定下一步 (bottom -> top, returning sweep on the left)
  bezier("obs.west", "decide.west", (-2.8, 0),
    mark: hook, stroke: 0.85pt + fig-dark)

  // ================= LAYER 3 : MCP tools (outside, lightest) =============
  let tool(name, y, label) = {
    rect((6.4 - 0.85, y - 0.34), (6.4 + 0.85, y + 0.34),
      fill: white, stroke: 0.6pt + fig-mid, radius: 1.5pt, name: name)
    content((6.4, y), text(size: 8pt, fill: fig-dark)[#label])
  }
  tool("t1", 1.3, [文献库])
  tool("t2", 0, [编译器])
  tool("t3", -1.3, [数据源])

  // MCP connectors: 调用工具 -> tools, with a plug at the call side and a
  // filled socket dot at each tool end.
  let socket(x, y) = { circle((x, y), radius: 0.055, fill: fig-mid, stroke: none) }
  // opening in the container edge where the tool sockets reach out
  line((4.3, -0.42), (4.3, 0.42), stroke: 2.6pt + white)
  // plug base at 调用工具.east
  circle((4.05, 0), radius: 0.055, fill: fig-dark, stroke: none)
  for (ty, tx) in ((1.3, 5.55), (0, 5.55), (-1.3, 5.55)) {
    line((4.05, 0), (tx, ty), stroke: 0.7pt + fig-mid)
    socket(tx, ty)
  }
  content((6.4, 2.42),
    text(size: 8pt, fill: fig-num, weight: "medium")[MCP · 工具插座])

  // ================= bottom reading key =================================
  content((2.2, -3.18),
    text(size: 7pt, fill: fig-num)[引擎 #sym.arrow.r 执行循环 #sym.arrow.r 外部世界的插座])
})
