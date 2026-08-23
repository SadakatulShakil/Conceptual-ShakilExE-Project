import 'package:flutter/material.dart';
import '../../domain/entities/contact_link.dart';

/// Maps a [ContactType] to its display icon, shared by both shells.
IconData contactIcon(ContactType type) => switch (type) {
      ContactType.github => Icons.code,
      ContactType.linkedin => Icons.person_pin,
      ContactType.email => Icons.mail_outline,
      ContactType.whatsapp => Icons.chat_bubble_outline,
      ContactType.website => Icons.link,
    };
