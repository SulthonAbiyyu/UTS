// main.dart

// Import library bawaan Flutter untuk UI
import 'package:flutter/material.dart';

// Import library untuk mengatur orientasi layar & status bar
import 'package:flutter/services.dart';

// Import halaman awal aplikasi (HomeScreen)
import 'screens/home_screen.dart';

// Import file warna custom yg kamu buat sendiri
import 'constants/app_colors.dart';


/// ============================================================================
/// 1. ENTRY POINT APLIKASI
///    - Semua aplikasi Flutter SELALU mulai dari fungsi main()
///    - Dari sinilah Flutter menjalankan widget pertama (root widget)
/// ============================================================================
void main() {
  // Menghubungkan Flutter engine ke aplikasi
  // WAJIB kalau kita mau set SystemChrome atau plugin before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // ==========================================================================
  // 1A. MENGUNCI ARAH LAYAR AGAR HANYA PORTRAIT
  //    - portraitUp : layar tegak normal
  //    - portraitDown : terbalik
  //    - Ini mencegah aplikasi berputar ke landscape
  // ==========================================================================
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ==========================================================================
  // 1B. MENGATUR WARNA STATUS BAR & NAVIGATION BAR (SYSTEM UI)
  //    - statusBarColor               : warna latar belakang status bar
  //    - statusBarIconBrightness      : warna ikon di status bar
  //    - systemNavigationBarColor     : warna navbar (Android)
  //    - systemNavigationBarIconBrightness : warna ikon navbar
  // ==========================================================================
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,          // transparan biar clean
      statusBarIconBrightness: Brightness.dark,    // ikon hitam
      systemNavigationBarColor: Colors.white,      // navbar putih
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // ==========================================================================
  // 1C. MEMULAI APLIKASI
  //    - IndonesiaTourApp adalah widget root (paling atas)
  //    - Semua UI dan halaman berasal dari widget ini
  // ==========================================================================
  runApp(const IndonesiaTourApp());
}


/// ============================================================================
/// 2. ROOT WIDGET APLIKASI (STATLESS WIDGET)
///    - Stateless berarti tidak punya state yang berubah.
///    - Di sinilah kita mendefinisikan MaterialApp:
///         • theme
///         • routes (opsional)
///         • home (halaman pertama)
/// ============================================================================
class IndonesiaTourApp extends StatelessWidget {
  const IndonesiaTourApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Nama aplikasi
      title: 'IndonesiaTour - DISCOVER EXCLUSIVE JOURNEYS ',

      // Menghilangkan banner DEBUG di pojok kanan atas
      debugShowCheckedModeBanner: false,

      // =========================================================================
      // 2A. THEME UTAMA APLIKASI
      //     - Semua warna, font, button, card menggunakan tema ini
      // =========================================================================
      theme: ThemeData(
        // Warna utama aplikasi (diambil dari AppColors)
        primaryColor: AppColors.primaryGreen,

        // Warna background semua halaman (scaffold)
        scaffoldBackgroundColor: AppColors.background,

        // Skema warna global
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,     // warna dasar untuk generate tone
          primary: AppColors.primaryGreen,
          secondary: AppColors.accentGreen,
          background: AppColors.background,
          surface: Colors.white,
        ),

        // =========================================================================
        // 2B. CARD THEME
        //     - Tampilan kartu/kotak, misal untuk item wisata
        // =========================================================================
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 6,                     // bayangan
          shadowColor: AppColors.shadow,    // warna shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // border radius card
          ),
        ),

        // =========================================================================
        // 2C. TEXT THEME
        //     - Ukuran font default
        //     - Biar konsisten antar halaman
        // =========================================================================
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
        ),

        // =========================================================================
        // 2D. ELEVATED BUTTON THEME
        //     - Semua ElevatedButton mengikuti gaya ini
        // =========================================================================
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen, // warna button
            foregroundColor: Colors.white,            // warna text
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // =========================================================================
        // 2E. TRANSISI HALAMAN
        //     - Menggunakan animasi ala iOS (lebih smooth)
        // =========================================================================
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),

      // =========================================================================
      // 2F. HOME SCREEN
      //     - Halaman pertama yang muncul saat aplikasi dijalankan
      // =========================================================================
      home: const HomeScreen(),
    );
  }
}
