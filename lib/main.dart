// lib/main.dart

import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/supabase_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── 1. Supabase init ────────────────────────────────────────
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
    // authOptions: keep defaults (PKCE flow, session persistence)
  );

  // ── 2. Firebase init (for FCM) ──────────────────────────────
  // Uncomment after adding google-services.json / GoogleService-Info.plist
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // ── 3. Dependency Injection ─────────────────────────────────
  await di.init();

  runApp(const VpmsApp());
}

class VpmsApp extends StatelessWidget {
  const VpmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VPMS — Royal India Vacation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
