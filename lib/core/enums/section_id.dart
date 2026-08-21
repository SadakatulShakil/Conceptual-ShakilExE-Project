/// Every navigable destination, shared by both shells.
/// Retro maps these to keypad 1-9; modern maps them to app icons.
enum SectionId {
  projects,
  experience,
  skills,
  about,
  resume,
  contact,
  github,
  now,
  extras;

  String get key => name;
}
