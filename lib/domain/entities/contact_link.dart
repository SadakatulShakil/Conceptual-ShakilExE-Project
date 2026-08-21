/// A single outbound channel shown in the dock / contact screen.
enum ContactType { github, linkedin, email, whatsapp, website }

class ContactLink {
  final ContactType type;
  final String label;

  /// Fully-qualified URL. For email use a mailto: string, for whatsapp use
  /// a https://wa.me/<number> link.
  final String url;

  const ContactLink({
    required this.type,
    required this.label,
    required this.url,
  });
}
