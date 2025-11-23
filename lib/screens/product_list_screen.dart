import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'product_detail_screen.dart';

/// ============================================================================
/// 🎨 PRODUCT LIST SCREEN - OPTIMIZED PERFORMANCE
/// ============================================================================
/// Screen ini menampilkan daftar destinasi wisata berdasarkan kategori (Bali, Yogyakarta, dll)
/// Letak di UI: Halaman kedua setelah user klik kategori di home screen
/// Fitur utama:
/// - Header hero dengan gradient animasi
/// - Filter chip (All, Popular, New)
/// - Grid card destinasi yang responsive
/// - Stagger animation saat pertama load
/// - Performance optimization dengan caching
/// ============================================================================

class ProductListScreen extends StatefulWidget {
  // Parameter 'category' menentukan kategori destinasi yang ditampilkan
  // Contoh: "Bali", "Yogyakarta", "Nusa Tenggara Barat", "Jawa Timur"
  final String category;

  const ProductListScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

/// STATE CLASS - Mengatur behavior dan interaksi
/// TickerProviderStateMixin = Dibutuhkan untuk multiple animations (3 animation controllers)
class _ProductListScreenState extends State<ProductListScreen> 
    with TickerProviderStateMixin {
  
  // ========== ANIMATION CONTROLLERS ==========
  // Controller untuk fade in/out effect
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  // Controller untuk stagger animation (card muncul berurutan)
  late AnimationController _staggerController;
  
  // Controller untuk parallax effect (tidak digunakan dalam kode ini, tapi disiapkan)
  late AnimationController _parallaxController;
  
  // ========== STATE VARIABLES ==========
  // Filter yang sedang dipilih: 'All', 'Popular', atau 'New'
  String _selectedFilter = 'All';

  // Flag untuk mendeteksi apakah user sedang scroll
  // Digunakan untuk optimasi performa (disable animasi saat scroll)
  bool _isScrolling = false;
  
  // Timer untuk debounce scroll event (mencegah terlalu banyak rebuild)
  Timer? _scrollTimer;
  
  // ========== CACHE DATA ==========
  // Cache untuk menghindari rebuild yang tidak perlu
  // _cachedDestinations = semua destinasi untuk kategori ini
  late List<Map<String, dynamic>> _cachedDestinations;
  
  // _cachedFilteredDestinations = destinasi yang sudah difilter (All/Popular/New)
  late List<Map<String, dynamic>> _cachedFilteredDestinations;

  /// INIT STATE - Fungsi pertama yang dijalankan saat screen dibuka
  @override
  void initState() {
    super.initState();
    _initializeData(); // Load data destinasi
    _initializeAnimations(); // Setup semua animasi
  }

  /// INITIALIZE DATA - Load data destinasi dari map berdasarkan kategori
  /// Dipanggil sekali saat screen pertama kali dibuka
  void _initializeData() {
    // Ambil list destinasi berdasarkan kategori (contoh: widget.category = "Bali")
    // Jika tidak ada, gunakan list kosong []
    _cachedDestinations = destinationData[widget.category] ?? [];
    
    // Awalnya, tampilkan semua destinasi (belum difilter)
    _cachedFilteredDestinations = _cachedDestinations;
  }

  /// INITIALIZE ANIMATIONS - Setup semua animation controller
  /// Dipanggil sekali saat screen pertama kali dibuka
  void _initializeAnimations() {
    // FADE CONTROLLER - Untuk fade in effect konten
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000), // Durasi 1 detik
      vsync: this, // Sinkronisasi dengan refresh rate layar
    );
    
