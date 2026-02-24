# Assessment Mission 6 🚀 Wanderly

Halo student HSB-1024! 👋  

Terima kasih sudah menyelesaikan Mission 6 pada Bootcamp Flutter Batch 1.

Struktur project dan penggunaan Riverpod sudah baik, tetapi ada isu kritikal pada persistence karena data trip di-reset setiap startup sehingga tujuan utama Mission 6 belum konsisten tercapai.

---

## 📊 Aspek Penilaian

| Aspek Penilaian | Detail Item Penilaian | Poin Maksimal |
|-----------------|----------------------|---------------|
| Feature Completeness | Semua fitur sesuai instruction | 20 |
| Riverpod Implementation | StateNotifier/Notifier usage, state flow | 15 |
| Hive Integration | Persistensi data & adapter | 15 |
| Architecture & Structure | Separation of concerns | 15 |
| Clean Code | Naming, readability, modularity | 10 |
| Error Handling | Try-catch, fallback state | 10 |
| UI States | Loading, Empty, Error state | 10 |
| Maintainability | Scalability & structure | 5 |

---

## 📝 Raport Skor

| Aspek Penilaian | Skor Dicapai | Komentar Ramah & Kritis |
|-----------------|-------------|--------------------------|
| Feature Completeness | 16/20 | Fitur cukup lengkap, tapi persistence terganggu oleh reset startup. |
| Riverpod Implementation | 13/15 | Notifier sudah dipakai luas, meski masih ada state campuran di UI. |
| Hive Integration | 11/15 | Integrasi teknis berjalan, namun reset startup meniadakan persistensi user data. |
| Architecture & Structure | 14/15 | Layer provider/services/screens sudah terstruktur dan readable. |
| Clean Code | 8/10 | Kode relatif rapi, ada beberapa bagian yang masih bisa diringkas. |
| Error Handling | 8/10 | Try-catch ada, tetapi lifecycle error state belum ideal. |
| UI States | 10/10 | Loading/empty/error state sudah baik di banyak flow. |
| Maintainability | 5/5 | Fondasi maintainability bagus jika bug persistence dibenahi. |

**Total Skor: 85 / 100 🎯**

---

## 2️⃣ Temuan Detail per File

### ✅ Hal yang Sudah Bagus
- `lib/providers/trip/trip_controller.dart` sudah memindahkan CRUD ke provider.
- `lib/services/hive_service.dart` dan `lib/services/trip_service.dart` memisahkan tanggung jawab data dengan jelas.
- UI loading dan empty state terimplementasi konsisten.

### ⚠️ Perlu Peningkatan
- `lib/main.dart` masih menghapus data trip setiap startup.
- `lib/providers/trip/trip_state.dart` belum bisa clear error state dengan aman.
- Sebagian state UI yang membesar masih berbasis `setState`.

---

## 3️⃣ Inline Review Simulation

lib/main.dart

Line 24:  
❌ `resetAndInitialize()` dipanggil pada startup dan menghapus data user.
Suggestion: Jalankan seeding hanya saat box kosong, bukan setiap aplikasi dibuka.

Severity: High  
Impact: Data tidak persisten antar sesi, bertentangan langsung dengan requirement Mission 6.

lib/providers/trip/trip_state.dart

Line 22:  
⚠️ `copyWith` saat ini sulit meng-clear `error` ke `null`.
Suggestion: Gunakan pendekatan `clearError` flag/sentinel agar lifecycle error lebih presisi.

Severity: Medium  
Impact: UI berpotensi menampilkan error lama walau operasi berikutnya sukses.

lib/providers/trip/trip_controller.dart

Line 9:  
⚠️ Async load dipanggil dari `build()` tanpa guard lifecycle.
Suggestion: Pertimbangkan pola inisialisasi yang menghindari trigger ulang saat provider recreate.

Severity: Medium  
Impact: Potensi state reload yang sulit diprediksi.

lib/screens/home_screen.dart

Line 77:  
⚠️ State bulan/tahun masih dikelola lokal di screen besar.
Suggestion: Ekstrak ke provider ringan agar widget lebih modular dan testable.

Severity: Low  
Impact: Keterbacaan dan scalability menurun saat fitur bertambah.

---

## 💡 Saran Pengembangan Berikutnya

1. Hilangkan reset startup dan ganti dengan seeding kondisional saat data kosong.
2. Rapikan lifecycle error state (`set`, `show`, `clear`) di provider trip.
3. Kurangi state lokal yang membesar dengan provider kecil untuk UI state.

---

## 🧠 Kesimpulan Teknis

Project sudah memiliki pondasi arsitektur yang kuat. Setelah isu reset persistence diperbaiki, implementasi ini bisa naik cepat ke kualitas production-ready untuk scope Mission 6.
