#import "@preview/touying:0.5.3": *
#import "@preview/numbly:0.1.0": numbly
#import themes.metropolis: *

#show: metropolis-theme.with(
  aspect-ratio: "4-3",
  footer: self => self.info.title,
  config-info(
    title: [基于蒙特卡洛法算圆的面积],
    subtitle: [小组大作业报告],
    author: [拓欣 诸晓婉 张雨馨],
    date: "2024年12月12日",
  ),
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()
#include "work.typ"
#include "algorithm.typ"
#include "engine.typ"
#include "summerize.typ"

= <touying:hidden>

#align(center,text(size: 48pt,"谢谢!"))