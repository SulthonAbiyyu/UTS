# 🏝️ Indonesia Tour Guide App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Aplikasi mobile modern untuk menjelajahi destinasi wisata terbaik di Indonesia**

[Demo](#-screenshots) • [Features](#-features) • [Installation](#-installation) • [Usage](#-usage)

</div>

---

## 📖 Tentang Proyek

**Indonesia Tour Guide App** adalah aplikasi mobile yang dibangun dengan Flutter untuk memudahkan wisatawan dalam menemukan dan memesan paket tour guide di berbagai destinasi wisata populer di Indonesia. Aplikasi ini menawarkan pengalaman pengguna yang modern, responsif, dan intuitif.

### 🎯 Tujuan Proyek

- Mempermudah wisatawan menemukan tour guide profesional
- Menyediakan informasi lengkap tentang destinasi wisata Indonesia
- Memberikan pengalaman booking yang mudah dan cepat
- Menampilkan UI/UX yang menarik dan modern

---

## ✨ Features

### 🏠 Home Screen
- **Hero Section** dengan gradient animasi yang eye-catching
- **Popular Categories** dengan card design modern (Bali, Yogyakarta, NTB, Jawa Timur)
- **Featured Destinations** dengan rating dan review
- **Responsive Design** untuk berbagai ukuran layar (mobile, tablet, desktop)

### 📋 Product List Screen
- **Collapsing Header** dengan gradient premium multi-layer
- **Custom Geometric Pattern** sebagai background dekorasi
- **Filter System** (All, Popular, New) dengan smooth animation
- **Grid Layout Responsif** (2-5 kolom tergantung device)
- **Stagger Animation** untuk card yang muncul berurutan
- **Performance Optimization** dengan caching dan RepaintBoundary

### 🔍 Product Detail Screen
- **Image Gallery** dengan swipe gesture (5 gambar per destinasi)
- **Collapsing SliverAppBar** dengan parallax effect
- **Comprehensive Info Cards** (Durasi, Lokasi, Kategori, Reviews)
- **Detailed Description** dengan styling yang rapi
- **Facilities Badges** dengan icon mapping otomatis
- **Important Information** section dengan styling khusus
- **Tips & Recommendations** untuk wisatawan
- **Floating Action Bar** dengan harga dan tombol booking
- **Booking Dialog** dengan konfirmasi interaktif

### 🎨 Design Highlights
- **Material Design 3** principles
- **Smooth Animations** di setiap interaksi
- **Custom Painters** untuk pattern geometris
- **Gradient Backgrounds** dengan multiple layers
- **Responsive Typography** untuk berbagai ukuran layar
- **Glassmorphism Effects** di beberapa komponen

---



## 🛠️ Tech Stack

| Technology | Description |
|-----------|-------------|
| **Flutter** | UI Framework untuk cross-platform development |
| **Dart** | Programming language |
| **Material Design** | Design system dari Google |
| **Custom Painters** | Untuk custom graphics dan patterns |
| **Animation Controllers** | Untuk smooth animations |

---

## 📦 Installation

### Prerequisites

Pastikan Anda sudah menginstall:
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android SDK / Xcode (untuk iOS)

### Steps

1. **Clone repository**
```bash
git clone  https://github.com/SulthonAbiyyu/UTS.git
cd UTS
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# Development mode
flutter run

# Release mode
flutter run --release
```

4. **Build for production**
```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## 🎯 Usage

### 1. Browse Destinasi
- Buka aplikasi dan lihat kategori populer di home screen
- Klik kategori untuk melihat daftar destinasi (Bali, Yogyakarta, dll)

### 2. Filter Destinasi
- Gunakan filter chip (All, Popular, New) untuk menyaring destinasi
- Scroll untuk melihat semua destinasi yang tersedia

### 3. Lihat Detail
- Klik card destinasi untuk melihat detail lengkap
- Swipe gallery untuk melihat foto-foto destinasi
- Scroll untuk membaca deskripsi, fasilitas, info penting, dan tips

### 4. Booking
- Klik tombol "Book Now" di bagian bawah layar
- Konfirmasi booking melalui dialog yang muncul

---

## 📁 Project Structure

```
lib/
├── main.dart                      # Entry point aplikasi
├── screens/
│   ├── home_screen.dart           # Home screen dengan categories
│   ├── product_list_screen.dart   # List destinasi per kategori
│   └── product_detail_screen.dart # Detail destinasi & booking
├── constants/
    └── app_colors.dart       # Color manajement
```

---

## 🎨 Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Primary Blue | `#1E88E5` | Buttons, icons, highlights |
| Dark Blue | `#1565C0` | Gradient end, shadows |
| Light Blue | `#42A5F5` | Gradient start, accents |
| Amber | `#FFC107` | Ratings, warnings |
| Grey | `#757575` | Secondary text |
| White | `#FFFFFF` | Backgrounds, text |

---

## 🚀 Roadmap

### Version 1.0 (Current)
- ✅ Home screen dengan categories
- ✅ Product list dengan filter
- ✅ Product detail dengan booking
- ✅ Responsive design
- ✅ Smooth animations

### Version 1.1 (Planned)
- [ ] Search functionality
- [ ] User authentication
- [ ] Favorites system
- [ ] Booking history
- [ ] Payment integration

### Version 2.0 (Future)
- [ ] Real-time availability
- [ ] Chat with tour guide
- [ ] Reviews & ratings system
- [ ] Map integration
- [ ] Multi-language support

---

## 🤝 Contributing

Kontribusi sangat diterima! Jika Anda ingin berkontribusi:

1. Fork repository ini
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request


## 👨‍💻 Author

**Your Name**

- GitHub: [@yMatchaby](https://github.com/SulthonAbiyyu)
- LinkedIn: [SUlthon Abiyyu](www.linkedin.com/in/msabiprofile)
- Email: msulthonabiyyu108@gmail.com

---

## 🙏 Acknowledgments

- [Flutter Documentation](https://docs.flutter.dev/)
- [Material Design Guidelines](https://m3.material.io/)
- [Pinterest](https://pinterest.com/) untuk placeholder images
- Semua kontributor yang telah membantu proyek ini

---

## 📞 Support

Jika Anda menemukan bug atau memiliki saran:
- Contact via email: msulthonabiyyu108@gmail.com

---

<div align="center">

**Made with ❤️ and Flutter**

⭐ Jangan lupa beri star jika proyek ini bermanfaat!

</div>