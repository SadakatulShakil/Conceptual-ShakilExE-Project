import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in an external app/browser.
///
/// Guards against empty or still-placeholder URLs left as `// TODO`s in the
/// repository data (e.g. an unfilled `mailto:you@example.com`), showing a
/// friendly snackbar instead of attempting to launch them.
Future<void> launchExternal(String url) async {
  if (url.isEmpty || url.contains('example.com') || url.endsWith('/in/')) {
    Get.snackbar('Not set yet', 'This link hasn\'t been configured yet.');
    return;
  }

  try {
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      Get.snackbar('Could not open link', url);
    }
  } catch (_) {
    Get.snackbar('Could not open link', url);
  }
}

/// Opens a résumé PDF bundled as an app asset (declared in `pubspec.yaml`,
/// e.g. `assets/resume/cv.pdf`).
///
/// Only wired up for web today, where Flutter serves declared assets as
/// static files under `assets/<assetPath>` relative to the app's base URL.
/// Native platforms would need to read the asset bytes and hand them to a
/// file viewer this app doesn't bundle yet, so they get a clear fallback
/// instead of a silent failure.
Future<void> openResumeAsset(String assetPath) async {
  if (!kIsWeb) {
    Get.snackbar(
      'Not available here',
      'Open the web version to view the résumé.',
    );
    return;
  }
  await launchExternal(Uri.base.resolve('assets/$assetPath').toString());
}
