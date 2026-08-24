import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/url_utils.dart';
import '../../domain/entities/profile.dart';

/// Bundled résumé asset used when [Profile.resumeAssetPath] isn't set but
/// mobile still needs something to show in-app.
const String _kFallbackResumeAsset = 'assets/resume/sadakatul_shakil_cv.pdf';

/// Opens the résumé: an in-app pinch-zoom viewer on mobile (Android/iOS),
/// or the existing web behaviour on web — unchanged there, since web
/// already opens the PDF in the browser's own viewer.
void openResume(Profile profile) {
  if (kIsWeb) {
    final assetPath = profile.resumeAssetPath;
    if (assetPath != null) {
      openResumeAsset(assetPath);
    } else {
      launchExternal(profile.resumeUrl ?? '');
    }
    return;
  }
  Get.to(
    () => ResumeViewerScreen(
      assetPath: profile.resumeAssetPath ?? _kFallbackResumeAsset,
    ),
  );
}

/// In-app PDF viewer for the bundled résumé (mobile only) — pinch-zoom and
/// scroll through every page without leaving the app. The app-bar action
/// still offers opening it externally.
class ResumeViewerScreen extends StatefulWidget {
  const ResumeViewerScreen({super.key, required this.assetPath});

  final String assetPath;

  @override
  State<ResumeViewerScreen> createState() => _ResumeViewerScreenState();
}

class _ResumeViewerScreenState extends State<ResumeViewerScreen> {
  late final PdfControllerPinch _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfControllerPinch(
      document: PdfDocument.openAsset(widget.assetPath),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openExternally() {
    launchExternal(Uri.base.resolve('assets/${widget.assetPath}').toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBlack,
      appBar: AppBar(
        backgroundColor: AppColors.screenBg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'Résumé',
          style: AppTheme.sans(size: 16, weight: FontWeight.w600),
        ),
      ),
      body: PdfViewPinch(
        controller: _controller,
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: AppColors.accentSoft),
          ),
          pageLoaderBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: AppColors.accentSoft),
          ),
          errorBuilder: (_, __) =>
              _ResumeErrorNote(onOpenExternally: _openExternally),
        ),
      ),
    );
  }
}

class _ResumeErrorNote extends StatelessWidget {
  const _ResumeErrorNote({required this.onOpenExternally});

  final VoidCallback onOpenExternally;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.textMuted,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              "Couldn't load résumé",
              style: AppTheme.sans(size: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onOpenExternally,
              child: Text(
                'Open externally',
                style: AppTheme.sans(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.accentSoft,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
