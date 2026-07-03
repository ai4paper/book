// Common library for all chapter files
// Import this at the top of each chapter file to access theorem environments and utilities

#import "@preview/theorion:0.3.2": *

// Configure theorem environments
#show: show-theorion

// Custom color scheme
#let primary-color = rgb("#20B2AA")  // Light sea green
#let secondary-color = rgb("#4682B4") // Steel blue
#let accent-color = rgb("#DC143C")    // Crimson
#let text-color = rgb("#2F4F4F")      // Dark slate gray

// Custom functions for colored text shortcuts
#let redt(content) = text(fill: rgb("#DC143C"), content)
#let bluet(content) = text(fill: rgb("#1E90FF"), content)
#let greent(content) = text(fill: rgb("#32CD32"), content)
