// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../constants/app_colors.dart';
import 'product_list_screen.dart';

/// ============================================================================
/// HALAMAN HOME (TAMPILAN UTAMA WEBSITE TOUR)
/// ============================================================================
/// Ini adalah halaman utama yang pertama kali muncul saat user membuka aplikasi
/// Berisi: Navigation bar, Hero banner, Partner logos, Destinasi populer, 
/// Feature cards (Find/Plan/Pay), dan Promo section di bagian bawah
/// ============================================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // ========================================================================
  // KONSTANTA PATH GAMBAR
  // ========================================================================
  // Path ini mengarah ke folder assets/images/ di project Flutter
  // Pastikan semua gambar sudah ada di folder tersebut dan terdaftar di pubspec.yaml
  // ========================================================================
  static const String heroImage = 'assets/images/hero_plane.jpg'; // Gambar background hero section
  static const String logoAirbnb = 'assets/images/pesawat.png'; // Gambar pesawat yang melayang di hero
  static const String dest1 = 'assets/images/ntb.jpg'; // Gambar destinasi NTB
  static const String dest2 = 'assets/images/bali.jpg'; // Gambar destinasi Bali
  static const String dest3 = 'assets/images/jawatimur.jpg'; // Gambar destinasi Jawa Timur
  static const String dest4 = 'assets/images/jogja.jpg'; // Gambar destinasi Yogyakarta

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background, // Warna background keseluruhan halaman
      body: SafeArea( // SafeArea memastikan konten tidak tertutup notch/status bar
        child: LayoutBuilder(builder: (context, constraints) {
          // ================================================================
          // RESPONSIVE LAYOUT
          // ================================================================
          // Mengecek lebar layar untuk menentukan tampilan mobile atau desktop
          // Jika lebar < 700px = mobile, jika >= 700px = desktop/tablet
          // ================================================================
          final isMobile = constraints.maxWidth < 700;
          final horizontalPadding = isMobile ? 16.0 : 48.0; // Padding kiri-kanan berbeda untuk mobile dan desktop

          return SingleChildScrollView( // Membuat halaman bisa di-scroll
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===========================================================
                  // STRUKTUR HALAMAN DARI ATAS KE BAWAH:
                  // ===========================================================
                  _buildTopNav(context, isMobile), // 1. Navigation bar di paling atas
                  const SizedBox(height: 20),
                  _buildHeroSection(context, isMobile, size), // 2. Hero banner dengan gambar & text besar
                  const SizedBox(height: 24),
                  _buildPartnerLogosRow(context, isMobile), // 3. Logo partner (Airbnb, Booking.com, dll)
                  const SizedBox(height: 28),
                  _buildPopularTitle(context), // 4. Judul "Popular Destination"
                  const SizedBox(height: 12),
                  _buildPopularCarousel(context, isMobile), // 5. Card destinasi populer (grid/carousel)
                  const SizedBox(height: 36),
                  _buildFeatureRow(context, isMobile), // 6. Tiga box fitur (Find/Plan/Pay)
                  const SizedBox(height: 36),
                  _buildPromoCta(context, isMobile), // 7. Promo banner di bagian bawah
                  const SizedBox(height: 48),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// ============================================================================
  /// 1. TOP NAVIGATION BAR
  /// ============================================================================
  /// Posisi: Paling atas halaman
  /// Berisi: Logo "IndonesiaTour" (kiri), Menu navigasi (tengah - hanya desktop),
  ///         Tombol "Book Trip" (kanan)
  /// ============================================================================
  Widget _buildTopNav(BuildContext context, bool isMobile) {
    return Row(
      children: [
        // Logo/Brand name di kiri
        const Text(
          'IndonesiaTour',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Spacer(), // Spacer untuk mendorong element ke kanan
        
        // Menu navigasi (ABOUT, TOUR, PACKAGE, CONTACT) - hanya muncul di desktop
        if (!isMobile)
          Row(
            children: const [
              Text('ABOUT'),
              SizedBox(width: 20),
              Text('TOUR'),
              SizedBox(width: 20),
              Text('PACKAGE'),
              SizedBox(width: 20),
              Text('CONTACT'),
            ],
          ),
        const Spacer(), // Spacer untuk mendorong tombol ke kanan
        
        // Tombol "Book Trip" di kanan
        ElevatedButton(
          onPressed: () {},
          child: const Text('Book Trip'),
        ),
      ],
    );
  }

  /// ============================================================================
  /// 2. HERO SECTION (BANNER BESAR DENGAN GAMBAR)
  /// ============================================================================
  /// Posisi: Di bawah navigation bar
  /// Berisi: 
  /// - Background gambar pantai/wisata
  /// - Overlay gradient gelap di kiri
  /// - Text besar "Explore the World" & "With Unforgettable Tour Experiences"
  /// - Tombol "Book A Trip Now" dan icon play
  /// - Card kecil "Know More - Awesome Places" di kanan bawah
  /// - Gambar pesawat melayang di kanan atas
  /// ============================================================================
  Widget _buildHeroSection(
    BuildContext context, bool isMobileFromParent, Size screenSizeFromParent) {

    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;

    // ========================================================================
    // RESPONSIVE BREAKPOINTS
    // ========================================================================
    // Menentukan kategori ukuran layar untuk responsive design
    // ========================================================================
    final bool isSmallMobile = width < 360; // Layar sangat kecil (HP lama)
    final bool isMobile = width < 600; // Layar mobile normal
    final bool isTablet = width >= 600 && width < 1024; // Layar tablet
    final bool isDesktop = width >= 1024; // Layar desktop/laptop

    // Tinggi hero section berbeda untuk tiap ukuran layar
    final heroHeight = isSmallMobile
      ? screenSize.height * 0.32 // 32% tinggi layar untuk small mobile
      : isMobile
          ? screenSize.height * 0.28 // 28% untuk mobile
          : isTablet
              ? screenSize.height * 0.36 // 36% untuk tablet
              : screenSize.height * 0.42; // 42% untuk desktop

    // ========================================================================
    // POSISI & UKURAN GAMBAR PESAWAT
    // ========================================================================
    // Gambar pesawat yang melayang di kanan atas hero section
    // Posisinya berbeda-beda untuk tiap ukuran layar agar terlihat proporsional
    // ========================================================================
    late double planeWidth; // Lebar gambar pesawat
    late double planeTop; // Jarak dari atas
    late double planeRight; // Jarak dari kanan (negatif = keluar dari container)

    if (isDesktop) {
      planeWidth = width * 0.26; // 26% lebar layar
      planeTop = -80; // Posisi di atas (keluar container)
      planeRight = -140; // Posisi kanan (keluar container)
    } else if (isTablet) {
      planeWidth = width * 0.34;
      planeTop = 80;
      planeRight = -110;
    } else if (isSmallMobile) {
      planeWidth = width * 0.60;
      planeTop = 10;
      planeRight = -70;
    } else if (isMobile) {
      planeWidth = width * 0.45;
      planeTop = 0;
      planeRight = -70;
    } else {
      planeWidth = width * 0.55;
      planeTop = -30;
      planeRight = -45;
    }

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack( // Stack untuk overlay multiple layer
        clipBehavior: Clip.none, // Membolehkan child keluar dari container (untuk pesawat)
        children: [
          // ================================================================
          // LAYER 1: GAMBAR BACKGROUND
          // ================================================================
          // Gambar pantai/wisata sebagai background hero section
          // ================================================================
          Positioned.fill( // Mengisi seluruh area parent
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28), // Sudut rounded
              child: Image.asset(
                heroImage,
                fit: BoxFit.cover, // Gambar memenuhi container
                alignment: Alignment.center,
              ),
            ),
          ),
          
          // ================================================================
          // LAYER 2: GRADIENT OVERLAY (EFEK GELAP DI KIRI)
          // ================================================================
          // Gradient dari hitam (kiri) ke transparan (kanan)
          // Agar text putih di kiri tetap terbaca
          // ================================================================
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.45), // Hitam semi-transparan di kiri
                    Colors.transparent, // Transparan di kanan
                  ],
                ),
              ),
            ),
          ),
          
          // ================================================================
          // LAYER 3: TEXT & TOMBOL DI KIRI
          // ================================================================
          // Berisi: "Explore the World", judul besar, dan tombol CTA
          // ================================================================
          Positioned(
            left: isMobile ? 18 : 40, // Jarak dari kiri
            top: isMobile ? 24 : 48, // Jarak dari atas
            bottom: isMobile ? 24 : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle kecil
                Text(
                  'Explore the World',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: isSmallMobile ? 10 : (isMobile ? 11 : 14),
                  ),
                ),
                SizedBox(height: 8),
                
                // Judul besar (Headline)
                Text(
                  'With Unforgettable\nTour Experiences',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallMobile ? 20 : (isMobile ? 24 : 44),
                    fontWeight: FontWeight.bold,
                    height: 1.05, // Line height (jarak antar baris)
                  ),
                ),
                SizedBox(height: 16),
                
                // Row berisi tombol dan icon play
                Row(
                  children: [
                    // Tombol CTA "Book A Trip Now"
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallMobile ? 12 : 18,
                          vertical: isSmallMobile ? 8 : 12,
                        ),
                        minimumSize: Size(isSmallMobile ? 100 : 140, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Book A Trip Now',
                        style: TextStyle(
                          fontSize: isSmallMobile ? 11 : 14,
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallMobile ? 8 : 12),
                    
                    // Icon play button (biasanya untuk video tour)
                    CircleAvatar(
                      radius: isSmallMobile ? 14 : 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.play_arrow,
                        size: isSmallMobile ? 16 : 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          
          // ================================================================
          // LAYER 4: CARD "KNOW MORE" DI KANAN BAWAH
          // ================================================================
          // Card kecil dengan gambar destinasi dan text "Know More"
          // Posisi: Kanan bawah hero section
          // ================================================================
          Positioned(
            right: isMobile ? 10 : 18, // Jarak dari kanan
            bottom: isMobile ? 10 : 18, // Jarak dari bawah
            child: Container(
              width: isMobile ? 110 : 220,
              padding: EdgeInsets.all(isMobile ? 6 : 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isMobile ? 12 : 18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: isMobile ? 10 : 14,
                    offset: Offset(0, 8), // Shadow ke bawah
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Gambar thumbnail destinasi
                  ClipRRect(
                    borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                    child: Image.asset(
                      dest1,
                      width: isMobile ? 28 : 40,
                      height: isMobile ? 28 : 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: isMobile ? 6 : 10),
                  
                  // Text "Know More" dan subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Know More',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 10 : 14,
                          ),
                        ),
                        SizedBox(height: isMobile ? 2 : 4),
                        Text(
                          'Awesome Places',
                          style: TextStyle(
                            fontSize: isMobile ? 9 : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Icon arrow (penanda bisa diklik)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: isMobile ? 10 : 14,
                  ),
                ],
              ),
            ),
          ),
          
          // ================================================================
          // LAYER 5: GAMBAR PESAWAT MELAYANG
          // ================================================================
          // Gambar dekoratif pesawat di kanan atas
          // Sebagian keluar dari container (clipBehavior: Clip.none)
          // ================================================================
          Positioned(
            top: planeTop, // Bisa negatif (keluar ke atas)
            right: planeRight, // Bisa negatif (keluar ke kanan)
            child: Image.asset(
              logoAirbnb,
              width: planeWidth,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high, // Kualitas gambar tinggi
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================================================
  /// 3. PARTNER LOGOS ROW
  /// ============================================================================
  /// Posisi: Di bawah hero section
  /// Berisi: Logo/text partner travel (Airbnb, Booking.com, trivago, Expedia)
  /// Layout: Horizontal row dengan spacing merata
  /// ============================================================================
  Widget _buildPartnerLogosRow(BuildContext context, bool isMobile) {
    final logos = ['Airbnb', 'Booking.com', 'trivago', 'Expedia'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spacing merata
        children: logos.map((l) {
          return Expanded( // Setiap logo mengambil space yang sama
            child: Center(
              child: Text(
                l,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// ============================================================================
  /// 4. POPULAR DESTINATION TITLE
  /// ============================================================================
  /// Posisi: Di bawah partner logos
  /// Berisi: Text judul "Popular Destination"
  /// ============================================================================
  Widget _buildPopularTitle(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        'Popular Destination',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ============================================================================
  /// 5. POPULAR DESTINATION CAROUSEL/GRID
  /// ============================================================================
  /// Posisi: Di bawah judul "Popular Destination"
  /// Berisi: Card destinasi populer (NTB, Bali, Jawa Timur, Yogyakarta)
  /// Layout Mobile: Grid 2 kolom (vertical scroll disabled)
  /// Layout Desktop: Horizontal scroll carousel
  /// ============================================================================
  Widget _buildPopularCarousel(BuildContext context, bool isMobile) {
    // ========================================================================
    // LAYOUT MOBILE: GRID 2 KOLOM
    // ========================================================================
    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: GridView.builder(
          shrinkWrap: true, // Grid menyesuaikan tinggi konten
          physics: const NeverScrollableScrollPhysics(), // Tidak bisa di-scroll (mengikuti scroll parent)
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom
            crossAxisSpacing: 12, // Jarak horizontal antar card
            mainAxisSpacing: 12, // Jarak vertical antar card
            childAspectRatio: 0.85, // Rasio lebar:tinggi card
          ),
          itemCount: 4, // Total 4 destinasi
          itemBuilder: (context, index) {
            // Data destinasi
            final destinations = [
              {'image': dest1, 'title': 'Nusa Tenggara Barat', 'subtitle': 'NTB, Indonesia', 'rating': 4.9},
              {'image': dest2, 'title': 'Bali', 'subtitle': 'Bali, Indonesia', 'rating': 4.8},
              {'image': dest3, 'title': 'Jawa Timur', 'subtitle': 'Jatim, Indonesia', 'rating': 4.7},
              {'image': dest4, 'title': 'Yogyakarta', 'subtitle': 'Jogja, Indonesia', 'rating': 4.6},
            ];
            final dest = destinations[index];
            return _buildDestinationCard(
              context,
              dest['image'] as String,
              dest['title'] as String,
              dest['subtitle'] as String,
              dest['rating'] as double,
              true, // isMobile = true
            );
          },
        ),
      );
    }

    // ========================================================================
    // LAYOUT DESKTOP: HORIZONTAL SCROLL CAROUSEL
    // ========================================================================
    return SizedBox(
      height: 220, // Tinggi fixed
      child: ListView(
        scrollDirection: Axis.horizontal, // Scroll horizontal
        children: [
          const SizedBox(width: 4), // Padding kiri
          _buildDestinationCard(context, dest1, 'Nusa Tenggara Barat', 'NTB, Indonesia', 4.9, false),
          const SizedBox(width: 12), // Spacing antar card
          _buildDestinationCard(context, dest2, 'Bali', 'Bali, Indonesia', 4.8, false),
          const SizedBox(width: 12),
          _buildDestinationCard(context, dest3, 'Jawa Timur', 'Jatim, Indonesia', 4.7, false),
          const SizedBox(width: 8),
          _buildDestinationCard(context, dest4, 'Yogyakarta', 'Jogja, Indonesia', 4.6, false),
          const SizedBox(width: 8), // Padding kanan
        ],
      ),
    );
  }

  /// ============================================================================
  /// DESTINATION CARD (DENGAN ANIMASI HOVER & TAP)
  /// ============================================================================
  /// Widget card untuk menampilkan 1 destinasi
  /// Berisi: Gambar, nama destinasi, subtitle lokasi, rating
  /// Fitur: Hover effect (desktop), tap animation, navigasi ke ProductListScreen
  /// Parameter:
  /// - image: Path gambar destinasi
  /// - title: Nama destinasi (misal: "Bali")
  /// - subtitle: Lokasi detail (misal: "Bali, Indonesia")
  /// - rating: Rating angka (misal: 4.8)
  /// - isMobile: Boolean untuk ukuran card
  /// ============================================================================
  Widget _buildDestinationCard(
    BuildContext context,
    String image,
    String title,
    String subtitle,
    double rating,
    bool isMobile,
  ) {
    final cardWidth = isMobile ? 220.0 : 280.0; // Lebar card berbeda mobile/desktop

    return MouseRegion( // Deteksi mouse hover (untuk desktop)
      onEnter: (_) {}, // Bisa tambahkan efek hover di sini
      child: Container(
        width: cardWidth,
        clipBehavior: Clip.hardEdge, // Potong overflow
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: _AnimatedHoverTap( // Custom widget untuk animasi hover & tap
          child: Material(
            color: Colors.white,
            child: GestureDetector(
              // ============================================================
              // ON TAP: NAVIGASI KE PRODUCT LIST SCREEN
              // ============================================================
              // Saat card diklik, user akan pindah ke halaman daftar tour
              // sesuai kategori destinasi yang dipilih
              // ============================================================
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductListScreen(
                      // Convert title destinasi ke string category
                      // Fungsi getCategoryFromTitle() ada di bawah
                      category: getCategoryFromTitle(title),
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ========================================================
                  // GAMBAR DESTINASI (BAGIAN ATAS CARD)
                  // ========================================================
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16), // Radius hanya di atas
                    ),
                    child: Image.asset(
                      image,
                      height: isMobile ? 100 : 140,
                      width: double.infinity,
                      fit: BoxFit.cover, // Gambar memenuhi area
                    ),
                  ),
                  
                  // ========================================================
                  // INFO DESTINASI (BAGIAN BAWAH CARD)
                  // ========================================================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      children: [
                        // Column berisi title & subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama destinasi
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis, // Potong dengan "..." jika kepanjangan
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Lokasi detail
                              Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // ====================================================
                        // BADGE RATING (HIJAU DENGAN ICON BINTANG)
                        // ====================================================
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toString(), // Angka rating
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ============================================================================
  /// FUNGSI KONVERSI: TITLE DESTINASI → STRING CATEGORY
  /// ============================================================================
  /// Fungsi ini mengubah nama destinasi menjadi string kategori yang akan
  /// dikirim ke ProductListScreen untuk filter tour berdasarkan lokasi
  /// 
  /// Contoh:
  /// Input: "Bali" → Output: "Bali"
  /// Input: "Nusa Tenggara Barat" → Output: "Nusa Tenggara Barat"
  /// 
  /// PENTING: Fungsi ini mengembalikan STRING, bukan object Category!
  /// ProductListScreen menerima parameter String untuk filter kategori tour
  /// ============================================================================
  String getCategoryFromTitle(String title) {
    switch (title) {
      case 'Nusa Tenggara Barat':
        return 'Nusa Tenggara Barat';
        
      case 'Bali':
        return 'Bali';
        
      case 'Jawa Timur':
        return 'Jawa Timur';
        
      case 'Yogyakarta':
        return 'Yogyakarta';
        
      default:
        return title; // Return title asli jika tidak ada match
    }
  }

 /// ============================================================================
 /// 6. FEATURE ROW (3 BOX: FIND / PLAN / PAY)
 /// ============================================================================
 /// Posisi: Di bawah carousel destinasi
 /// Berisi: 3 card fitur yang menjelaskan proses booking
 /// - Box kiri: "Find Your Destination" (putih, icon search)
 /// - Box tengah: "Plan Your Holiday" (biru gradient, lebih besar, elevated)
 /// - Box kanan: "Pay & Start Journey" (putih, icon payment)
 /// 
 /// Layout Mobile: 3 box vertical (column)
 /// Layout Desktop: 3 box horizontal (row) dengan bagian bawah sejajar
 /// ============================================================================
Widget _buildFeatureRow(BuildContext context, bool isMobile) {
  // ========================================================================
  // LAYOUT MOBILE: VERTICAL STACK
  // ========================================================================
  if (isMobile) {
    return Column(
      children: [
        _featureCardMini('Find Your Destination', Icons.search, false),
        const SizedBox(height: 12),
        _featureCardCentered(context),
        const SizedBox(height: 12),
        _featureCardMini('Pay & Start Journey', Icons.payment, false),
      ],
    );
  }

  // ========================================================================
  // LAYOUT DESKTOP: HORIZONTAL ROW
  // ========================================================================
  // CrossAxisAlignment.end: Semua box sejajar dari BAWAH
  // Jadi box Find dan Pay akan naik mengikuti tinggi box Plan
  // Hasilnya: bagian bawah ketiga box rata (garis lurus)
  // ========================================================================
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end, // KUNCI: Sejajar dari bawah
    children: [
      // Box kiri: Find Your Destination (expand mengisi space tersisa)
      Expanded(child: _featureCardMini('Find Your Destination', Icons.search, true)),
      
      // TIDAK ADA SizedBox di sini = box nyatu/mepet
      
      // Box tengah: Plan Your Holiday (lebar fixed 320px)
      SizedBox(width: 320, child: _featureCardCentered(context)),
      
      // TIDAK ADA SizedBox di sini = box nyatu/mepet
      
      // Box kanan: Pay & Start Journey (expand mengisi space tersisa)
      Expanded(child: _featureCardMini('Pay & Start Journey', Icons.payment, true)),
    ],
  );
}

/// ============================================================================
/// FEATURE CARD MINI (BOX FIND & PAY)
/// ============================================================================
/// Card kecil putih dengan icon dan text
/// Digunakan untuk box "Find Your Destination" dan "Pay & Start Journey"
/// Parameter:
/// - title: Text yang ditampilkan
/// - icon: Icon yang ditampilkan (search atau payment)
/// - elevated: Boolean untuk shadow (true = shadow lebih tinggi di desktop)
/// ============================================================================
Widget _featureCardMini(String title, IconData icon, bool elevated) {
  return Card(
    elevation: elevated ? 6 : 3, // Shadow berbeda untuk mobile (3) dan desktop (6)
    margin: EdgeInsets.zero, // PENTING: Hilangkan margin default Card agar benar-benar mepet
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16), // Radius di sudut kiri atas
        topRight: Radius.circular(16), // Radius di sudut kanan atas
        bottomLeft: Radius.circular(0), // PENTING: Bawah lurus tanpa radius (garis lurus)
        bottomRight: Radius.circular(0), // PENTING: Bawah lurus tanpa radius (garis lurus)
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
      child: Row(
        children: [
          // ================================================================
          // ICON CONTAINER (BACKGROUND ABU-ABU ROUNDED)
          // ================================================================
          // Icon search atau payment dengan background abu-abu terang
          // ================================================================
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight, // Warna background abu-abu terang
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryGreen), // Icon hijau
          ),
          const SizedBox(width: 12),
          
          // ================================================================
          // TEXT TITLE
          // ================================================================
          // Text "Find Your Destination" atau "Pay & Start Journey"
          // Expanded agar text mengisi sisa space
          // ================================================================
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}

/// ============================================================================
/// FEATURE CARD CENTERED (BOX PLAN TENGAH - BIRU GRADIENT)
/// ============================================================================
/// Card besar di tengah dengan gradient biru dan tombol "LEARN MORE"
/// Ini adalah focal point (pusat perhatian) dari feature row
/// Berisi:
/// - Icon explore (kompas)
/// - Judul "Plan Your Holiday"
/// - Deskripsi fitur
/// - Tombol CTA "LEARN MORE"
/// ============================================================================
Widget _featureCardCentered(BuildContext context) {
  return Card(
    elevation: 10, // Shadow tinggi untuk efek elevated/menonjol
    margin: EdgeInsets.zero, // PENTING: Hilangkan margin default agar mepet
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20), // Radius lebih besar (20) di atas
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(0), // PENTING: Bawah lurus tanpa radius
        bottomRight: Radius.circular(0), // PENTING: Bawah lurus tanpa radius
      ),
    ),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // ================================================================
        // GRADIENT BIRU (DARI GELAP KE TERANG)
        // ================================================================
        // Gradient dari kiri atas (biru gelap) ke kanan bawah (biru terang)
        // Memberikan efek depth dan modern
        // ================================================================
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400], // Biru gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(0), // Bawah lurus
          bottomRight: Radius.circular(0), // Bawah lurus
        ),
      ),
      child: Column(
        children: [
          // Icon explore (kompas) putih
          const Icon(Icons.explore, size: 40, color: Colors.white),
          const SizedBox(height: 12),
          
          // Judul "Plan Your Holiday"
          const Text(
            'Plan Your Holiday', 
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: Colors.white
            )
          ),
          const SizedBox(height: 8),
          
          // Deskripsi fitur (text lebih kecil, warna putih transparan)
          const Text(
            'Explore curated tour packages, discover exciting destinations, and enjoy a hassle-free travel experience.',
            style: TextStyle(fontSize: 12, color: Colors.white70), // white70 = putih 70% opacity
            textAlign: TextAlign.center, // Text tengah
          ),
          const SizedBox(height: 12),
          
          // ================================================================
          // TOMBOL CTA "LEARN MORE"
          // ================================================================
          // Tombol putih dengan text biru (kontras dengan background biru)
          // ================================================================
          ElevatedButton(
            onPressed: () {}, // TODO: Tambahkan navigasi atau action
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Background putih
              foregroundColor: Colors.blue.shade600, // Text & icon biru
            ),
            child: const Text('LEARN MORE'),
          ),
        ],
      ),
    ),
  );
}

  /// ============================================================================
  /// 7. PROMO CTA SECTION (BANNER PROMOSI DI BAWAH)
  /// ============================================================================
  /// Posisi: Paling bawah halaman (sebelum footer jika ada)
  /// Berisi: 
  /// - Gambar destinasi (kiri di desktop, atas di mobile)
  /// - Text promosi "DISCOVER EXCLUSIVE JOURNEYS WITH IndonesiaTour"
  /// - Deskripsi singkat
  /// - Tombol "Reserve Your Tour"
  /// 
  /// Layout Mobile: Column (gambar atas, text bawah)
  /// Layout Desktop: Row (gambar kiri, text kanan)
  /// ============================================================================
  Widget _buildPromoCta(BuildContext context, bool isMobile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18), // Rounded corner untuk seluruh card
      child: Container(
        color: Colors.white, // Background putih
        padding: const EdgeInsets.all(18),
        child: isMobile
            // ================================================================
            // LAYOUT MOBILE: VERTICAL (COLUMN)
            // ================================================================
            ? Column(
                children: [
                  // Gambar destinasi di atas
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      dest1,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Text promosi
                  Text(
                    'DISCOVER EXCLUSIVE JOURNEYS WITH', 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 18
                    )
                  ),
                  const SizedBox(height: 12),
                  
                  // Tombol CTA
                  ElevatedButton(
                    onPressed: () {}, 
                    child: const Text('Reserve Your Tour')
                  ),
                ],
              )
            // ================================================================
            // LAYOUT DESKTOP: HORIZONTAL (ROW)
            // ================================================================
            : Row(
                children: [
                  // Gambar destinasi di kiri (fixed width)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      dest1,
                      width: 220, // Lebar fixed
                      height: 180,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  // Text & tombol di kanan (expanded)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align kiri
                      children: [
                        // Subtitle kecil
                        const Text(
                          'DISCOVER EXCLUSIVE JOURNEYS WITH', 
                          style: TextStyle(
                            fontWeight: FontWeight.w600, 
                            fontSize: 18
                          )
                        ),
                        const SizedBox(height: 6),
                        
                        // Brand name besar
                        const Text(
                          'IndonesiaTour', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 34
                          )
                        ),
                        const SizedBox(height: 12),
                        
                        // Deskripsi
                        const Text(
                          'Experience thoughtfully crafted tours designed to bring you comfort, beauty, and authentic cultural encounters.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 18),
                        
                        // Tombol CTA
                        ElevatedButton(
                          onPressed: () {}, 
                          child: const Text('Reserve Your Tour')
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// ============================================================================
/// WIDGET ANIMASI HOVER & TAP (UNTUK DESTINATION CARD)
/// ============================================================================
/// Custom StatefulWidget untuk memberikan animasi smooth pada destination card
/// 
/// FITUR ANIMASI:
/// 1. HOVER (Desktop): Card membesar 4% dan shadow lebih gelap
/// 2. TAP/PRESS: Card mengecil 6% (efek pressed)
/// 3. NORMAL: Ukuran normal dengan shadow standar
/// 
/// CARA KERJA:
/// - MouseRegion: Deteksi mouse masuk/keluar (hover)
/// - Listener: Deteksi pointer down/up (tap/press)
/// - AnimatedContainer: Animasi smooth perubahan scale dan shadow
/// 
/// PENGGUNAAN:
/// Wrap widget apapun dengan _AnimatedHoverTap untuk dapat efek animasi
/// Contoh: _AnimatedHoverTap(child: YourWidget())
/// ============================================================================
class _AnimatedHoverTap extends StatefulWidget {
  final Widget child; // Widget yang akan diberi animasi
  const _AnimatedHoverTap({required this.child});

  @override
  State<_AnimatedHoverTap> createState() => _AnimatedHoverTapState();
}

/// ============================================================================
/// STATE UNTUK _AnimatedHoverTap
/// ============================================================================
/// Menyimpan 2 state boolean:
/// - _hovering: true saat mouse di atas card (desktop only)
/// - _pressed: true saat card sedang di-tap/klik
/// ============================================================================
class _AnimatedHoverTapState extends State<_AnimatedHoverTap> {
  bool _hovering = false; // State hover
  bool _pressed = false; // State pressed/tap

  @override
  Widget build(BuildContext context) {
    // ========================================================================
    // HITUNG SCALE BERDASARKAN STATE
    // ========================================================================
    // Prioritas: pressed > hovering > normal
    // - Pressed: 0.94 (mengecil 6%)
    // - Hovering: 1.04 (membesar 4%)
    // - Normal: 1.0 (ukuran asli)
    // ========================================================================
    final scale = _pressed
        ? 0.94 // Saat di-press: mengecil
        : _hovering
            ? 1.04 // Saat hover: membesar
            : 1.0; // Normal

    // ========================================================================
    // HITUNG SHADOW BERDASARKAN STATE
    // ========================================================================
    // Hover: Shadow lebih gelap dan blur lebih besar (efek elevated)
    // Normal: Shadow standar
    // ========================================================================
    final shadow = _hovering
        ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Lebih gelap
              blurRadius: 22, // Blur lebih besar
              offset: const Offset(0, 10), // Offset lebih jauh ke bawah
            )
          ]
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.12), // Lebih terang
              blurRadius: 12, // Blur standar
              offset: const Offset(0, 6), // Offset standar
            )
          ];

    return MouseRegion(
      // ==================================================================
      // MOUSE REGION: DETEKSI HOVER (DESKTOP)
      // ==================================================================
      // onEnter: Mouse masuk area widget → set _hovering = true
      // onExit: Mouse keluar area widget → set _hovering = false
      // ==================================================================
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Listener(
        // ================================================================
        // LISTENER: DETEKSI TAP/PRESS (MOBILE & DESKTOP)
        // ================================================================
        // onPointerDown: Jari/mouse ditekan → set _pressed = true
        // onPointerUp: Jari/mouse dilepas → set _pressed = false
        // ================================================================
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        child: AnimatedContainer(
          // ==============================================================
          // ANIMATED CONTAINER: ANIMASI SMOOTH
          // ==============================================================
          // duration: Durasi animasi (180ms = cepat dan responsif)
          // curve: Kurva animasi (easeOut = smooth deceleration)
          // transform: Matrix4 untuk scale (zoom in/out)
          // decoration: BoxShadow untuk efek shadow
          // ==============================================================
          duration: const Duration(milliseconds: 180), // Durasi animasi
          curve: Curves.easeOut, // Kurva animasi smooth
          transform: Matrix4.identity()..scale(scale), // Apply scale transformation
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: shadow, // Apply shadow berdasarkan state
          ),
          child: widget.child, // Widget asli yang di-wrap
        ),
      ),
    );
  }
}