import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/bindings/root_binding.dart';
import 'core/theme/app_theme.dart';
import 'presentation/root/root_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const ShakilExeApp());
}

class ShakilExeApp extends StatelessWidget {
  const ShakilExeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // mobile baseline; web handled in Phase 6
      minTextAdapt: true,
      builder: (context, _) => GetMaterialApp(
        title: 'Shakil ExE',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        initialBinding: RootBinding(),
        home: const RootView(),
      ),
    );
  }
}
