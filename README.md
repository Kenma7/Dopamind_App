# DOPAMIND – Aplikasi Pendukung Kesehatan Mental (UAS PBM 2025)

Aplikasi mobile berbasis Flutter dengan backend PHP & MySQL untuk mendukung kesehatan mental melalui fitur mood tracking, jurnal syukur, meditasi audio, dan aktivitas self-healing.

## 🗂️ Struktur Project
- `/frontend` – Kode Flutter (Dart)
- `/backend` – API PHP (XAMPP/htdocs)
- `/database` – Skema MySQL & contoh data
- `/docs` – Laporan UAS & dokumentasi

## 🚀 Cara Menjalankan
### Backend (PHP)
1. Letakkan folder `backend` di `htdocs`
2. Import `database/dopamind_db.sql` ke phpMyAdmin
3. Jalankan XAMPP (Apache & MySQL)

### Frontend (Flutter)
1. Buka folder `frontend` di VS Code
2. Jalankan `flutter pub get`
3. Ganti base URL API di `lib/services/api_service.dart`
4. Run di emulator atau perangkat fisik

## 🛠️ Teknologi
- Flutter 
- PHP 
- MySQL
- VS Code + Android Emulator

## ✨ Fitur
- Mood Tracking dengan riwayat
- Jurnal Syukur (CRUD via API)
- Meditasi Audio
- Latihan Pernapasan
- Afirmasi Positif
- UI Responsif & ramah kesehatan mental

---
© 2025 – Faishal Muhammad Farhan | Universitas Singaperbangsa Karawang
