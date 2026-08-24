import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/portfolio_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/url_utils.dart';
import '../../../domain/entities/contact_link.dart';
import '../../shared/clickable.dart';
import '../../shared/glass_card.dart';

/// Bottom dock of quick-launch contact buttons, one per [ContactLink].
///
/// Sits pinned on top of the scrollable content, so it needs a
/// frosted-glass treatment strong enough that scrolling content doesn't
/// show through — hence a higher [blurSigma] than the other glass cards.
class ModernDock extends StatelessWidget {
  const ModernDock({super.key});

  @override
  Widget build(BuildContext context) {
    final links = Get.find<PortfolioController>().profile.links;

    return GlassCard(
      radius: 26.r,
      blurSigma: 24,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          for (final link in links) Expanded(child: _DockButton(link: link)),
        ],
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  const _DockButton({required this.link});

  final ContactLink link;

  IconData get _icon => switch (link.type) {
        ContactType.github => Icons.code,
        ContactType.linkedin => Icons.person_pin,
        ContactType.email => Icons.mail_outline,
        ContactType.whatsapp => Icons.chat_bubble_outline,
        ContactType.website => Icons.link,
      };

  Color get _color => switch (link.type) {
        ContactType.github => AppColors.iconWhite,
        ContactType.linkedin => AppColors.iconBlue,
        ContactType.email => AppColors.iconCoral,
        ContactType.whatsapp => AppColors.iconTeal,
        ContactType.website => AppColors.iconGray,
      };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Clickable(
        onTap: () => launchExternal(link.url),
        child: Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          alignment: Alignment.center,
          child: Icon(_icon, size: 24.sp, color: _color),
        ),
      ),
    );
  }
}