    // Fade animation dengan curve easeInOutCubic (smooth)
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    );
    
    // STAGGER CONTROLLER - Untuk card muncul berurutan (stagger effect)
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200), // Durasi 1.2 detik
      vsync: this,
    );
    
    // PARALLAX CONTROLLER - Untuk parallax effect (tidak digunakan)
    _parallaxController = AnimationController(
      duration: const Duration(milliseconds: 50), // Durasi 50ms (fast)
      vsync: this,
    );
    
    // Mulai animasi fade dan stagger
    _fadeController.forward(); // 0 -> 1
    _staggerController.forward(); // 0 -> 1
  }

  /// DISPOSE - Bersihkan memory saat screen ditutup
  /// Penting untuk mencegah memory leak!
  @override
  void dispose() {
    _scrollTimer?.cancel(); // Cancel timer jika masih berjalan
    _fadeController.dispose(); // Hentikan fade controller
    _staggerController.dispose(); // Hentikan stagger controller
    _parallaxController.dispose(); // Hentikan parallax controller
    super.dispose();
  }

  /// ========== DATA DESTINASI ==========
  /// Map yang berisi semua data destinasi wisata, dikelompokkan per kategori
  /// Key = Nama kategori (Bali, Yogyakarta, dll)
  /// Value = List destinasi untuk kategori tersebut
  /// 
  /// Struktur setiap destinasi:
  /// - name: Nama destinasi/tour
  /// - location: Lokasi lengkap
  /// - price: Harga per orang
  /// - rating: Rating bintang (1-5)
  /// - reviews: Jumlah review
  /// - image: Path gambar asset
  /// - description: Deskripsi panjang destinasi
  /// - category: Kategori filter (Popular/New)
  /// - duration: Durasi tour
  /// - facilities: List fasilitas yang tersedia
  final Map<String, List<Map<String, dynamic>>> destinationData = {
  
  // ========== KATEGORI: BALI ==========
  'Bali': [
    {
      'name': 'Private Guide – Eksplor Pantai Kuta & Hidden Spot',
      'location': 'Kuta, Bali',
      'price': 'Rp 450.000',
      'rating': 4.8,
      'reviews': 1293,
      'image': 'assets/images/kuta_beach.jpg',
      'description':
          'Tour guide pribadi yang akan menemani Anda menyusuri Pantai Kuta, mengunjungi spot sunset tersembunyi, serta membantu pengambilan foto profesional. Cocok untuk wisata keluarga atau traveler solo.',
      'category': 'Popular', // Masuk filter 'Popular'
      'duration': '4 jam',
      'facilities': [
        'Private Guide',
        'Photo Assistance',
        'Local Storytelling',
        'Flexible Route'
      ],
    },
    {
      'name': 'Tour Guide Tanah Lot – Sunset & Cultural Walk',
      'location': 'Tabanan, Bali',
      'price': 'Rp 380.000',
      'rating': 4.9,
      'reviews': 2102,
      'image': 'assets/images/tanah_lot.jpg',
      'description':
          'Pemandu wisata profesional yang akan menjelaskan sejarah Tanah Lot, tradisi lokal, akses spot foto terbaik, serta mengatur timing sunset paling ideal.',
      'category': 'Popular',
      'duration': '3 jam',
      'facilities': [
        'Certified Guide',
        'Cultural Briefing',
        'Photo Spot Assistance',
        'Mini Group'
      ],
    },
    {
      'name': 'Ubud Monkey Forest – Private Cultural & Nature Guide',
      'location': 'Ubud, Bali',
      'price': 'Rp 320.000',
      'rating': 4.7,
      'reviews': 1721,
      'image': 'assets/images/monkey_forest.jpg',
      'description':
          'Guide lokal berpengalaman yang akan mengarahkan Anda di area Monkey Forest, memberi edukasi tentang perilaku monyet, serta menceritakan sejarah pura kuno yang ada di dalam kawasan.',
      'category': 'New', // Masuk filter 'New'
      'duration': '2 jam',
      'facilities': [
        'Local Guide',
        'Wildlife Education',
        'Safety Briefing',
        'Cultural Explanation'
      ],
    },
  ],

  // ========== KATEGORI: YOGYAKARTA ==========
  'Yogyakarta': [
    {
      'name': 'Tour Guide Candi Borobudur – Sejarah & Filosofi',
      'location': 'Magelang, Yogyakarta',
      'price': 'Rp 250.000',
      'rating': 5.0,
      'reviews': 3112,
      'image': 'assets/images/candi_borobudur.jpg',
      'description':
          'Pemandu bersertifikat yang menjelaskan sejarah Borobudur, makna relief, jalur naik terbaik, serta pengalaman meditasi singkat di puncak stupa.',
      'category': 'Popular',
      'duration': '3 jam',
      'facilities': [
        'Licensed Guide',
        'History Explanation',
        'Relief Storytelling',
        'Priority Route Tips'
      ],
    },
    {
      'name': 'Walking Tour Malioboro – Kuliner & Sejarah Jalan',
      'location': 'Pusat Kota, Yogyakarta',
      'price': 'Rp 150.000',
      'rating': 4.7,
      'reviews': 1843,
      'image': 'assets/images/malioboro.jpg',
      'description':
          'Pemandu lokal akan menemani Anda menikmati Malioboro, mencicipi jajanan khas, menunjukkan pengrajin batik, serta menjelaskan sejarah kawasan.',
      'category': 'New',
      'duration': '3 jam',
      'facilities': [
        'Local Guide',
        'Culinary Recommendation',
        'Shopping Assistance',
        'Street History Walk'
      ],
    },
  ],

  // ========== KATEGORI: NUSA TENGGARA BARAT ==========
  'Nusa Tenggara Barat': [
    {
      'name': 'Rinjani Trekking Guide – Summit & Segara Anak',
      'location': 'Lombok, NTB',
      'price': 'Rp 1.800.000',
      'rating': 4.9,
      'reviews': 892,
      'image': 'assets/images/rinjani.jpg',
      'description':
          'Paket pemandu profesional untuk pendakian Rinjani 2–3 hari. Sudah termasuk briefing keselamatan, penentuan ritme pendakian, pengaturan camp, serta edukasi alam.',
      'category': 'Popular',
      'duration': '2–3 hari',
      'facilities': [
        'Professional Guide',
        'Camp Arrangement',
        'First Aid Support',
        'Summit Strategy'
      ],
    },
    {
      'name': 'Gili Trawangan Island Guide – Snorkeling & Local Tour',
      'location': 'Lombok Utara, NTB',
      'price': 'Rp 350.000',
      'rating': 4.9,
      'reviews': 1572,
      'image': 'assets/images/gili_trawangan.jpg',
      'description':
          'Guide berpengalaman yang akan memandu Anda ke spot snorkeling terbaik, membantu foto underwater, serta mengajak berkeliling desa lokal di Gili.',
      'category': 'Popular',
      'duration': 'Full Day',
      'facilities': [
        'Snorkeling Guide',
        'Underwater Photo',
        'Bicycle Route Tour',
        'Local Culture Visit'
      ],
    },
  ],

  // ========== KATEGORI: JAWA TIMUR ==========
  'Jawa Timur': [
    {
      'name': 'Bromo Sunrise Guide – Jeep & Viewpoint Trip',
      'location': 'Probolinggo, Jawa Timur',
      'price': 'Rp 550.000',
      'rating': 4.9,
      'reviews': 2411,
      'image': 'assets/images/jawatimur.jpg',
      'description':
          'Guide profesional yang mengatur rute sunrise terbaik, membantu saat berada di lautan pasir, serta memberikan sejarah kawasan TNBTS.',
      'category': 'Popular',
      'duration': '1 hari',
      'facilities': [
        'Jeep Coordination',
        'Sunrise Spot Guide',
        'Safety Assistant',
        'Local History'
      ],
    },
    {
      'name': 'Kawah Ijen Blue Fire Guide – Night Trekking',
      'location': 'Banyuwangi, Jawa Timur',
      'price': 'Rp 480.000',
      'rating': 4.8,
      'reviews': 1993,
      'image': 'assets/images/kawah_ijen.jpg',
      'description':
          'Guide khusus pendakian malam Ijen dengan briefing penggunaan gas mask, pengaturan waktu turun ke kawah, dan penjelasan fenomena blue fire.',
      'category': 'Popular',
      'duration': '1 hari',
      'facilities': [
        'Gas Mask Provided',
        'Night Trek Guide',
        'Safety Monitoring',
        'Blue Fire Explanation'
      ],
    },
  ],
};

  /// UPDATE FILTER - Fungsi untuk mengubah filter dan update UI
  /// Dipanggil saat: User klik filter chip (All/Popular/New)
  /// Parameter: newFilter = filter yang baru dipilih
  void _updateFilter(String newFilter) {
    setState(() {
      // Update filter yang dipilih
      _selectedFilter = newFilter;
      
      // Filter destinasi berdasarkan kategori yang dipilih
      // Jika 'All', tampilkan semua. Jika tidak, filter berdasarkan category
      _cachedFilteredDestinations = newFilter == 'All'
          ? _cachedDestinations // Tampilkan semua
          : _cachedDestinations.where((d) => d['category'] == newFilter).toList();
      
      // Reset dan jalankan ulang stagger animation untuk smooth transition
      _staggerController.reset(); // Kembali ke 0
      _staggerController.forward(); // 0 -> 1
    });
  }

  /// BUILD - Fungsi utama untuk render UI
  /// Dipanggil setiap kali ada perubahan state (setState)
  @override
  Widget build(BuildContext context) {
    // Ambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Tentukan apakah mobile atau tidak (breakpoint: 600px)
    final isMobile = screenWidth < 600;

    // SCAFFOLD = Struktur dasar halaman
    return Scaffold(
      backgroundColor: Colors.white, // Background putih
      
      // CUSTOM SCROLL VIEW = Scroll view dengan sliver (untuk collapsing header)
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(), // Efek bouncing iOS style
        slivers: [
          
          // ========== SLIVER 1: APP BAR (HEADER) ==========
          // AppBar yang bisa collapse saat di-scroll, berisi hero gradient
          SliverAppBar(
            expandedHeight: isMobile ? 220 : 280, // Tinggi maksimal header
            floating: false, // false = tidak muncul saat scroll ke bawah
            pinned: true, // true = tetap terlihat (collapsed) saat scroll
            stretch: true, // Efek stretch saat over-scroll
            backgroundColor: const Color(0xFF1E88E5), // Background biru
            elevation: 0, // Hilangkan shadow
            
            // Tombol back (kiri atas)
            leading: _buildBackButton(),
            
            // Tombol aksi (kanan atas): search & filter
            actions: [
              // Tombol search
              _buildActionButton(
                icon: Icons.search_rounded,
                onPressed: () {}, // Belum ada fungsi
              ),
              const SizedBox(width: 8),
              
              // Tombol filter dengan badge jika filter aktif
              _buildActionButton(
                icon: Icons.tune_rounded,
                onPressed: () {}, // Belum ada fungsi
                badge: _selectedFilter != 'All', // Badge muncul jika bukan 'All'
              ),
              const SizedBox(width: 16),
            ],
            
            // FLEXIBLE SPACE BAR = Area yang berubah saat scroll (hero image)
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              background: _buildHeroImage(_cachedDestinations, isMobile),
            ),
          ),
          
          // ========== SLIVER 2: FILTER SECTION ==========
          // Section dengan filter chips (All/Popular/New)
          SliverToBoxAdapter(
            child: _buildFilterSection(_cachedFilteredDestinations, isMobile),
          ),
          
          // ========== SLIVER 3: DESTINATION GRID / EMPTY STATE ==========
          // Jika tidak ada destinasi, tampilkan empty state
          // Jika ada, tampilkan grid card destinasi
          _cachedFilteredDestinations.isEmpty
              ? SliverToBoxAdapter(child: _buildEmptyState())
              : _buildDestinationGrid(_cachedFilteredDestinations, screenWidth, isMobile),
          
          // ========== SLIVER 4: BOTTOM SPACING ==========
          // Spacing di bawah agar card terakhir tidak tertutup
          SliverToBoxAdapter(
            child: SizedBox(height: isMobile ? 24 : 32),
          ),
        ],
      ),
    );
  }

  /// BUILD BACK BUTTON - Tombol kembali kustom (kiri atas)
  /// Letak di UI: Pojok kiri atas, di atas hero image
  /// Styling: Lingkaran putih dengan shadow + icon biru
  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(8), // Jarak dari tepi
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Putih semi-transparan
        shape: BoxShape.circle, // Bentuk lingkaran
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow hitam 10%
            blurRadius: 8,
            offset: const Offset(0, 2), // Shadow 2px ke bawah
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new, // Icon panah kiri
          color: Color(0xFF1E88E5), // Warna biru
          size: 20,
        ),
        onPressed: () => Navigator.pop(context), // Kembali ke halaman sebelumnya
      ),
    );
  }

  /// BUILD ACTION BUTTON - Template tombol aksi (search & filter)
  /// Letak di UI: Kanan atas, di atas hero image
  /// Parameter:
  /// - icon: Icon yang ditampilkan
  /// - onPressed: Fungsi yang dijalankan saat diklik
  /// - badge: Flag untuk menampilkan dot merah (filter aktif)
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool badge = false, // Default: tidak ada badge
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Putih semi-transparan
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      
      // STACK = Layer icon + badge
      child: Stack(
        children: [
          // Icon button
          IconButton(
            icon: Icon(icon, color: const Color(0xFF1E88E5), size: 22),
            onPressed: onPressed,
          ),
          
          // Badge dot merah (hanya muncul jika badge = true)
          if (badge)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red, // Dot merah
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// BUILD HERO IMAGE - Header hero dengan gradient dan pattern
  /// Letak di UI: Bagian atas halaman (di dalam SliverAppBar)
  /// Fitur:
  /// - Gradient biru multi-layer
  /// - Pattern geometris (diagonal lines + circles)
  /// - Icon dekoratif (explore icon)
  /// - Konten: Badge Indonesia, nama kategori, jumlah destinasi
  Widget _buildHeroImage(List<Map<String, dynamic>> destinations, bool isMobile) {
    // STACK = Multiple layers (gradient + pattern + content)
    return Stack(
      children: [
        
        // ========== LAYER 1: BACKGROUND GRADIENT PREMIUM ==========
        // Gradient biru dengan 4 stops untuk efek depth
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, // Mulai dari pojok kiri atas
                end: Alignment.bottomRight, // Ke pojok kanan bawah
                colors: [
                  const Color(0xFF0D47A1), // Biru gelap
                  const Color(0xFF1565C0), // Biru medium-dark
                  const Color(0xFF1E88E5), // Biru medium
                  const Color(0xFF42A5F5), // Biru terang
                ],
                stops: const [0.0, 0.3, 0.6, 1.0], // Posisi setiap warna
              ),
            ),
          ),
        ),
        
        // ========== LAYER 2: PATTERN OVERLAY ==========
        // Pattern geometris (diagonal lines + circles) menggunakan CustomPainter
        Positioned.fill(
          child: CustomPaint(
            painter: GeometricPatternPainter(isMobile: isMobile),
          ),
        ),
        
        // ========== LAYER 3: GRADIENT OVERLAY (untuk depth) ==========
        // Gradasi transparan -> hitam -> putih untuk efek depth
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1), // Atas: hitam ringan
                  Colors.transparent, // Tengah: transparan
                  Colors.white.withOpacity(0.3), // Bawah: putih ringan
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        
        // ========== LAYER 4: DEKORASI BULAT (kanan atas) ==========
        // Lingkaran gradient putih besar untuk dekorasi
        Positioned(
          top: isMobile ? -60 : -100, // Posisi negatif = keluar layar sebagian
          right: isMobile ? -40 : -80,
          child: Container(
            width: isMobile ? 200 : 300,
            height: isMobile ? 200 : 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.15), // Tengah: putih 15%
                  Colors.white.withOpacity(0.05), // Middle: putih 5%
                  Colors.transparent, // Luar: transparan
                ],
              ),
            ),
          ),
        ),
        
        // ========== LAYER 5: DEKORASI BULAT (kiri bawah) ==========
        // Lingkaran gradient putih medium untuk dekorasi
        Positioned(
          bottom: isMobile ? 20 : 30,
          left: isMobile ? -60 : -100,
          child: Container(
            width: isMobile ? 180 : 250,
            height: isMobile ? 180 : 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        
        // ========== LAYER 6: ICON DEKORASI ==========
        // Icon explore besar semi-transparan (kanan tengah)
        Positioned(
          top: isMobile ? 100 : 140,
          right: isMobile ? 20 : 40,
          child: Opacity(
            opacity: 0.15, // 15% opacity (sangat transparan)
            child: Icon(
              Icons.explore_rounded,
              size: isMobile ? 80 : 120,
              color: Colors.white,
            ),
          ),
        ),
        
        // ========== LAYER 7: KONTEN UTAMA ==========
        // Text content (badge, judul, subtitle) di bawah
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.only(
              left: isMobile ? 20 : 32,
              right: isMobile ? 20 : 32,
              bottom: isMobile ? 30 : 40,
              top: isMobile ? 80 : 110, // Top padding besar agar tidak tertutup status bar
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align kiri
              mainAxisAlignment: MainAxisAlignment.end, // Konten di bawah
              children: [
                
                // --- BADGE INDONESIA ---
                // Dipindahkan sedikit ke kiri dengan Transform.translate
                Transform.translate(
                  offset: Offset(isMobile ? -6 : -8, 0), // Geser ke kiri
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2), // Putih semi-transparan
                      borderRadius: BorderRadius.circular(20), // Pill shape
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Lebar sesuai konten
                      children: [
                        Icon(
                          Icons.location_on, // Icon pin lokasi
                          color: Colors.white,
                          size: isMobile ? 14 : 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Indonesia',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 12 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 10),
                
                // --- JUDUL KATEGORI ---
                // Nama kategori (contoh: "Bali", "Yogyakarta")
                Text(
                  widget.category, // Dari parameter screen
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 28 : 36, // Font besar bold
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1, // Huruf lebih rapat
                    height: 1.1, // Line height
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3), // Shadow hitam
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 6 : 8),
                
                // --- SUBTITLE (Jumlah destinasi + badge Terpopuler) ---
                Row(
                  children: [
                    // Badge jumlah destinasi (putih, teks biru)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${destinations.length} Destinasi', // Contoh: "3 Destinasi"
                        style: TextStyle(
                          color: const Color(0xFF1E88E5), // Text biru
                          fontSize: isMobile ? 13 : 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Icon bintang kuning
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amber[300],
                      size: isMobile ? 18 : 20,
                    ),
                    const SizedBox(width: 4),
                    
                    // Text "Terpopuler"
                    Text(
                      'Terpopuler',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 13 : 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// BUILD FILTER SECTION - Section dengan filter chips
  /// Letak di UI: Tepat di bawah hero image, sebelum grid card
  /// Fitur: 3 filter chip (All, Popular, New) dengan icon
  Widget _buildFilterSection(List<Map<String, dynamic>> filteredDestinations, bool isMobile) {
    // Wrap dengan FadeTransition untuk fade in effect
    return FadeTransition(
      opacity: _fadeAnimation, // Animasi opacity (0 -> 1)
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 24), // Padding responsif
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align kiri
          children: [
            const SizedBox(height: 20), // Spacing atas
            
            // WRAP = Layout yang otomatis pindah baris jika tidak muat
            Wrap(
              spacing: 12, // Spacing horizontal antar chip
              runSpacing: 12, // Spacing vertical antar baris
              children: [
                // Filter chip "All" dengan icon grid
                _buildFilterChip('All', Icons.grid_view_rounded),
                
                // Filter chip "Popular" dengan icon api
                _buildFilterChip('Popular', Icons.local_fire_department_rounded),
                
                // Filter chip "New" dengan icon bintang new
                _buildFilterChip('New', Icons.new_releases_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// BUILD FILTER CHIP - Template untuk satu chip filter
  /// Letak di UI: Bagian dari filter section
  /// Parameter:
  /// - label: Text yang ditampilkan (All/Popular/New)
  /// - icon: Icon yang ditampilkan
  /// Fitur: Animasi smooth saat selected/unselected, gradient biru saat selected
  Widget _buildFilterChip(String label, IconData icon) {
    // Cek apakah chip ini sedang dipilih
    final isSelected = _selectedFilter == label;
    
    // GestureDetector = Deteksi tap user
    return GestureDetector(
      onTap: () => _updateFilter(label), // Update filter saat diklik
      
      // AnimatedContainer = Container dengan animasi otomatis saat property berubah
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Durasi animasi
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        
        decoration: BoxDecoration(
          // Gradient biru hanya untuk yang selected (dan tidak sedang scroll)
          gradient: isSelected && !_isScrolling
              ? const LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                )
              : null, // Tidak ada gradient jika tidak selected
          
          // Fallback solid color jika gradient null
          color: isSelected ? Colors.blue : Colors.grey[100],
          
          borderRadius: BorderRadius.circular(20), // Pill shape
          
          // Border abu-abu untuk yang tidak selected
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
            width: 1.5,
          ),
          
          // Shadow biru untuk yang selected
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1E88E5).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [], // Tidak ada shadow jika tidak selected
        ),
        
        // ROW = Icon + Text horizontal
        child: Row(
          mainAxisSize: MainAxisSize.min, // Lebar sesuai konten
          children: [
            // ICON
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[700], // Putih jika selected
            ),
            const SizedBox(width: 8),
            
            // TEXT LABEL
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// BUILD DESTINATION GRID - Grid layout untuk card destinasi
  /// Letak di UI: Area scrollable utama, menampilkan semua card destinasi
  /// Layout: Grid responsif dengan jumlah kolom berdasarkan lebar layar
  /// - Mobile (< 600px): 2 kolom
  /// - Tablet (600-899px): 3 kolom
  /// - Desktop (900-1199px): 4 kolom
  /// - Large Desktop (>= 1200px): 5 kolom
  Widget _buildDestinationGrid(
    List<Map<String, dynamic>> destinations, 
    double screenWidth, 
    bool isMobile
  ) {
    // SliverPadding = Sliver dengan padding
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      
      // SliverGrid = Grid layout dalam sliver
      sliver: SliverGrid(
        // Grid delegate = Mengatur layout grid
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(screenWidth), // Jumlah kolom dinamis
          crossAxisSpacing: isMobile ? 12 : 20, // Spacing horizontal
          mainAxisSpacing: isMobile ? 12 : 20, // Spacing vertical
          childAspectRatio: isMobile ? 0.72 : 0.75, // Rasio lebar:tinggi card
        ),
        
        // Delegate = Builder untuk setiap item
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // RepaintBoundary = Isolasi repaint untuk optimasi performa
            // Widget ini mencegah repaint menyebar ke widget lain
            return RepaintBoundary(
              child: _buildStaggeredCard(index, destinations[index], isMobile),
            );
          },
          childCount: destinations.length, // Jumlah card
        ),
      ),
    );
  }

  /// BUILD STAGGERED CARD - Card dengan stagger animation
  /// Letak di UI: Setiap card dalam grid
  /// Fitur: Animasi muncul berurutan (stagger) dengan delay bertahap
  /// Parameter:
  /// - index: Posisi card dalam list (untuk hitung delay)
  /// - destination: Data destinasi untuk card ini
  /// - isMobile: Flag untuk responsive sizing
  Widget _buildStaggeredCard(int index, Map<String, dynamic> destination, bool isMobile) {
    // Hitung delay untuk card ini (0.1 detik per card)
    // Card 0: delay 0s, Card 1: delay 0.1s, Card 2: delay 0.2s, dst
    final delay = index * 0.1;
    
    // Hanya animasi saat pertama load (controller status = forward)
    if (_staggerController.status == AnimationStatus.forward) {
      // AnimatedBuilder = Rebuild setiap frame animasi
      return AnimatedBuilder(
        animation: _staggerController,
        builder: (context, child) {
          // Hitung progress animasi untuk card ini
          // Formula: (current_value - delay) / (1.0 - delay)
          // Clamp antara 0.0 - 1.0 agar tidak negatif/lebih dari 1
          final progress = Curves.easeOutCubic.transform(
            math.max(0.0, math.min(1.0, (_staggerController.value - delay) / (1.0 - delay))),
          );
          
          // Transform.translate = Geser posisi widget
          return Transform.translate(
            // Offset Y: 50px * (1 - progress)
            // Progress 0: offset 50px (di bawah), Progress 1: offset 0px (posisi normal)
            offset: Offset(0, 50 * (1 - progress)),
            
            // Opacity: 0 -> 1 seiring progress
            child: Opacity(
              opacity: progress,
              child: child, // Child = card widget
            ),
          );
        },
        child: _buildDestinationCard(destination, isMobile), // Card widget
      );
    }
    
    // Setelah animasi selesai, return widget biasa tanpa AnimatedBuilder
    // Ini untuk performa (tidak perlu rebuild terus-menerus)
    return _buildDestinationCard(destination, isMobile);
  }

  /// BUILD DESTINATION CARD - Card destinasi dengan semua info
  /// Letak di UI: Setiap card dalam grid
  /// Struktur:
  /// - Image (aspect ratio 16:10)
  /// - Name (1 line, ellipsis)
  /// - Location (icon + text, 1 line)
  /// - Divider
  /// - Button "Book" (gradient biru)
  /// 
  /// Responsif untuk HP kecil (< 360px) dengan ukuran lebih kecil
  Widget _buildDestinationCard(Map<String, dynamic> destination, bool isMobile) {
    // LayoutBuilder = Widget yang memberikan constraints (ukuran tersedia)
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = MediaQuery.of(context).size.width;

        // --- DETEKSI HP KECIL ---
        // HP kecil: Pixel 4, iPhone SE, Redmi 4X, dll (< 360px)
        final bool isSmallPhone = screenWidth < 360;

        // --- LEBAR CARD ---
        // HP kecil: 62% dari lebar tersedia (diperkecil agresif)
        // Mobile biasa: 80% dari lebar tersedia
        // Desktop: Fixed 280px
        final double cardWidth = isSmallPhone
            ? constraints.maxWidth * 0.62   // Lebih kecil untuk HP kecil
            : (isMobile ? constraints.maxWidth * 0.80 : 280);

        // GestureDetector = Deteksi tap untuk navigasi ke detail
        return GestureDetector(
          onTap: () => _showDetailModal(destination), // Buka detail screen
          
          // CONTAINER CARD
          child: Container(
            width: cardWidth,
            margin: const EdgeInsets.only(right: 16, bottom: 12), // Spacing
            
            decoration: BoxDecoration(
              color: Colors.white, // Background putih
              borderRadius: BorderRadius.circular(24), // Rounded corner
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.08), // Shadow biru muda
                  blurRadius: 20,
                  offset: const Offset(0, 8), // Shadow ke bawah
                ),
              ],
            ),

            // COLUMN = Layout vertikal (image + content)
            child: Column(
              mainAxisSize: MainAxisSize.min, // Tinggi sesuai konten
              children: [

                // ========== IMAGE ==========
                // Image dengan ClipRRect untuk rounded corner
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: AspectRatio(
                    aspectRatio: 16 / 10, // Rasio 16:10 (landscape)
                    child: Image.asset(
                      destination['image'], // Path gambar
                      fit: BoxFit.cover, // Cover full tanpa distorsi
                    ),
                  ),
                ),

                // ========== CONTENT ==========
                Padding(
                  padding: const EdgeInsets.all(10), // Padding dalam card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align kiri
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // --- NAME ---
                      Text(
                        destination['name'], // Nama destinasi
                        maxLines: 1, // Maksimal 1 baris
                        overflow: TextOverflow.ellipsis, // Tambah "..." jika panjang
                        style: TextStyle(
                          fontSize: isSmallPhone ? 12.5 : 15, // Font responsif
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // --- LOCATION ---
                      Row(
                        children: [
                          // Icon pin lokasi
                          const Icon(
                            Icons.location_on_rounded,
                            size: 13,
                            color: Color(0xFF1E88E5), // Biru
                          ),
                          const SizedBox(width: 4),
                          
                          // Text lokasi
                          Expanded(
                            child: Text(
                              destination['location'], // Contoh: "Kuta, Bali"
                              overflow: TextOverflow.ellipsis, // Ellipsis jika panjang
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: isSmallPhone ? 10.5 : 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      
                      // --- DIVIDER ---
                      Divider(color: Colors.grey[200], height: 1),

                      // ========== BUTTON "BOOK" ==========
                      Container(
                        width: double.infinity, // Full width
                        margin: const EdgeInsets.only(top: 8),
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallPhone ? 8 : 11, // Padding responsif
                        ),
                        
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1E88E5), // Biru medium
                              Color(0xFF1565C0), // Biru gelap
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        
                        // TEXT "Book"
                        child: Center(
                          child: Text(
                            'Book',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallPhone ? 12.5 : 14, // Font responsif
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// SHOW DETAIL MODAL - Navigasi ke halaman detail destinasi
  /// Dipanggil saat: User klik card destinasi
  /// Fungsi: Push ke ProductDetailScreen dengan data destinasi
  void _showDetailModal(Map<String, dynamic> destination) {
    // Navigator.push = Navigasi ke halaman baru
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          destination: destination, // Pass data destinasi ke detail screen
        ),
      ),
    );
  }

  /// BUILD EMPTY STATE - UI saat tidak ada destinasi yang cocok dengan filter
  /// Letak di UI: Tengah layar (menggantikan grid)
  /// Ditampilkan saat: List destinasi kosong setelah filter
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0), // Padding besar
        child: Column(
          children: [
            // ICON CONTAINER - Lingkaran biru dengan icon explore off
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1E88E5).withOpacity(0.1), // Biru muda
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.explore_off_rounded, // Icon explore off
                size: 80,
                color: Color(0xFF1E88E5),
              ),
            ),
            const SizedBox(height: 24),
            
            // TITLE
            const Text(
              'Tidak Ada Destinasi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // MESSAGE
            Text(
              'Tidak ada destinasi untuk filter ini.\nCoba filter lainnya!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// GET CROSS AXIS COUNT - Hitung jumlah kolom grid berdasarkan lebar layar
  /// Parameter: width = lebar layar dalam pixel
  /// Return: jumlah kolom (2-5)
  /// 
  /// Breakpoints:
  /// - < 600px (Mobile): 2 kolom
  /// - 600-899px (Tablet): 3 kolom
  /// - 900-1199px (Desktop): 4 kolom
  /// - >= 1200px (Large Desktop): 5 kolom
  int _getCrossAxisCount(double width) {
    if (width < 600) return 2;        // Mobile
    if (width < 900) return 3;        // Tablet
    if (width < 1200) return 4;       // Desktop
    return 5;                         // Large Desktop
  }
}

/// ============================================================================
/// 🎨 GEOMETRIC PATTERN PAINTER - Custom painter untuk pattern background
/// ============================================================================
/// Class ini digunakan untuk menggambar pattern geometris di hero image
/// Pattern: Diagonal lines + circles dengan opacity rendah (dekorasi)

class GeometricPatternPainter extends CustomPainter {
  final bool isMobile; // Flag untuk responsive spacing
  
  GeometricPatternPainter({required this.isMobile});
  
  /// PAINT - Fungsi untuk menggambar pattern di canvas
  /// Dipanggil otomatis oleh Flutter saat widget perlu dirender
  @override
  void paint(Canvas canvas, Size size) {
    
    // ========== DIAGONAL LINES ==========
    // Setup paint untuk garis diagonal
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05) // Putih 5% (sangat transparan)
      ..style = PaintingStyle.stroke // Stroke (outline), bukan fill
      ..strokeWidth = 1.5; // Lebar garis
    
    // Spacing antar garis: 40px di mobile, 60px di desktop
    final spacing = isMobile ? 40.0 : 60.0;
    
    // Loop untuk menggambar garis diagonal dari kiri atas ke kanan bawah
    // Start dari luar layar (negatif) agar garis terlihat dari pojok
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),                     // Start point (atas)
        Offset(i + size.height, size.height), // End point (bawah kanan)
        paint,
      );
    }
    
    // ========== CIRCLES ==========
    // Setup paint untuk lingkaran
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.03) // Putih 3% (lebih transparan)
      ..style = PaintingStyle.fill; // Fill (solid), bukan outline
    
    // Lingkaran 1: Kanan tengah
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.3), // Posisi: 80% kanan, 30% atas
      isMobile ? 60 : 100, // Radius: 60px di mobile, 100px di desktop
      circlePaint,
    );
    
    // Lingkaran 2: Kiri bawah
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.7), // Posisi: 20% kanan, 70% atas
      isMobile ? 40 : 70, // Radius: 40px di mobile, 70px di desktop
      circlePaint,
    );
  }
  
  /// SHOULD REPAINT - Tentukan apakah perlu repaint saat rebuild
  /// Return false = tidak perlu repaint (pattern static)
  /// Ini untuk optimasi performa (tidak repaint setiap frame)
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================================================
/// 📝 RINGKASAN ALUR SCREEN INI:
/// ============================================================================
/// 
/// 1. USER MASUK SCREEN (dari home, klik kategori)
///    ├─ initState() dipanggil
///    ├─ _initializeData(): Load data destinasi dari map berdasarkan kategori
///    ├─ _initializeAnimations(): Setup fade & stagger animation
///    └─ build() render UI pertama kali
/// 
/// 2. UI DIRENDER (dari atas ke bawah)
///    ├─ SliverAppBar (collapsing hero header)
///    │  ├─ Back button (kiri atas)
///    │  ├─ Search & Filter button (kanan atas, badge jika filter aktif)
///    │  └─ Hero Image (gradient + pattern + content)
///    │     ├─ Background: Gradient biru 4 stops
///    │     ├─ Pattern: Diagonal lines + circles (CustomPainter)
///    │     ├─ Gradient overlay: Hitam -> transparan -> putih
///    │     ├─ Dekorasi: 2 lingkaran gradient besar (kanan atas, kiri bawah)
///    │     ├─ Icon dekorasi: Explore icon besar transparan
///    │     └─ Content: Badge Indonesia, Judul kategori, Subtitle (jumlah + Terpopuler)
///    │
///    ├─ Filter Section (fade in animation)
///    │  └─ 3 Filter Chips: All, Popular, New (dengan icon)
///    │     ├─ All: Grid icon, tampilkan semua destinasi
///    │     ├─ Popular: Fire icon, filter kategori = Popular
///    │     └─ New: Star icon, filter kategori = New
///    │
///    ├─ Destination Grid (atau Empty State)
///    │  ├─ Jika ada destinasi:
///    │  │  └─ Grid responsif (2-5 kolom tergantung lebar layar)
///    │  │     └─ Card destinasi (stagger animation)
///    │  │        ├─ Image (aspect ratio 16:10)
///    │  │        ├─ Name (bold, 1 line ellipsis)
///    │  │        ├─ Location (icon pin + text, 1 line ellipsis)
///    │  │        ├─ Divider
///    │  │        └─ Button "Book" (gradient biru)
///    │  │
///    │  └─ Jika tidak ada destinasi (setelah filter):
///    │     └─ Empty State (icon + text "Tidak Ada Destinasi")
///    │
///    └─ Bottom Spacing (agar card terakhir tidak tertutup)
/// 
/// 3. USER INTERAKSI
///    ├─ Klik Back → Navigator.pop() → kembali ke home
///    ├─ Klik Search → (belum ada fungsi)
///    ├─ Klik Filter → (belum ada fungsi, badge muncul jika filter aktif)
///    ├─ Klik Filter Chip (All/Popular/New) → _updateFilter()
///    │  ├─ Update _selectedFilter
///    │  ├─ Filter destinasi berdasarkan kategori
///    │  ├─ Reset & forward stagger animation (smooth transition)
///    │  └─ setState() → rebuild grid dengan data baru
///    └─ Klik Card Destinasi → _showDetailModal()
///       └─ Navigator.push() → ProductDetailScreen dengan data destinasi
/// 
/// 4. ANIMASI
///    ├─ Fade Animation (1 detik): Filter section fade in saat screen dibuka
///    ├─ Stagger Animation (1.2 detik): Card muncul berurutan dengan delay 0.1s
///    │  ├─ Card muncul dari bawah (offset Y: 50px → 0px)
///    │  ├─ Opacity: 0 → 1
///    │  └─ Curve: easeOutCubic (smooth deceleration)
///    └─ Filter Chip Animation (300ms): Smooth transition saat selected/unselected
///       ├─ Background: Grey → Gradient biru
///       ├─ Text color: Grey → Putih
///       └─ Shadow: None → Biru shadow
/// 
/// 5. RESPONSIVITAS
///    ├─ isMobile (< 600px):
///    │  ├─ Hero height: 220px
///    │  ├─ Grid: 2 kolom
///    │  ├─ Font sizes: Kecil
///    │  ├─ Spacing: Kecil (16px)
///    │  └─ Pattern spacing: 40px
///    │
///    ├─ isSmallPhone (< 360px):
///    │  ├─ Card width: 62% (lebih kecil)
///    │  ├─ Font sizes: Extra kecil
///    │  └─ Button padding: Lebih kecil
///    │
///    ├─ Tablet (600-899px):
///    │  ├─ Grid: 3 kolom
///    │  └─ Medium sizing
///    │
///    └─ Desktop (>= 900px):
///       ├─ Hero height: 280px
///       ├─ Grid: 4-5 kolom (tergantung lebar)
///       ├─ Font sizes: Besar
///       ├─ Spacing: Besar (24px)
///       └─ Pattern spacing: 60px
/// 
/// 6. OPTIMASI PERFORMA
///    ├─ Caching: _cachedDestinations & _cachedFilteredDestinations (hindari rebuild)
///    ├─ RepaintBoundary: Isolasi repaint per card (tidak spread ke widget lain)
///    ├─ shouldRepaint: false di CustomPainter (pattern tidak repaint setiap frame)
///    ├─ Conditional animation: AnimatedBuilder hanya saat stagger animation aktif
///    └─ Lazy loading: SliverGrid hanya render card yang visible di screen
/// 
/// ============================================================================