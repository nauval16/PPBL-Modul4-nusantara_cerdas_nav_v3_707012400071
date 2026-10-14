import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/pengajuan_model.dart';
import 'navigation/app_routes.dart';

void main() {
  runApp(
    // State bersama disediakan di akar aplikasi.
    ChangeNotifierProvider(
      create: (_) => PengajuanModel(),
      child: MaterialApp(
        title: 'Nusantara Cerdas Mobile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1565C0),
          ).copyWith(primary: const Color(0xFF1565C0)),
          scaffoldBackgroundColor: const Color(0xFFF3F8FF),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1565C0),
            foregroundColor: Colors.white,
            centerTitle: false,
          ),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: Color(0xFFBBDEFB),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF1565C0),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFBBDEFB),
              disabledForegroundColor: const Color(0xFF64B5F6),
            ),
          ),
        ),
        initialRoute: AppRoutes.beranda,
        routes: AppRoutes.daftarRoute(),
        onGenerateRoute: AppRoutes.bentukRoute,
        onUnknownRoute: AppRoutes.routeTidakDikenal,
      ),
    ),
  );
}
