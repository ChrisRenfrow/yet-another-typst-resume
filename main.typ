#import "@preview/oxifmt:0.2.1": strfmt

#import "theme.typ": default_theme as theme

#let data_path = sys.inputs.at("data_path", default: "data/software-developer.toml")
#let data = toml(data_path)

// Destructuring

#let name = data.name
#let title = data.at("title", default: none)
#let contact = data.contact
#let experiences = data.at("experiences", default: ())
#let education = data.education

// Page setup

#set page(
    paper: "us-letter",
    margin: (top: 0.25in, rest: 0.5in),
)

#set text(..theme.text.body)

// Styling by labels

#show <name>: set text(..theme.text.header)
#show <job_title>: set text(..theme.text.subtitle)
#show <contact_info>: set text(
  fill: theme.colors.link,
  size: theme.sizes.small,
)
#show <exp_name>: set text(
    weight: "semibold",
    fill: theme.colors.accent,
    size: theme.sizes.base,
)
#show <exp_job_title>: set text(
    weight: "semibold",
    size: theme.sizes.small
)
#show <location>: set text(
    size: theme.sizes.smaller,
    fill: theme.colors.accent_light,
)
#show <date_range>: set text(
  size: theme.sizes.small,
)
#show <h_line>: set line(
    stroke: 0.3pt + theme.colors.accent_light,
)
#show <description>: set text(
    size: theme.sizes.smaller,
)
#show <exp_descriptor>: set text(
    size: theme.sizes.smaller,
)
#show <exp_skills>: set text(
    size: theme.sizes.smaller,
    fill: theme.colors.accent_light,
)
#show <edu_name>: set text(
    weight: "semibold",
    size: theme.sizes.small
)

// Helper Functions

#let date_fmt(date) = date.display("[month repr:short], [year repr:full]")

// Components

#let skill_capsule(content, theme: theme) = {
  let style = theme.components.skill_capsule
  set text(..style.text)
  box(
    ..style.box,
    content
  )
}

#let name_and_title = if "title" in data.keys() and data.title != "" {
    [
        #[#name <name>] \
        #[#title <job_title>]
    ]
} else {
    [
        #[#name <name>]
    ]
}

#let contact_formatter(x) = if x != none { [ #link(x.link)[#underline(x.display)] \ ] } else { "" }
#let format_contacts(contacts) = contacts.map(contact_formatter).join()

#let contact_info = {
  let left_items = (
    contact.at("github", default: none),
    contact.at("website", default: none),
    contact.at("blog", default: none))
  let right_items = (
    contact.at("phone", default: none),
    contact.at("email", default: none),
    contact.at("linkedin", default: none))

  (
    left: format_contacts(left_items),
    right: format_contacts(right_items)
  )
}

#let header_grid(left_contact, name_and_title, right_contact) = grid(
    columns: (1fr, 1fr, 1fr),
    align(left)[#left_contact <contact_info>],
    align(center + horizon)[#name_and_title],
    align(right)[#right_contact <contact_info>]
)

#let experience_title(name, start_date, end_date: none) = [
  #let end_date_str = if end_date != none { date_fmt(end_date) } else { [present] }
  #grid(
    columns: (auto, 1fr, auto),
    column-gutter: 30pt,
    [#name <exp_name>],
    align(horizon + center)[#line(length: 100%) <h_line>],
    align(right)[#[#date_fmt(start_date) - #end_date_str] <date_range>],
  )
]

#let experience_subtitle(title: none, location: none) = grid(
  columns: (auto, 1fr, auto),
  column-gutter: 30pt,
  if title != none { [#title <exp_job_title>] } else { [] },
  [],
  if location != none { align(right)[#location <location>] } else { [] }
)

#let experience_descriptors(descriptors, spacing: none) = {
  stack(spacing: spacing, ..descriptors.map(d => [ - #d <exp_descriptor>]))
}

#let experience_skills(skills, spacing: 4pt) = {
  stack(
    dir: ltr,
    spacing: spacing,
    ..skills.map(skill => skill_capsule(skill.name))
  )
}

#let experience_item(exp, spacing: 6pt) = stack(
  spacing: spacing,
  experience_title(
    exp.name,
    exp.start_date,
    end_date: exp.at("end_date", default: none)
  ),
  experience_subtitle(
    title: exp.at("title", default: none),
    location: exp.at("location", default: none),
  ),
  [#exp.description <description>],
  experience_descriptors(exp.descriptors, spacing: 4pt),
  experience_skills(exp.skills_used)
)

#let education_title(name, start_date, end_date: none) = [
  #let end_date_str = if end_date != none { date_fmt(end_date) } else { [present] }
  #grid(
    columns: (auto, 1fr, auto),
    column-gutter: 30pt,
    [#name <edu_name>],
    align(horizon + center)[#line(length: 100%) <h_line>],
    align(right)[#[#date_fmt(start_date) - #end_date_str] <date_range>],
  )
]

#let education_subtitle(location: none) = grid(
  columns: (auto, 1fr, auto),
  column-gutter: 30pt,
  [],
  [],
  if location != none { align(right)[#location <location>] } else { [] }
)

#let education_item(ed, spacing: 3pt) = stack(
  spacing: spacing,
  education_title(
    ed.name,
    ed.start_date,
    end_date: ed.at("end_date", default: none)
  ),
  education_subtitle(
    location: ed.at("location", default: none),
  ),
  if "description" in ed.keys() {
    [#ed.description <description>]
  }
)

// Layout

#header_grid(contact_info.left, name_and_title, contact_info.right)
#line(length: 100%) <h_line_header>
= Experience
#stack(spacing: 10pt, ..experiences.map(exp => experience_item(exp)))
= Education
#stack(spacing: 3pt, ..education.map(ed => education_item(ed)))
