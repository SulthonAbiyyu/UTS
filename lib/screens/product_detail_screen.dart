import 'package:flutter/material.dart';

/// ============================================================================
/// 🎨 PRODUCT DETAIL SCREEN - MODERN RESPONSIVE UI
/// ============================================================================
/// Screen ini menampilkan detail lengkap dari destinasi wisata yang dipilih
/// Terletak di: Halaman kedua setelah user klik card destinasi di home screen
/// Fitur utama: 
/// - Image gallery dengan swipe (geser gambar)
/// - Info lengkap destinasi (rating, lokasi, harga, fasilitas)
/// - Animasi smooth saat masuk halaman
/// - Tombol booking yang floating di bawah
/// ============================================================================

class ProductDetailScreen extends StatefulWidget {
  // Parameter 'destination' berisi semua data destinasi yang diklik
  // Contoh isi: {name: "Pantai Kuta", price: "Rp 150.000", rating: 4.8, dll}
  final Map<String, dynamic> destination;

  const ProductDetailScreen({
    Key? key,
    required this.destination,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

/// STATE CLASS - Mengatur semua behavior dan interaksi di screen ini
/// SingleTickerProviderStateMixin = Dibutuhkan untuk animasi
class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  
  // ========== CONTROLLER & ANIMATION ==========
  // AnimationController = Mengontrol durasi dan timing animasi
  late AnimationController _animationController;
  
  // Animation fade = Efek muncul perlahan (opacity 0 -> 1)
  // Digunakan di: Konten utama (deskripsi, fasilitas, tips)
  late Animation<double> _fadeAnimation;
  
  // Animation slide = Efek geser dari bawah ke atas
  // Digunakan di: Konten utama untuk efek smooth entrance
  late Animation<Offset> _slideAnimation;
  
  // ScrollController = Mendeteksi posisi scroll user
  // Digunakan untuk: Munculkan/sembunyikan title di AppBar saat scroll
  final ScrollController _scrollController = ScrollController();
  
  // Flag untuk show/hide title di AppBar
  // false = title disembunyikan, true = title ditampilkan
  bool _showTitle = false;
  
  // Index gambar yang sedang ditampilkan di gallery (mulai dari 0)
  // Contoh: 0 = gambar pertama, 1 = gambar kedua, dst
  int _selectedImageIndex = 0;

  /// INIT STATE - Fungsi pertama yang dijalankan saat screen dibuka
  @override
  void initState() {
    super.initState();
    _initializeAnimations(); // Setup semua animasi
    _setupScrollListener(); // Setup listener untuk scroll
  }

  /// INITIALIZE ANIMATIONS - Setup semua animasi yang akan digunakan
  /// Dijalankan sekali saat screen pertama kali dibuka
  void _initializeAnimations() {
    // Buat animation controller dengan durasi 800ms (0.8 detik)
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this, // Sinkronisasi dengan refresh rate layar
    );

    // Fade Animation: Opacity berubah dari 0 (transparan) ke 1 (solid)
    // Curve easeInOut = Mulai lambat, cepat di tengah, lambat lagi di akhir
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Slide Animation: Posisi berubah dari bawah (0, 0.3) ke normal (0, 0)
    // Offset(0, 0.3) = 30% dari tinggi layar ke bawah
    // Curve easeOutCubic = Mulai cepat, melambat di akhir (natural bouncing)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // Mulai dari 30% di bawah posisi normal
      end: Offset.zero, // Berakhir di posisi normal
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Mulai animasi (forward = 0 ke 1)
    _animationController.forward();
  }

  /// SETUP SCROLL LISTENER - Deteksi posisi scroll untuk show/hide title
  /// Cara kerja: Jika scroll > 200px, tampilkan title. Jika < 200px, sembunyikan
  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Jika scroll sudah lebih dari 200px dan title masih hidden
      if (_scrollController.offset > 200 && !_showTitle) {
        setState(() => _showTitle = true); // Tampilkan title
      } 
      // Jika scroll kurang dari 200px dan title masih visible
      else if (_scrollController.offset <= 200 && _showTitle) {
        setState(() => _showTitle = false); // Sembunyikan title
      }
    });
  }

  /// DISPOSE - Bersihkan memory saat screen ditutup
  /// Penting untuk mencegah memory leak!
  @override
  void dispose() {
    _animationController.dispose(); // Hentikan animasi
    _scrollController.dispose(); // Hentikan listener
    super.dispose();
  }

  /// GET IMAGE GALLERY - Ambil list gambar untuk ditampilkan
  /// Return: List berisi path gambar (gambar pertama dari data, sisanya default)
  /// Digunakan di: PageView untuk swipe gallery
  List<String> _getImageGallery() {
    return [
      widget.destination['image'], // Gambar utama dari data destinasi
      'assets/images/bali.jpg', // Gambar tambahan 1
      'assets/images/jogja.jpg', // Gambar tambahan 2
      'assets/images/ntb.jpg', // Gambar tambahan 3
      'assets/images/jawatimur.jpg', // Gambar tambahan 4
    ];
  }

  /// BUILD - Fungsi utama untuk render UI
  /// Dipanggil setiap kali ada perubahan state (setState)
  @override
  Widget build(BuildContext context) {
    // Ambil ukuran layar device
    final size = MediaQuery.of(context).size;
    
    // Tentukan jenis device berdasarkan lebar layar
    final isDesktop = size.width >= 1200; // Desktop: >= 1200px
    final isTablet = size.width >= 768 && size.width < 1200; // Tablet: 768-1199px
    final isMobile = size.width < 768; // Mobile: < 768px
    final isSmallMobile = size.width < 375; // Small Mobile: < 375px (iPhone SE, dll)

    // SCAFFOLD = Struktur dasar halaman Flutter
    return Scaffold(
      backgroundColor: Colors.white, // Background putih bersih
      
      // STACK = Widget yang menumpuk widget di atas widget lain (layering)
      // Digunakan untuk: Floating button di atas konten scrollable
      body: Stack(
        children: [
          // Layer 1: Konten yang bisa di-scroll (gambar + detail)
          CustomScrollView(
            controller: _scrollController, // Terhubung ke scroll listener
            physics: const BouncingScrollPhysics(), // Efek bouncing iOS style
            slivers: [
              // Sliver 1: AppBar dengan gambar besar (collapsing)
              _buildSliverAppBar(isDesktop, isTablet, isMobile, isSmallMobile),
              
              // Sliver 2: Konten utama (deskripsi, fasilitas, tips)
              SliverToBoxAdapter(
                child: _buildMainContent(isDesktop, isTablet, isMobile, isSmallMobile),
              ),
            ],
          ),
          
          // Layer 2: Floating Action Bar di bawah (harga + tombol booking)
          // Ini akan selalu terlihat di bawah meskipun user scroll
          _buildFloatingActionBar(isDesktop, isTablet, isMobile, isSmallMobile),
        ],
      ),
    );
  }

  /// BUILD SLIVER APP BAR - AppBar yang bisa collapse saat di-scroll
  /// Letak di UI: Paling atas halaman, berisi gambar besar + info destinasi
  /// Fitur: 
  /// - Gambar besar yang mengecil saat scroll
  /// - Title muncul/hilang otomatis saat scroll
  /// - Tombol back, favorite, share
  Widget _buildSliverAppBar(bool isDesktop, bool isTablet, bool isMobile, bool isSmallMobile) {
    // Tentukan tinggi AppBar berdasarkan device
    // Desktop = 500px, Tablet = 400px, Small Mobile = 280px, Mobile = 350px
    final height = isDesktop ? 500.0 : isTablet ? 400.0 : isSmallMobile ? 280.0 : 350.0;

    return SliverAppBar(
      expandedHeight: height, // Tinggi maksimal saat belum di-scroll
      floating: false, // false = tidak muncul saat scroll ke bawah
      pinned: true, // true = tetap terlihat (collapsed) saat scroll
      stretch: true, // Efek stretch saat over-scroll (pull down)
      backgroundColor: Colors.white, // Background AppBar putih
      elevation: 0, // Hilangkan shadow
      
      // Tombol back kustom (kiri atas)
      leading: _buildBackButton(),
      
      // Tombol aksi (kanan atas): favorite & share
      actions: [
        // Tombol favorite (love icon)
        _buildIconButton(Icons.favorite_border, () {
          // Tampilkan notifikasi SnackBar saat diklik
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ditambahkan ke Favorit!'),
              backgroundColor: Color(0xFF1E88E5), // Biru
              duration: Duration(seconds: 2),
            ),
          );
        }),
        const SizedBox(width: 8), // Spacing
        
        // Tombol share (share icon)
        _buildIconButton(Icons.share_rounded, () {
          // Tampilkan notifikasi SnackBar saat diklik
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bagikan Destinasi'),
              backgroundColor: Color(0xFF1E88E5),
              duration: Duration(seconds: 2),
            ),
          );
        }),
        const SizedBox(width: 16), // Spacing kanan
      ],
      
      // FLEXIBLE SPACE BAR = Area yang berubah saat scroll (gambar + title)
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false, // Title di kiri, bukan di tengah
        
        // Padding title agar tidak tertutup tombol back
        titlePadding: EdgeInsets.only(
          left: isMobile ? 56 : 72, // Jarak dari kiri (lewati tombol back)
          bottom: 16, // Jarak dari bawah
        ),
        
        // TITLE - Nama destinasi yang muncul saat scroll
        // Muncul saat _showTitle = true (scroll > 200px)
        title: AnimatedOpacity(
          opacity: _showTitle ? 1.0 : 0.0, // 1 = terlihat, 0 = transparan
          duration: const Duration(milliseconds: 300), // Durasi fade in/out
          child: Text(
            widget.destination['name'], // Nama destinasi dari data
            style: TextStyle(
              color: const Color(0xFF1E88E5), // Warna biru
              fontSize: isSmallMobile ? 14 : 18, // Ukuran font responsif
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // BACKGROUND - Gambar gallery full screen
        background: _buildImageGallery(isDesktop, isTablet, isMobile, isSmallMobile),
      ),
    );
  }

  /// BUILD BACK BUTTON - Tombol kembali kustom (kiri atas)
  /// Letak di UI: Pojok kiri atas, di atas gambar
  /// Styling: Lingkaran putih dengan shadow + icon biru
  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(8), // Jarak dari tepi
      decoration: BoxDecoration(
        color: Colors.white, // Background putih
        shape: BoxShape.circle, // Bentuk lingkaran
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow hitam 10% opacity
            blurRadius: 8, // Seberapa blur shadow-nya
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

  /// BUILD ICON BUTTON - Template tombol icon (favorite & share)
  /// Letak di UI: Kanan atas, di atas gambar
  /// Parameter:
  /// - icon: Icon yang ditampilkan
  /// - onPressed: Fungsi yang dijalankan saat diklik
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(8), // Jarak dari tepi
      decoration: BoxDecoration(
        color: Colors.white, // Background putih
        shape: BoxShape.circle, // Bentuk lingkaran
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow hitam 10% opacity
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF1E88E5), size: 22),
        onPressed: onPressed, // Jalankan fungsi yang dikirim sebagai parameter
      ),
    );
  }

  /// BUILD IMAGE GALLERY - Gallery gambar yang bisa di-swipe
  /// Letak di UI: Bagian atas halaman (di dalam SliverAppBar)
  /// Fitur:
  /// - Swipe left/right untuk ganti gambar
  /// - Gradient hitam di bawah untuk text overlay
  /// - Info rating, nama, lokasi di atas gambar
  /// - Dot indicator untuk posisi gambar
  Widget _buildImageGallery(bool isDesktop, bool isTablet, bool isMobile, bool isSmallMobile) {
    final images = _getImageGallery(); // Ambil list gambar

    // STACK = Layer gambar + gradient + text + dot indicator
    return Stack(
      fit: StackFit.expand, // Isi seluruh area yang tersedia
      children: [
        // Layer 1: PAGE VIEW - Gallery gambar yang bisa di-swipe
        PageView.builder(
          itemCount: images.length, // Jumlah gambar (5 gambar)
          
          // Callback saat gambar berganti (swipe)
          onPageChanged: (index) {
            setState(() => _selectedImageIndex = index); // Update index gambar aktif
          },
          
          // Builder untuk setiap gambar
          itemBuilder: (context, index) {
            return Image.asset(
              images[index], // Path gambar
              fit: BoxFit.cover, // Gambar full cover tanpa distorsi
              cacheWidth: isDesktop ? 1200 : 800, // Optimasi memory (resize otomatis)
              
              // Error handler jika gambar tidak ditemukan
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E88E5), Color(0xFF1565C0)], // Gradient biru
                    ),
                  ),
                  child: const Icon(
                    Icons.image_not_supported_rounded, // Icon gambar rusak
                    size: 80,
                    color: Colors.white54, // Putih transparan
                  ),
                );
              },
            );
          },
        ),
        
        // Layer 2: GRADIENT OVERLAY - Gradasi hitam di bawah untuk text overlay
        // Agar text putih tetap terbaca di atas gambar terang
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, // Mulai dari atas (transparan)
              end: Alignment.bottomCenter, // Ke bawah (hitam)
              colors: [
                Colors.transparent, // Atas: transparan
                Colors.black.withOpacity(0.7), // Bawah: hitam 70% opacity
              ],
            ),
          ),
        ),
        
        // Layer 3: TEXT OVERLAY - Info destinasi di atas gambar
        // Letak: Pojok kiri bawah
        Positioned(
          left: isDesktop ? 48 : isMobile ? 16 : 24, // Jarak dari kiri (responsif)
          right: isDesktop ? 48 : isMobile ? 16 : 24, // Jarak dari kanan
          bottom: isDesktop ? 40 : isMobile ? 24 : 32, // Jarak dari bawah
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align kiri
            children: [
              // RATING BADGE - Rating + jumlah review
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), // Putih semi-transparan
                  borderRadius: BorderRadius.circular(20), // Rounded pill shape
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Lebar sesuai konten
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: Colors.amber), // Bintang kuning
                    const SizedBox(width: 4),
                    
                    // Rating number (bold)
                    Text(
                      '${widget.destination['rating']}', // Contoh: 4.8
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    
                    // Jumlah review (grey)
                    Text(
                      ' (${widget.destination['reviews']} reviews)', // Contoh: (1234 reviews)
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // NAMA DESTINASI - Text besar putih
              Text(
                widget.destination['name'], // Contoh: "Pantai Kuta"
                style: TextStyle(
                  color: Colors.white,
                  // Font size responsif berdasarkan device
                  fontSize: isDesktop ? 40 : isTablet ? 32 : isSmallMobile ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2, // Line height
                ),
              ),
              
              const SizedBox(height: 8),
              
              // LOKASI - Icon pin + text lokasi
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.destination['location'], // Contoh: "Bali, Indonesia"
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9), // Putih sedikit transparan
                        fontSize: isSmallMobile ? 14 : 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Layer 4: DOT INDICATOR - Indikator posisi gambar (bawah tengah)
        // Contoh: • ● • • • (dot kedua aktif)
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center horizontal
            children: List.generate(images.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4), // Spacing antar dot
                // Lebar: 24px jika aktif, 8px jika tidak aktif
                width: _selectedImageIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  // Warna: Putih solid jika aktif, putih 50% jika tidak
                  color: _selectedImageIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4), // Rounded
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  /// BUILD MAIN CONTENT - Konten utama halaman (di bawah gambar)
  /// Letak di UI: Scroll area di bawah gambar
  /// Isi: Info cards, deskripsi, fasilitas, info penting, tips
  /// Fitur: Fade + slide animation saat halaman pertama kali dibuka
  Widget _buildMainContent(bool isDesktop, bool isTablet, bool isMobile, bool isSmallMobile) {
    // Wrap dengan FadeTransition untuk efek fade in
    return FadeTransition(
      opacity: _fadeAnimation, // Animasi opacity (0 -> 1)
      
      // Wrap dengan SlideTransition untuk efek slide up
      child: SlideTransition(
        position: _slideAnimation, // Animasi posisi (bawah -> normal)
        
        child: Container(
          // Batasi lebar maksimal di desktop (centered)
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 1200 : double.infinity,
          ),
          
          // Margin kiri-kanan responsif
          margin: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : isTablet ? 32 : isMobile ? 16 : 12,
          ),
          
          // Column = Layout vertikal (dari atas ke bawah)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align kiri
            children: [
              const SizedBox(height: 24), // Spacing atas
              
              // 1. INFO CARDS - 4 card info (durasi, lokasi, kategori, reviews)
              _buildInfoCards(isDesktop, isTablet, isMobile, isSmallMobile),
              
              const SizedBox(height: 32),
              
              // 2. DESKRIPSI
              _buildSectionTitle('Deskripsi', isSmallMobile), // Title section
              const SizedBox(height: 16),
              _buildDescription(isSmallMobile), // Konten deskripsi
              
              const SizedBox(height: 32),
              
              // 3. FASILITAS
              _buildSectionTitle('Fasilitas', isSmallMobile),
              const SizedBox(height: 16),
              _buildFacilities(isDesktop, isTablet, isMobile, isSmallMobile),
              
              const SizedBox(height: 32),
              
              // 4. INFORMASI PENTING
              _buildSectionTitle('Informasi Penting', isSmallMobile),
              const SizedBox(height: 16),
              _buildImportantInfo(isSmallMobile),
              
              const SizedBox(height: 32),
              
              // 5. TIPS & REKOMENDASI
              _buildSectionTitle('Tips & Rekomendasi', isSmallMobile),
              const SizedBox(height: 16),
              _buildTips(isSmallMobile),
              
              // Extra spacing di bawah agar tidak tertutup floating button
              SizedBox(height: isMobile ? 120 : 100),
            ],
          ),
        ),
      ),
    );
  }

  /// BUILD INFO CARDS - 4 kartu info (Durasi, Lokasi, Kategori, Reviews)
  /// Letak di UI: Tepat di bawah gambar gallery
  /// Layout: Grid 4 kolom di desktop, 3 di tablet, 2 di mobile
  Widget _buildInfoCards(bool isDesktop, bool isTablet, bool isMobile, bool isSmallMobile) {
    // LayoutBuilder = Widget yang memberikan constraints (ukuran tersedia)
    return LayoutBuilder(
      builder: (context, constraints) {
        // Tentukan jumlah kolom berdasarkan device
        final crossAxisCount = isDesktop ? 4 : isTablet ? 3 : 2;
        
        // WRAP = Layout yang otomatis pindah baris jika tidak muat
        // Mirip flexbox wrap di CSS
        return Wrap(
          spacing: isSmallMobile ? 8 : 8, // Spacing horizontal antar card
          runSpacing: isSmallMobile ? 8 : 8, // Spacing vertical antar baris
          children: [
            // Card 1: DURASI
            _buildInfoCard(
              Icons.access_time_rounded, // Icon jam
              'Durasi', // Label
              widget.destination['duration'] ?? '1 hari', // Value (default: 1 hari)
              constraints.maxWidth / crossAxisCount - (isSmallMobile ? 4 : 6), // Lebar card
              isSmallMobile,
            ),
            
            // Card 2: LOKASI
            _buildInfoCard(
              Icons.location_on_rounded, // Icon pin
              'Lokasi',
              widget.destination['location'].split(',').first, // Ambil bagian pertama sebelum koma
              constraints.maxWidth / crossAxisCount - (isSmallMobile ? 4 : 6),
              isSmallMobile,
            ),
            
            // Card 3: KATEGORI
            _buildInfoCard(
              Icons.category_rounded, // Icon kategori
              'Kategori',
              widget.destination['category'], // Contoh: "Beach", "Mountain"
              constraints.maxWidth / crossAxisCount - (isSmallMobile ? 4 : 6),
              isSmallMobile,
            ),
            
            // Card 4: REVIEWS
            _buildInfoCard(
              Icons.people_rounded, // Icon orang
              'Reviews',
              '${widget.destination['reviews']}+', // Contoh: "1234+"
              constraints.maxWidth / crossAxisCount - (isSmallMobile ? 4 : 6),
              isSmallMobile,
            ),
          ],
        );
      },
    );
  }

  /// BUILD INFO CARD - Template untuk satu kartu info
  /// Letak di UI: Bagian dari grid info cards di bawah gambar
  /// Struktur: Icon di atas (gradient biru) + Label + Value
  Widget _buildInfoCard(IconData icon, String label, String value, double width, bool isSmallMobile) {
    return Container(
      width: width, // Lebar dihitung dari parent
      padding: EdgeInsets.all(isSmallMobile ? 12 : 16), // Padding dalam card
      
      decoration: BoxDecoration(
        color: const Color(0xFF1E88E5).withOpacity(0.05), // Background biru muda
        borderRadius: BorderRadius.circular(16), // Rounded corner
        border: Border.all(
          color: const Color(0xFF1E88E5).withOpacity(0.1), // Border biru transparan
          width: 1,
        ),
      ),
      
      child: Column(
        children: [
          // ICON CONTAINER - Box gradient biru dengan icon putih
          Container(
            padding: EdgeInsets.all(isSmallMobile ? 8 : 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF1565C0)], // Gradient biru
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: isSmallMobile ? 20 : 24),
          ),
          
          SizedBox(height: isSmallMobile ? 8 : 12),
          
          // LABEL - Text kecil grey (contoh: "Durasi")
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallMobile ? 11 : 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // VALUE - Text besar bold biru (contoh: "1 hari")
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallMobile ? 13 : 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E88E5),
            ),
            maxLines: 1, // Maksimal 1 baris
            overflow: TextOverflow.ellipsis, // Tambah "..." jika terlalu panjang
          ),
        ],
      ),
    );
  }

  /// BUILD SECTION TITLE - Template judul section (Deskripsi, Fasilitas, dll)
  /// Letak di UI: Sebelum setiap section konten
  /// Styling: Text hitam bold ukuran besar
  Widget _buildSectionTitle(String title, bool isSmallMobile) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isSmallMobile ? 20 : 24, // Responsif
        fontWeight: FontWeight.bold,
        color: Colors.black87, // Hitam sedikit soft
      ),
    );
  }

  /// BUILD DESCRIPTION - Box deskripsi destinasi
  /// Letak di UI: Section pertama setelah info cards
  /// Styling: Box abu-abu dengan border, berisi text deskripsi panjang
  Widget _buildDescription(bool isSmallMobile) {
    return Container(
      padding: EdgeInsets.all(isSmallMobile ? 16 : 20), // Padding dalam box
      
      decoration: BoxDecoration(
        color: Colors.grey[50], // Background abu-abu muda
        borderRadius: BorderRadius.circular(20), // Rounded corner
        border: Border.all(
          color: Colors.grey[200]!, // Border abu-abu
          width: 1,
        ),
      ),
      
      // TEXT DESKRIPSI dari data destinasi
      child: Text(
        widget.destination['description'], // Deskripsi panjang destinasi
        style: TextStyle(
          fontSize: isSmallMobile ? 14 : 16, // Responsif
          color: Colors.grey[700], // Grey medium untuk text body
          height: 1.8, // Line height (spacing antar baris)
        ),
      ),
    );
  }

  /// BUILD FACILITIES - List badge fasilitas (Parking, Restaurant, dll)
  /// Letak di UI: Section kedua setelah deskripsi
  /// Layout: Wrap (otomatis pindah baris), badge gradient biru dengan icon
  Widget _buildFacilities(bool isDesktop, bool isTablet, bool isMobile, bool isSmallMobile) {
    // Ambil list fasilitas dari data destinasi
    // Contoh: ["Parking", "Restaurant", "Beach Club", "Surfing"]
    final facilities = widget.destination['facilities'] as List<dynamic>;
    
    // WRAP = Layout yang otomatis pindah baris jika tidak muat
    return Wrap(
      spacing: isSmallMobile ? 8 : 12, // Spacing horizontal
      runSpacing: isSmallMobile ? 8 : 12, // Spacing vertical
      
      // Loop setiap fasilitas dan buat badge
      children: facilities.map((facility) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallMobile ? 14 : 18, // Padding kiri-kanan
            vertical: isSmallMobile ? 10 : 12, // Padding atas-bawah
          ),
          
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E88E5), Color(0xFF1565C0)], // Gradient biru
            ),
            borderRadius: BorderRadius.circular(20), // Rounded pill shape
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E88E5).withOpacity(0.3), // Shadow biru
                blurRadius: 8,
                offset: const Offset(0, 4), // Shadow ke bawah
              ),
            ],
          ),
          
          // ROW = Icon + Text horizontal
          child: Row(
            mainAxisSize: MainAxisSize.min, // Lebar sesuai konten
            children: [
              // ICON - Diambil dari fungsi helper berdasarkan nama fasilitas
              Icon(
                _getFacilityIcon(facility.toString()), // Mapping nama -> icon
                color: Colors.white,
                size: isSmallMobile ? 16 : 18,
              ),
              SizedBox(width: isSmallMobile ? 6 : 8),
              
              // TEXT - Nama fasilitas
              Text(
                facility.toString(), // Contoh: "Parking"
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: isSmallMobile ? 12 : 14,
                ),
              ),
            ],
          ),
        );
      }).toList(), // Convert Iterable ke List
    );
  }

  /// GET FACILITY ICON - Helper function untuk mapping nama fasilitas ke icon
  /// Input: String nama fasilitas (contoh: "parking")
  /// Output: IconData yang sesuai (contoh: Icons.local_parking_rounded)
  /// Fungsi: Agar setiap fasilitas punya icon yang relevan
  IconData _getFacilityIcon(String facility) {
    // Switch case berdasarkan nama fasilitas (lowercase)
    switch (facility.toLowerCase()) {
      case 'parking':
        return Icons.local_parking_rounded; // Icon P
      case 'restaurant':
        return Icons.restaurant_rounded; // Icon garpu sendok
      case 'beach club':
        return Icons.beach_access_rounded; // Icon payung pantai
      case 'surfing':
        return Icons.surfing_rounded; // Icon selancar
      case 'guide':
        return Icons.person_rounded; // Icon orang
      case 'photo spot':
        return Icons.photo_camera_rounded; // Icon kamera
      case 'souvenir shop':
        return Icons.shopping_bag_rounded; // Icon tas belanja
      case 'cafe':
        return Icons.local_cafe_rounded; // Icon kopi
      case 'museum':
        return Icons.museum_rounded; // Icon museum
      case 'shopping':
        return Icons.shopping_cart_rounded; // Icon keranjang
      case 'food court':
        return Icons.fastfood_rounded; // Icon burger
      case 'street art':
        return Icons.palette_rounded; // Icon palet cat
      case 'camping':
       return Icons.forest_rounded; // Icon pohon
      case 'porter':
        return Icons.hiking_rounded; // Icon hiking
      case 'sunrise point':
        return Icons.wb_sunny_rounded; // Icon matahari
      case 'diving':
        return Icons.scuba_diving_rounded; // Icon diving
      case 'cycling':
        return Icons.pedal_bike_rounded; // Icon sepeda
      case 'jeep':
        return Icons.directions_car_rounded; // Icon mobil
      case 'gas mask':
        return Icons.masks_rounded; // Icon masker
      default:
        return Icons.check_circle_rounded; // Icon default (checkmark)
    }
  }

  /// BUILD IMPORTANT INFO - Box info penting (jam buka, aturan, dll)
  /// Letak di UI: Section ketiga setelah fasilitas
  /// Styling: Box kuning dengan border, icon info, list checkmark
  Widget _buildImportantInfo(bool isSmallMobile) {
    return Container(
      padding: EdgeInsets.all(isSmallMobile ? 16 : 20), // Padding dalam box
      
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1), // Background kuning muda
        borderRadius: BorderRadius.circular(20), // Rounded corner
        border: Border.all(
          color: Colors.amber.withOpacity(0.3), // Border kuning
          width: 1.5,
        ),
      ),
      
      child: Column(
        children: [
          // HEADER - Icon info + title
          Row(
            children: [
              // ICON INFO dalam box kuning
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber, // Background kuning solid
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.info_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              
              // TITLE
              Expanded(
                child: Text(
                  'Informasi Penting',
                  style: TextStyle(
                    fontSize: isSmallMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[900], // Kuning tua
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // LIST INFO ITEMS - Setiap item dengan icon checkmark
          _buildInfoItem('Buka setiap hari: 06.00 - 18.00 WIB', isSmallMobile),
          _buildInfoItem('Harga paket tour sudah termasuk transport & tiket masuk', isSmallMobile),
          _buildInfoItem('Disarankan tiba lebih pagi untuk menikmati sunrise dan briefing awal', isSmallMobile),
          _buildInfoItem('Bawa jaket atau pakaian hangat karena suhu pagi cenderung dingin', isSmallMobile),
          _buildInfoItem('Mohon mengikuti instruksi tour guide selama kegiatan berlangsung', isSmallMobile),
        ],
      ),
    );
  }

  /// BUILD INFO ITEM - Template satu baris info dengan checkmark
  /// Letak di UI: Bagian dari list di dalam box info penting
  /// Struktur: Icon check kuning + Text info
  Widget _buildInfoItem(String text, bool isSmallMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8), // Spacing antar item
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align ke atas (untuk text panjang)
        children: [
          // ICON CHECKMARK kuning
          Icon(
            Icons.check_circle,
            color: Colors.amber[700], // Kuning medium
            size: isSmallMobile ? 18 : 20,
          ),
          const SizedBox(width: 12),
          
          // TEXT INFO - Bisa multi-line
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isSmallMobile ? 13 : 15,
                color: Colors.grey[800], // Grey gelap
                height: 1.5, // Line height
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// BUILD TIPS - List tips & rekomendasi untuk wisatawan
  /// Letak di UI: Section terakhir sebelum footer
  /// Styling: List box biru muda dengan icon lampu
  Widget _buildTips(bool isSmallMobile) {
    // List tips hardcoded (bisa diganti dengan data dari backend)
    final tips = [
      'Datang lebih awal untuk mengikuti briefing dan pembagian kelompok',
      'Bawa air minum dan snack secukupnya agar tetap bertenaga selama tour',
      'Gunakan sunscreen dan pakaian nyaman untuk mendukung aktivitas outdoor',
      'Siapkan kamera untuk mengabadikan momen terbaik selama perjalanan',
      'Gunakan alas kaki yang nyaman, terutama untuk area yang membutuhkan banyak berjalan kaki',
      'Pastikan baterai gadget terisi penuh atau bawa powerbank',
    ];

    // COLUMN = Layout vertikal (tips ditumpuk dari atas ke bawah)
    return Column(
      children: tips.map((tip) {
        // Setiap tip dibungkus dalam container box
        return Container(
          margin: const EdgeInsets.only(bottom: 12), // Spacing antar box
          padding: EdgeInsets.all(isSmallMobile ? 14 : 16), // Padding dalam box
          
          decoration: BoxDecoration(
            color: const Color(0xFF1E88E5).withOpacity(0.05), // Background biru muda
            borderRadius: BorderRadius.circular(16), // Rounded corner
            border: Border.all(
              color: const Color(0xFF1E88E5).withOpacity(0.2), // Border biru
              width: 1,
            ),
          ),
          
          // ROW = Icon lampu + Text tip horizontal
          child: Row(
            children: [
              // ICON LAMPU dalam box biru (ide/tips)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E88E5), // Background biru solid
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              
              // TEXT TIP - Bisa multi-line
              Expanded(
                child: Text(
                  tip,
                  style: TextStyle(
                    fontSize: isSmallMobile ? 13 : 15,
                    color: Colors.grey[800], // Grey gelap
                    height: 1.5, // Line height
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(), // Convert Iterable ke List
    );
  }

  /// BUILD FLOATING ACTION BAR - Bar bawah dengan harga + tombol booking
  /// Letak di UI: Fixed di bawah layar (tidak ikut scroll)
  /// Fitur: Menampilkan harga + tombol Book Now yang selalu terlihat
  /// Posisi: Layer paling atas (di Stack), sehingga selalu terlihat
  Widget _buildFloatingActionBar(bool isDesktop, bool isTablet, bool isMobile, bool isSmallMobile) {
    // POSITIONED = Widget yang bisa diletakkan di posisi spesifik dalam Stack
    return Positioned(
      left: 0, // Full width dari kiri
      right: 0, // Full width ke kanan
      bottom: 0, // Menempel di bawah layar
      
      child: Container(
        padding: EdgeInsets.all(isSmallMobile ? 12 : 16), // Padding dalam bar
        
        decoration: BoxDecoration(
          color: Colors.white, // Background putih
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow hitam
              blurRadius: 20, // Blur besar untuk soft shadow
              offset: const Offset(0, -5), // Shadow ke atas (negatif)
            ),
          ],
        ),
        
        // SafeArea = Hindari notch/home indicator di iPhone
        child: SafeArea(
          child: Row(
            children: [
              // BAGIAN KIRI - Info Harga (flex 2 di desktop, 1 di mobile)
              Expanded(
                flex: isDesktop ? 2 : 1, // Proporsi lebar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align kiri
                  mainAxisSize: MainAxisSize.min, // Tinggi sesuai konten
                  children: [
                    // Label "Harga Tiket"
                    Text(
                      'Harga Tiket',
                      style: TextStyle(
                        fontSize: isSmallMobile ? 11 : 13,
                        color: Colors.grey[600], // Grey medium
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // HARGA - Text besar bold biru
                    Text(
                      widget.destination['price'], // Contoh: "Rp 150.000"
                      style: TextStyle(
                        fontSize: isSmallMobile ? 20 : isDesktop ? 28 : 24, // Responsif
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E88E5), // Biru
                      ),
                    ),
                    
                    // Label "per orang"
                    Text(
                      'per orang',
                      style: TextStyle(
                        fontSize: isSmallMobile ? 10 : 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: isSmallMobile ? 12 : 16), // Spacing tengah
              
              // BAGIAN KANAN - Tombol Book Now (flex 3 di desktop, 2 di mobile)
              Expanded(
                flex: isDesktop ? 3 : 2, // Proporsi lebar
                child: ElevatedButton(
                  onPressed: () {
                    _showBookingDialog(); // Panggil dialog booking
                  },
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5), // Background biru
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallMobile ? 14 : 18, // Padding vertikal
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Rounded corner
                    ),
                    elevation: 4, // Tinggi shadow
                    shadowColor: const Color(0xFF1E88E5).withOpacity(0.5), // Shadow biru
                  ),
                  
                  // ROW = Icon + Text horizontal
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center horizontal
                    children: [
                      const Icon(Icons.event_available_rounded, size: 24), // Icon kalender
                      SizedBox(width: isSmallMobile ? 6 : 12),
                      Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: isSmallMobile ? 15 : 18, // Responsif
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5, // Spacing antar huruf
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// SHOW BOOKING DIALOG - Tampilkan dialog konfirmasi booking
  /// Dipanggil saat: User klik tombol "Book Now"
  /// Fungsi: Menampilkan popup sukses booking dengan 2 tombol (Tutup & Lihat Pesanan)
  void _showBookingDialog() {
    // showDialog = Fungsi Flutter untuk menampilkan popup modal
    showDialog(
      context: context, // Context dari screen ini
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Rounded corner dialog
        ),
        contentPadding: const EdgeInsets.all(24), // Padding dalam dialog
        
        // CONTENT DIALOG
        content: Column(
          mainAxisSize: MainAxisSize.min, // Tinggi sesuai konten
          children: [
            // ICON SUCCESS - Checkmark dalam lingkaran gradient biru
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF1565C0)], // Gradient biru
                ),
                shape: BoxShape.circle, // Bentuk lingkaran
              ),
              child: const Icon(
                Icons.check_circle_rounded, // Icon checkmark
                size: 60,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // TITLE - "Booking Berhasil!"
            const Text(
              'Booking Berhasil!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // MESSAGE - Konfirmasi dengan nama destinasi
            Text(
              'Anda berhasil melakukan booking untuk\n${widget.destination['name']}',
              textAlign: TextAlign.center, // Center text
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700], // Grey medium
                height: 1.5, // Line height
              ),
            ),
            
            const SizedBox(height: 24),
            
            // BUTTONS - 2 tombol horizontal (Tutup & Lihat Pesanan)
            Row(
              children: [
                // TOMBOL TUTUP (Outline button)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context), // Tutup dialog
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFF1E88E5), width: 2), // Border biru
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        color: Color(0xFF1E88E5), // Text biru
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12), // Spacing antar tombol
                
                // TOMBOL LIHAT PESANAN (Filled button)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.pop(context); // Kembali ke halaman sebelumnya (home)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5), // Background biru
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Lihat Pesanan',
                      style: TextStyle(
                        color: Colors.white, // Text putih
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// 📝 RINGKASAN ALUR SCREEN INI:
/// ============================================================================
/// 
/// 1. USER MASUK SCREEN
///    ├─ initState() dipanggil
///    ├─ Setup animasi (fade + slide)
///    ├─ Setup scroll listener (untuk title di AppBar)
///    └─ build() render UI pertama kali
/// 
/// 2. UI DIRENDER (dari atas ke bawah)
///    ├─ SliverAppBar (collapsing header)
///    │  ├─ Back button (kiri atas)
///    │  ├─ Favorite & Share button (kanan atas)
///    │  ├─ Image Gallery (swipeable, 5 gambar)
///    │  │  ├─ Gradient overlay (hitam di bawah)
///    │  │  ├─ Rating badge (putih, pojok kiri bawah)
///    │  │  ├─ Nama destinasi (text putih besar)
///    │  │  ├─ Lokasi (icon pin + text)
///    │  │  └─ Dot indicator (posisi gambar)
///    │  └─ Title (muncul saat scroll > 200px)
///    │
///    ├─ Main Content (scroll area)
///    │  ├─ Info Cards (4 card: Durasi, Lokasi, Kategori, Reviews)
///    │  ├─ Deskripsi (box abu-abu dengan text panjang)
///    │  ├─ Fasilitas (badge biru dengan icon)
///    │  ├─ Informasi Penting (box kuning dengan list checkmark)
///    │  └─ Tips & Rekomendasi (box biru dengan icon lampu)
///    │
///    └─ Floating Action Bar (fixed di bawah)
///       ├─ Harga (kiri)
///       └─ Tombol Book Now (kanan)
/// 
/// 3. USER INTERAKSI
///    ├─ Swipe gambar → _selectedImageIndex berubah, dot indicator update
///    ├─ Scroll konten → _showTitle berubah, title muncul/hilang
///    ├─ Klik Back → Navigator.pop() → kembali ke home
///    ├─ Klik Favorite → SnackBar muncul "Ditambahkan ke Favorit!"
///    ├─ Klik Share → SnackBar muncul "Bagikan Destinasi"
///    └─ Klik Book Now → _showBookingDialog() → popup sukses
///       ├─ Klik "Tutup" → Tutup dialog
///       └─ Klik "Lihat Pesanan" → Tutup dialog + kembali ke home
/// 
/// 4. RESPONSIVITAS
///    ├─ isDesktop (>= 1200px) → Layout 4 kolom, font besar
///    ├─ isTablet (768-1199px) → Layout 3 kolom, font medium
///    ├─ isMobile (< 768px) → Layout 2 kolom, font normal
///    └─ isSmallMobile (< 375px) → Layout 2 kolom, font kecil
/// 
/// ============================================================================