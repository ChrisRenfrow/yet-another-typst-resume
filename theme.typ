#let create_theme(
  colors: (
    base: black,
    accent: color.hsl(90deg, 70%, 30%),
  ),
  fonts: (
    primary: "Raleway",
    header: "Zilla Slab",
  ),
  sizes: (
    base: 12pt,
    h1: 24pt,
    h2: 14pt,
    small: 10pt,
    smaller: 8pt,
  ),
  spacing: (
    section: 16pt,
    paragraph: 8pt,
    inline: 4pt,
  ),
) = {
  let derived_colors = (
    accent_dark: colors.accent.darken(10%),
    accent_light: colors.accent.lighten(10%),
    base_light: colors.base.lighten(10%),
    link: colors.accent.darken(30%),
    accent_fill: colors.accent.opacify(-95%),
  )

  (
    colors: colors + derived_colors,
    fonts: fonts,
    sizes: sizes,
    spacing: spacing,
    text: (
      body: (
        font: fonts.primary,
        size: sizes.base,
        fill: colors.base,
      ),
      header: (
        font: fonts.header,
        size: sizes.h1,
        fill: colors.base,
      ),
      subtitle: (
        font: fonts.primary,
        size: sizes.h2,
        fill: colors.accent,
      ),
      small: (
        font: fonts.primary,
        size: sizes.small,
        fill: colors.base,
      ),
    ),

    components: (
      skill_capsule: (
        text: (
          size: sizes.smaller,
          fill: colors.accent,
          weight: "semibold",
        ),
        box: (
          inset: (x: 6pt, y: 3pt),
          radius: 10pt,
          stroke: (
            paint: colors.accent,
            thickness: 0.2pt,
          ),
          fill: derived_colors.accent_fill
        ),
      ),

      section_divider: (
        stroke: 0.3pt + colors.accent,
      ),
    ),
  )
}

#let default_theme = create_theme()
