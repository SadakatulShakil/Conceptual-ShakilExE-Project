import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/era_controller.dart';
import '../../../core/controllers/retro_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'retro_key.dart';

/// T9 letter groups for keys 1-9 (1 has none, a real feature-phone
/// convention).
const List<String?> _kT9 = [
  null, 'ABC', 'DEF', //
  'GHI', 'JKL', 'MNO', //
  'PQRS', 'TUV', 'WXYZ', //
];

/// The 4x3 numeric keypad. 1-9 only move the highlight (like dialing) —
/// OK/Enter/the left soft-key confirm and open. `#` time-travels; `*`/`0`
/// are inert for now.
class RetroKeypad extends StatelessWidget {
  const RetroKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    final retro = Get.find<RetroController>();
    final era = Get.find<EraController>();
    final gap = 8.w;

    return Column(
      children: [
        Obx(
          () => Column(
            children: [
              for (var row = 0; row < 3; row++) ...[
                if (row > 0) SizedBox(height: gap),
                Row(
                  children: [
                    for (var col = 0; col < 3; col++) ...[
                      if (col > 0) SizedBox(width: gap),
                      Expanded(child: _numberKey(retro, row * 3 + col + 1)),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: gap),
        Row(
          children: [
            Expanded(child: RetroKey(label: '*', onTap: () {})),
            SizedBox(width: gap),
            Expanded(
              child: RetroKey(label: '0', subLabel: '+', onTap: () {}),
            ),
            SizedBox(width: gap),
            Expanded(
              child: RetroKey(
                label: '#',
                onTap: era.toggleEra,
                selected: true,
                accentColor: AppColors.timeWarp,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          '# time travel',
          style: AppTheme.mono(size: 7.sp, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _numberKey(RetroController retro, int n) {
    return RetroKey(
      label: '$n',
      subLabel: _kT9[n - 1],
      selected: retro.highlighted.value == n,
      // Only moves the highlight — a real feature-phone convention where
      // pressing a number navigates the cursor, and OK confirms/opens.
      onTap: () => retro.focus(n),
    );
  }
}
