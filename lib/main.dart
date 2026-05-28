import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/data/fcm_service.dart';

import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables from .env
  await dotenv.load(fileName: '.env');

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const InventoryTrackApp());
}

class InventoryTrackApp extends StatelessWidget {
  const InventoryTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Inventory Track',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      defaultTransition: Transition.noTransition,
      initialRoute: Routes.LOGIN,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(FcmService());
      }),
    );
  }
}
