import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/portfolio_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/url_utils.dart';
import '../../../domain/entities/contact_link.dart';

/// Bottom dock of quick-launch contact buttons, one per [ContactLink].
class ModernDock extends StatelessWidget {
  const ModernDock({super.key});

  @override
  Widget build(BuildContext context) {
    final links = Get.find<PortfolioController>().profile.links;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(26.r),
      ),
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
      child: GestureDetector(
        onTap: () => launchExternal(link.url),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(_icon, size: 21.sp, color: _color),
        ),
      ),
    );
  }
}
