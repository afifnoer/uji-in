# PRD - Aplikasi Latihan Soal (Flutter)

**Product Requirements Document**

| Atribut | Keterangan |
| --- | --- |
| Nama produk | Aplikasi Latihan Soal |
| Platform | Flutter (Android, iOS, Web, Desktop) |
| Versi dokumen | 1.2 |
| Tanggal | 21 November 2026 |
| Status | Draf untuk pengembangan |
| Sumber soal | Hardcode (tertanam di kode) |
| Tipe soal | Pilihan tunggal (single) & multi-jawaban (multiple) |
| Komponen UI wajib | Checkbox dan List Box (ditambah Radio Button untuk pilihan tunggal) |

## 1. Ringkasan

Aplikasi Latihan Soal adalah aplikasi Flutter yang memandu peserta melalui alur: **layar selamat datang berlogo, pengisian data diri, pengerjaan soal pilihan tunggal (satu jawaban benar memakai radio button) maupun multi-jawaban (lebih dari satu jawaban benar memakai checkbox), lalu penampilan hasil beserta pembahasan**. Seluruh soal ditanam langsung di kode (hardcode), sehingga aplikasi berjalan sepenuhnya offline tanpa server atau database.

## 2. Latar Belakang dan Tujuan

### 2.1 Latar belakang

Latihan soal digital membantu peserta menguji pemahaman secara mandiri. Kombinasi soal pilihan tunggal (satu jawaban benar) dan soal multi-jawaban (lebih dari satu jawaban benar) mampu menguji pemahaman dasar sekaligus pemahaman konsep yang lebih mendalam, sehingga dibutuhkan antarmuka yang jelas agar peserta memahami jumlah jawaban yang harus dipilih di tiap soal dan mudah membaca hasilnya.

### 2.2 Tujuan produk

1. Menyediakan alur latihan soal yang runtut, profesional, dan mudah dipakai.
2. Mendukung dua tipe soal dalam satu sesi latihan dengan komponen yang intuitif: **pilihan tunggal** menggunakan `RadioListTile` (hanya satu jawaban dapat dipilih) dan **multi-jawaban** menggunakan `CheckboxListTile` (beberapa jawaban dapat dicentang sekaligus), lengkap dengan label tipe dan petunjuk yang jelas.
3. Menampilkan hasil yang transparan: skor, jumlah benar/salah/tidak dijawab, serta kunci dan pembahasan tiap soal.
4. Menerapkan komponen wajib Checkbox dan List Box secara nyata dan terlihat jelas, disertai Radio Button untuk pilihan tunggal.

### 2.3 Indikator keberhasilan

- Peserta dapat menyelesaikan alur penuh (welcome sampai hasil) tanpa bantuan.
- Skor yang ditampilkan 100% sesuai aturan penilaian pada bagian 9.
- Tidak ada crash pada skenario uji di bagian 14.
- Aplikasi tetap nyaman dipakai pada layar 360 px sampai tablet.

## 3. Ruang Lingkup

### 3.1 Dalam lingkup (In Scope)

- Layar selamat datang dengan logo dan animasi.
- Formulir data diri dengan validasi.
- Latihan soal campuran **pilihan tunggal** (single-answer dengan radio button) dan **multi-jawaban** (multi-answer dengan checkbox), lengkap dengan label tipe soal, navigasi antar-soal, dan panel nomor soal.
- Submit dengan dialog konfirmasi.
- Layar hasil dengan skor dan pembahasan per soal.
- Soal hardcode sebanyak 10 butir (kombinasi pilihan tunggal dan multi-jawaban, dapat ditambah).
- Opsi ulangi latihan.

### 3.2 Di luar lingkup (Out of Scope) untuk versi 1.0

- Login/akun, server, atau database.
- Penyimpanan riwayat permanen.
- Admin panel untuk mengelola soal.
- Ekspor PDF dan papan peringkat.

## 4. Pengguna Sasaran

| Persona | Deskripsi | Kebutuhan utama |
| --- | --- | --- |
| Peserta (siswa/mahasiswa) | Mengerjakan latihan untuk persiapan ujian | Soal jelas, bisa pindah antar-soal, hasil dan pembahasan |
| Pengajar/penilai (pengamat) | Melihat hasil peserta | Nama peserta dan skor terbaca jelas di layar hasil |

## 5. Alur Pengguna (User Flow)

1. Aplikasi dibuka, tampil **Layar Selamat Datang** (logo, judul, tombol Mulai).
2. Peserta menekan **Mulai**, masuk ke **Layar Data Diri**.
3. Peserta mengisi data dan menekan **Lanjut** (hanya aktif jika valid).
4. Masuk ke **Layar Latihan Soal**: membaca soal beserta label tipe dan petunjuknya, memilih satu jawaban melalui radio button (untuk pilihan tunggal) atau mencentang beberapa jawaban melalui checkbox (untuk multi-jawaban), lalu berpindah soal.
5. Di soal terakhir (atau lewat tombol Submit), muncul **dialog konfirmasi**.
6. Setelah konfirmasi, aplikasi menghitung nilai dan membuka **Layar Hasil**.
7. Peserta dapat melihat pembahasan, lalu memilih **Ulangi Latihan** (kembali ke soal, data diri tetap) atau **Kembali ke Awal**.

## 6. Kebutuhan Fungsional

### 6.1 Layar Selamat Datang (WEL)

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| WEL-01 | Menampilkan logo aplikasi di tengah layar bagian atas | Wajib |
| WEL-02 | Menampilkan nama aplikasi dan teks Selamat Datang | Wajib |
| WEL-03 | Menyediakan tombol Mulai yang membuka Layar Data Diri | Wajib |
| WEL-04 | Animasi masuk (fade/scale) pada logo, durasi 600-1000 ms | Disarankan |
| WEL-05 | Menampilkan versi aplikasi di bagian bawah | Opsional |
| WEL-06 | Jika logo gagal dimuat, tampilkan ikon pengganti (errorBuilder) | Wajib |

### 6.2 Layar Data Diri (PRO)

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| PRO-01 | Kolom **Nama Lengkap** (wajib, minimal 3 karakter, maksimal 50) | Wajib |
| PRO-02 | Kolom **NIM** (wajib, hanya angka) | Wajib |
| PRO-03 | **Dropdown Jurusan** (`DropdownButtonFormField` — penerapan List Box/combo box), pilihan: `Komputer dan Bisnis` | Wajib |
| PRO-04 | **Dropdown Program Studi (Prodi)** (`DropdownButtonFormField` — penerapan List Box/combo box), pilihan: `Teknik Informatika`, `Rekayasa Keamanan Siber`, `Teknologi Rekayasa Multimedia`, `Akuntansi Lembaga Keuangan Syariah`, `Rekayasa Perangkat Lunak` | Wajib |
| PRO-05 | **Dropdown Kelas** (`DropdownButtonFormField` — penerapan List Box/combo box), pilihan: `1A`, `1B`, `1C`, `2A`, `2B`, `2C` | Wajib |
| PRO-06 | Validasi dijalankan saat pengguna mengetik/berpindah kolom (autovalidateMode: onUserInteraction) | Wajib |
| PRO-07 | Tombol Lanjut nonaktif sampai seluruh kolom wajib valid | Wajib |
| PRO-08 | Pesan galat tampil di bawah kolom terkait dengan bahasa jelas | Wajib |
| PRO-09 | Keyboard menutup saat area kosong diketuk; layar dapat digulir agar tidak tertutup keyboard | Wajib |
| PRO-10 | Data diri disimpan di state aplikasi dan dibawa ke layar hasil | Wajib |

### 6.3 Layar Latihan Soal (QUI)

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| QUI-01 | Menampilkan nomor soal (Soal 3 dari 10) dan bilah progres | Wajib |
| QUI-02 | Menampilkan teks soal, **badge tipe soal** (`Pilihan Tunggal` / `Multi Jawaban`), dan petunjuk dinamis: **Pilih satu jawaban yang benar** (untuk pilihan tunggal) atau **Pilih semua jawaban yang benar (bisa lebih dari satu)** (untuk multi-jawaban) | Wajib |
| QUI-03 | Opsi jawaban ditampilkan dalam daftar `ListView` (**penerapan List Box**) berisi `RadioListTile` (`toggleable: true`) untuk soal **pilihan tunggal** dan `CheckboxListTile` untuk soal **multi-jawaban** (**penerapan Checkbox**) | Wajib |
| QUI-04 | Perilaku pemilihan menyesuaikan tipe soal: pada **pilihan tunggal** (`RadioListTile`), hanya satu opsi yang dapat dipilih (memilih opsi lain otomatis membatalkan pilihan sebelumnya, dan mengetuk opsi terpilih membatalkannya karena `toggleable: true`); pada **multi-jawaban** (`CheckboxListTile`), peserta dapat mencentang lebih dari satu opsi sekaligus dan membatalkan centang per opsi secara independen | Wajib |
| QUI-05 | Opsi yang terpilih/tercentang diberi warna latar dan border berbeda | Wajib |
| QUI-06 | Jawaban tersimpan otomatis saat berpindah soal; kembali ke soal lama menampilkan pilihan/centang yang sama | Wajib |
| QUI-07 | Tombol **Sebelumnya** (nonaktif di soal 1) dan **Selanjutnya** | Wajib |
| QUI-08 | Tombol **Submit** muncul di soal terakhir | Wajib |
| QUI-09 | **Panel nomor soal**: baris/grid angka 1-10 yang bisa diketuk untuk lompat; warna berbeda untuk sudah dijawab (minimal 1 opsi tercentang), belum dijawab, dan soal aktif (penerapan List Box tambahan) | Wajib |
| QUI-10 | Dialog konfirmasi submit menampilkan jumlah soal belum dijawab | Wajib |
| QUI-11 | Menekan tombol back saat mengerjakan memunculkan dialog Keluar dari latihan? (PopScope) | Wajib |
| QUI-12 | Timer hitung mundur (default 15 menit); saat habis, jawaban otomatis dikirim | Opsional |

### 6.4 Layar Hasil (RES)

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| RES-01 | Menampilkan nama, NIM, jurusan, prodi, kelas, dan tanggal/waktu pengerjaan | Wajib |
| RES-02 | Menampilkan skor akhir (0-100) dalam indikator besar dan status Lulus/Belum Lulus (batas lulus 70) | Wajib |
| RES-03 | Ringkasan: jumlah soal benar, salah, dan tidak dijawab | Wajib |
| RES-04 | **Daftar detail per soal** dengan `ListView.builder` dan `ExpansionTile` (penerapan List Box) | Wajib |
| RES-05 | Tiap item detail memuat: tipe soal, teks soal, daftar jawaban peserta, daftar kunci jawaban, dan penjelasan | Wajib |
| RES-06 | Warna status: hijau (benar), merah (salah), abu-abu (tidak dijawab); pada soal multi-jawaban, tiap opsi juga diberi penanda visual sesuai bagian 11.3 | Wajib |
| RES-07 | Tombol **Ulangi Latihan** dan **Kembali ke Awal** | Wajib |
| RES-08 | Layar hasil tidak dapat kembali ke soal dengan tombol back | Wajib |

## 7. Kebutuhan Non-Fungsional

| Kategori | Kebutuhan |
| --- | --- |
| Kinerja | Waktu buka aplikasi maksimal 3 detik; perpindahan antar-soal terasa instan (kurang dari 300 ms) |
| Penggunaan | Seluruh teks antarmuka dalam Bahasa Indonesia; ukuran area ketuk minimal 48x48 dp |
| Keandalan | Tidak crash pada input kosong, rotasi layar, atau tombol ditekan berulang |
| Responsif | Nyaman pada lebar 360 px sampai tablet; konten maksimal lebar 600 px di layar lebar |
| Aksesibilitas | Kontras warna memadai, dukungan ukuran font sistem, label semantik pada radio button dan checkbox |
| Pemeliharaan | Kode dipisah per lapisan (model, data, state, layar, widget); soal terpusat di satu berkas |
| Keamanan | Tidak ada data dikirim keluar perangkat; data diri hanya di memori |
| Kompatibilitas | Flutter stabil terbaru, Dart 3.x, Material 3 |

## 8. Penerapan Checkbox dan List Box (Traceability)

Bagian ini memastikan kedua komponen wajib benar-benar terpakai.

| Komponen | Lokasi | Widget Flutter | Fungsi |
| --- | --- | --- | --- |
| Radio Button | Opsi jawaban soal pilihan tunggal (`single`) | `RadioListTile` (`toggleable: true`) | Memilih maksimal satu jawaban pada soal pilihan tunggal |
| Checkbox | Opsi jawaban soal multi-jawaban (`multiple`) | `CheckboxListTile` | Memilih satu atau beberapa jawaban sekaligus pada soal multi-jawaban |
| List Box | Daftar opsi jawaban | `ListView` + `RadioListTile` / `CheckboxListTile` | Daftar pilihan yang dapat digulir |
| List Box | Panel nomor soal | `GridView` atau `ListView` horizontal | Lompat ke soal tertentu dengan penanda status |
| List Box (combo) | Data Diri, kolom Jurusan, Prodi, dan Kelas | `DropdownButtonFormField` | Memilih jurusan, program studi, dan kelas dari daftar lipat |
| List Box | Layar Hasil | `ListView.builder` + `ExpansionTile` | Menampilkan detail dan pembahasan per soal |

## 9. Aturan Penilaian

Setiap soal dapat bertipe **pilihan tunggal** (memiliki 1 kunci jawaban) atau **multi-jawaban** (memiliki 2 atau lebih kunci jawaban). Untuk menjaga kejelasan skor dan klasifikasi Benar/Salah pada versi 1.0, digunakan **penilaian ketepatan penuh (Exact Match)** untuk kedua tipe soal.

### 9.1 Aturan per soal

Skor soal = 1 jika **himpunan opsi terpilih** sama persis dengan **himpunan kunci jawaban** (`selected == correctAnswers`); skor = 0 jika berbeda atau tidak dijawab.

- Pada soal **pilihan tunggal**: peserta hanya dapat memilih maksimal 1 opsi, dan kunci berisi tepat 1 opsi.
- Pada soal **multi-jawaban**: peserta dapat memilih beberapa opsi, dan semua opsi kunci harus terpilih tanpa ada opsi salah yang ikut terpilih agar bernilai 1.
- Tidak ada pengurangan nilai (nilai minus) untuk jawaban salah.
- Soal tanpa jawaban (`selected.isEmpty`) bernilai 0.

### 9.2 Skor akhir

Skor akhir = (jumlah soal benar / jumlah soal) x 100, dibulatkan ke bilangan bulat terdekat.

### 9.3 Klasifikasi status per soal

| Status | Syarat |
| --- | --- |
| Benar | Himpunan opsi terpilih sama persis dengan himpunan kunci (`selected.length == correctAnswers.length` dan `selected.containsAll(correctAnswers)`, skor soal = 1) |
| Salah | Ada opsi terpilih, tetapi himpunannya tidak sama persis dengan kunci — termasuk pada multi-jawaban jika hanya sebagian kunci terpilih atau ada pengecoh terpilih (skor soal = 0) |
| Tidak dijawab | Tidak ada opsi tercentang (`selected.isEmpty`, skor soal = 0) |

### 9.4 Contoh perhitungan

1. **Contoh soal pilihan tunggal** (kunci: `{B}`):
   - Peserta memilih `{B}`: Benar, skor soal 1.
   - Peserta memilih `{A}`: Salah, skor soal 0.
   - Peserta tidak memilih apa pun (`{}`): Tidak dijawab, skor soal 0.
2. **Contoh soal multi-jawaban** (kunci: `{A, B, D}`):
   - Peserta memilih `{A, B, D}`: Benar, skor soal 1.
   - Peserta memilih `{A, B}` (kurang lengkap): Salah, skor soal 0.
   - Peserta memilih `{A, B, C, D}` (ada pengecoh C): Salah, skor soal 0.
   - Peserta tidak memilih apa pun (`{}`): Tidak dijawab, skor soal 0.
3. **Contoh skor akhir**: 7 soal benar (gabungan pilihan tunggal dan multi-jawaban) dari 10 soal = 70 (Lulus).

### 9.5 Catatan implementasi

Logika penilaian dibuat dalam satu fungsi terpisah (`scoring_service.dart`) agar mudah diubah, misalnya jika kelak ingin mengaktifkan **penilaian parsial** untuk soal multi-jawaban (contoh rumus parsial: `max(0, (benarTerpilih - salahTerpilih) / jumlahKunci)`) atau pengurangan nilai untuk jawaban salah.

## 10. Model Data dan Soal Hardcode

### 10.1 Model

```dart
enum QuestionType { single, multiple }

class Question {
  final int id;
  final QuestionType type;
  final String text;
  final List<String> options;
  final Set<int> correctAnswers; // indeks opsi benar (mulai dari 0)
  final String explanation;
  const Question({
    required this.id,
    required this.type,
    required this.text,
    required this.options,
    required this.correctAnswers,
    required this.explanation,
  });

  bool get isMultipleChoice => type == QuestionType.multiple;
}

class Participant {
  final String name;
  final String nim;
  final String department;
  final String studyProgram;
  final String className;
  const Participant({
    required this.name,
    required this.nim,
    required this.department,
    required this.studyProgram,
    required this.className,
  });
}
```

Aturan konsistensi model:
- Untuk `QuestionType.single`, `correctAnswers` wajib berisi tepat 1 indeks (misalnya `{0}`).
- Untuk `QuestionType.multiple`, `correctAnswers` berisi 2 atau lebih indeks (misalnya `{0, 1, 2}`).
- State jawaban disimpan sebagai `Map<int, Set<int>>` (id soal menuju himpunan indeks opsi tercentang), yang mendukung pilihan tunggal (`Set` berisi 0 atau 1 item) maupun multi-jawaban (`Set` berisi 0 hingga sejumlah opsi). Soal ditulis sebagai `const List<Question> kQuestions` pada berkas `lib/data/questions_data.dart`.

### 10.2 Aturan soal hardcode

- Setiap soal memiliki 4 opsi (A-D) dengan tipe **`single`** (tepat 1 jawaban benar) atau **`multiple`** (2 atau lebih jawaban benar).
- Petunjuk tampil sesuai tipe soal: *"Pilih satu jawaban yang benar."* untuk tipe `single`, dan *"Pilih semua jawaban yang benar (bisa lebih dari satu)."* untuk tipe `multiple`.
- Urutan soal tetap (acak adalah fitur lanjutan).
- Contoh topik di bawah adalah **Dasar Flutter dan Dart** dengan komposisi 5 soal pilihan tunggal dan 5 soal multi-jawaban; ganti sesuai kebutuhan Anda dengan mempertahankan format yang sama.

### 10.3 Daftar soal (10 butir)

| No | Tipe | Soal | Opsi (A, B, C, D) | Kunci | Pembahasan |
| --- | --- | --- | --- | --- | --- |
| 1 | `single` | Widget yang dipakai untuk daftar yang dapat digulir? | A. ListView; B. Row; C. Padding; D. SizedBox | A | ListView menampilkan daftar yang dapat digulir. |
| 2 | `multiple` | Manakah yang termasuk widget layout (tata letak) di Flutter? | A. Column; B. Row; C. Stack; D. Text | A, B, C | Column, Row, dan Stack mengatur tata letak widget anak, sedangkan Text menampilkan teks. |
| 3 | `single` | Siapa pengembang Flutter? | A. Meta; B. Google; C. Apple; D. Oracle | B | Flutter dikembangkan oleh Google. |
| 4 | `multiple` | Apa saja karakteristik bahasa Dart yang dipakai Flutter? | A. Mendukung null safety; B. Dikembangkan oleh Google; C. Hanya berjalan di Android; D. Dapat dikompilasi ke native/JS | A, B, D | Dart mendukung null safety, dikembangkan Google, dan mendukung multi-platform (native maupun web/JS). |
| 5 | `single` | Method untuk memperbarui tampilan pada StatefulWidget? | A. print(); B. dispose(); C. setState(); D. initState() | C | setState memicu build ulang tampilan. |
| 6 | `multiple` | Apa saja fungsi berkas `pubspec.yaml` pada proyek Flutter? | A. Mendeklarasikan package/dependency; B. Mendaftarkan aset gambar/font; C. Menulis kode UI utama; D. Menentukan versi aplikasi | A, B, D | pubspec.yaml mengatur metadata/versi aplikasi, dependency, dan aset; kode UI ditulis di berkas `.dart`. |
| 7 | `single` | Widget untuk isian teks? | A. Image; B. Icon; C. Divider; D. TextField | D | TextField menerima input teks dari pengguna. |
| 8 | `multiple` | Manakah perintah CLI Flutter yang valid? | A. `flutter run`; B. `flutter doctor`; C. `flutter start-ui`; D. `flutter clean` | A, B, D | `flutter run`, `flutter doctor`, dan `flutter clean` adalah perintah resmi Flutter CLI. |
| 9 | `single` | Cara mengaktifkan tema Material 3? | A. ThemeData(useMaterial3: true); B. Navigator.pop; C. MediaQuery.of; D. setState | A | Material 3 diaktifkan lewat ThemeData. |
| 10 | `multiple` | Manakah method `Navigator` untuk berpindah atau menutup layar di Flutter? | A. `Navigator.push`; B. `Navigator.pop`; C. `Navigator.build`; D. `Navigator.pushReplacement` | A, B, D | `push` dan `pushReplacement` membuka layar baru, sedangkan `pop` menutup layar saat ini. |

Indeks kunci pada kode: A=0, B=1, C=2, D=3. Contoh soal 1 (`single`): `correctAnswers: {0}`; contoh soal 2 (`multiple`): `correctAnswers: {0, 1, 2}`.

## 11. Desain UI/UX

### 11.1 Prinsip desain

- Material 3 dengan `ColorScheme.fromSeed` (warna utama biru tua, misalnya #1F4E9C).
- Latar layar abu-abu muda (#F5F7FB), kartu putih bersudut 12-16 dp.
- Hierarki teks jelas: judul, subjudul, isi, keterangan.
- Jarak berdasarkan kelipatan 4/8 dp.
- Satu aksi utama per layar memakai `FilledButton`.

### 11.2 Sketsa tata letak per layar

**Selamat Datang:** logo (tinggi 120 dp) di tengah, judul Latihan Soal, teks sambutan, tombol Mulai lebar penuh di bagian bawah.

**Data Diri:** judul layar, kartu formulir berisi kolom nama lengkap, NIM, dropdown jurusan, dropdown program studi (prodi), dropdown kelas, tombol Lanjut di bawah.

**Latihan Soal:** app bar dengan penghitung dan timer (opsional), bilah progres, panel nomor soal, kartu soal berisi badge tipe soal (`Pilihan Tunggal` / `Multi Jawaban`), petunjuk pengerjaan, teks soal, dan daftar opsi (`RadioListTile` untuk pilihan tunggal atau `CheckboxListTile` untuk multi-jawaban), bilah bawah berisi Sebelumnya dan Selanjutnya/Submit.

**Hasil:** kartu skor besar dengan status lulus, ringkasan empat kategori, daftar detail per soal dapat dibuka-tutup (menampilkan tipe soal, opsi terpilih peserta, kunci jawaban, dan pembahasan), tombol Ulangi dan Kembali ke Awal.

### 11.3 Status visual opsi jawaban

| Kondisi | Tampilan |
| --- | --- |
| Belum dipilih / dicentang | Latar putih, border abu-abu tipis |
| Terpilih / tercentang | Latar biru muda, border biru, teks tebal sedang |
| Pada layar hasil, kunci dan dipilih | Hijau |
| Pada layar hasil, dipilih tetapi salah | Merah |
| Pada layar hasil, kunci tetapi tidak dipilih | Hijau outline |

Penandaan visual per opsi di layar hasil membantu peserta melihat dengan cepat bagian mana yang tepat, salah pilih, atau terlewat, terutama pada soal multi-jawaban.

### 11.4 Teks antarmuka utama

- Welcome: Selamat Datang di Latihan Soal; tombol Mulai.
- Data Diri: Lengkapi data diri Anda sebelum memulai; tombol Lanjut.
- Soal pilihan tunggal: badge `Pilihan Tunggal`; petunjuk: *"Pilih satu jawaban yang benar."*
- Soal multi-jawaban: badge `Multi Jawaban`; petunjuk: *"Pilih semua jawaban yang benar (bisa lebih dari satu)."*
- Dialog submit: Kirim jawaban? Masih ada X soal belum dijawab.
- Dialog keluar: Keluar dari latihan? Jawaban Anda tidak akan tersimpan.

## 12. Arsitektur dan Spesifikasi Teknis

### 12.1 Struktur folder

```
lib/
  main.dart
  app_theme.dart
  models/
    question.dart
    participant.dart
    quiz_result.dart
  data/
    questions_data.dart        # soal hardcode
  providers/
    quiz_provider.dart         # state: peserta, jawaban, indeks soal
  services/
    scoring_service.dart       # fungsi penilaian
  screens/
    welcome_screen.dart
    profile_screen.dart
    quiz_screen.dart
    result_screen.dart
  widgets/
    option_tile.dart
    question_navigator.dart
    score_card.dart
    result_item.dart
assets/
  images/logo.png
```

### 12.2 Package

| Package | Fungsi | Status |
| --- | --- | --- |
| provider | State management | Disarankan |
| google\_fonts | Tipografi (mis. Poppins/Inter) | Opsional |
| percent\_indicator | Indikator skor melingkar | Opsional |

Tanpa package tambahan pun aplikasi dapat dibuat dengan `setState` dan `InheritedWidget`; `provider` dipilih agar state terpusat dan rapi.

### 12.3 Konfigurasi aset (pubspec.yaml)

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/logo.png
```

### 12.4 State yang dikelola (QuizProvider)

| State | Tipe | Keterangan |
| --- | --- | --- |
| participant | Participant? | Data diri peserta |
| currentIndex | int | Soal yang sedang dibuka |
| answers | Map\<int, Set\<int>> | Himpunan indeks opsi terpilih per soal (0-1 item untuk `single`, 0-N item untuk `multiple`) |
| result | QuizResult? | Hasil akhir setelah submit |

Metode utama: `setParticipant()`, `toggleAnswer(Question question, int optionIndex)`, `goTo(index)`, `next()`, `previous()`, `submit()`, `reset()`.

Perilaku `toggleAnswer(question, optionIndex)` (dipanggil oleh `OptionTile` saat `RadioListTile` atau `CheckboxListTile` diketuk):
- Jika `question.type == QuestionType.single` (`RadioListTile` dengan `toggleable: true`): bila `optionIndex` sudah ada di `Set`, hapus (menjadi `{}`); jika belum ada, ganti isi `Set` menjadi `{optionIndex}` agar hanya 1 opsi yang terpilih.
- Jika `question.type == QuestionType.multiple` (`CheckboxListTile`): bila `optionIndex` sudah ada di `Set`, hapus hanya `optionIndex`; jika belum ada, tambahkan `optionIndex` ke `Set` tanpa mengubah opsi lain yang sudah tercentang.

### 12.5 Navigasi

- Welcome ke Data Diri: `Navigator.push`.
- Data Diri ke Soal: `Navigator.pushReplacement`.
- Soal ke Hasil: `Navigator.pushReplacement`.
- Ulangi Latihan: bersihkan jawaban, kembali ke Soal.
- Kembali ke Awal: `Navigator.pushAndRemoveUntil` menuju Welcome, state di-reset.

## 13. Penanganan Kondisi Khusus (Edge Cases)

| Kondisi | Perilaku yang diharapkan |
| --- | --- |
| Nama kosong atau kurang dari 3 karakter | Pesan galat, tombol Lanjut nonaktif |
| NIM kosong atau berisi karakter non-angka | Pesan galat di bawah kolom, tombol Lanjut nonaktif |
| Mengganti pilihan pada soal pilihan tunggal | Pilihan radio button lama otomatis berpindah, hanya opsi baru yang terpilih |
| Memilih hanya sebagian kunci pada soal multi-jawaban | Soal tetap ditandai sudah dijawab pada panel nomor; saat submit dinilai Salah (skor 0 pada mode Exact Match) dan kunci yang terlewat diberi penanda hijau outline di layar hasil |
| Submit dengan seluruh soal kosong | Dialog peringatan; jika dikonfirmasi, skor 0 |
| Menekan tombol back saat mengerjakan | Dialog konfirmasi keluar |
| Rotasi layar saat mengerjakan | Jawaban dan posisi soal tidak hilang |
| Mengetuk Submit berulang kali | Hanya satu kali diproses (tombol dinonaktifkan setelah ditekan) |
| Logo tidak ditemukan | Tampil ikon pengganti, aplikasi tetap berjalan |
| Timer habis (jika diaktifkan) | Jawaban otomatis disubmit dan hasil ditampilkan |

## 14. Kriteria Penerimaan dan Skenario Uji

| ID | Skenario | Hasil yang diharapkan |
| --- | --- | --- |
| TC-01 | Buka aplikasi | Logo dan tombol Mulai tampil |
| TC-02 | Lanjut dengan nama kosong | Tidak bisa lanjut, ada pesan galat |
| TC-03 | Isi data valid lalu Lanjut | Masuk ke soal nomor 1 |
| TC-04 | Buka soal pilihan tunggal lalu soal multi-jawaban | Badge tipe, petunjuk, dan jenis kontrol (`RadioListTile` vs `CheckboxListTile`) berubah sesuai tipe soal |
| TC-05 | Pilih opsi A lalu opsi C pada soal **pilihan tunggal** | Radio pada opsi A otomatis batal, hanya opsi C yang terpilih dan tersorot |
| TC-06 | Centang opsi A lalu opsi C pada soal **multi-jawaban** | Checkbox opsi A dan opsi C sama-sama tercentang dan tersorot |
| TC-07 | Ketuk ulang opsi yang sudah dipilih/dicentang | Opsi tersebut kembali normal (`toggleable` pada radio dan uncheck pada checkbox); pada multi-jawaban, opsi tercentang lainnya tetap bertahan |
| TC-08 | Pindah ke soal lain lalu kembali | Pilihan/centang sebelumnya tetap ada |
| TC-09 | Ketuk angka 7 pada panel nomor | Langsung ke soal 7 |
| TC-10 | Panel nomor setelah menjawab soal (tunggal atau multi) | Nomor soal yang minimal memiliki 1 pilihan/centang berubah warna |
| TC-11 | Submit dengan 2 soal kosong | Dialog menyebut 2 soal belum dijawab |
| TC-12 | Jawab semua soal (tunggal dan multi) sesuai kunci | Skor 100, status Lulus |
| TC-13 | Jawab soal multi-jawaban hanya sebagian kunci atau menyertakan pengecoh | Soal tersebut dinilai Salah (skor 0), skor akhir menyesuaikan |
| TC-14 | Jawab 7 soal benar dan 3 soal salah | Skor 70, status Lulus |
| TC-15 | Buka detail soal di layar hasil | Tampil tipe soal, jawaban peserta, kunci, pembahasan, dan penanda warna tiap opsi |
| TC-16 | Tekan Ulangi Latihan | Jawaban kosong, data diri tetap |
| TC-17 | Tekan Kembali ke Awal | Kembali ke Welcome, data direset |
| TC-18 | Uji di layar kecil (360 px) | Tidak ada overflow |

## 15. Rencana Pengembangan

| Tahap | Pekerjaan | Perkiraan |
| --- | --- | --- |
| 1 | Setup proyek, tema, struktur folder, aset logo | 0,5 hari |
| 2 | Model data dan 10 soal hardcode | 0,5 hari |
| 3 | Layar Selamat Datang dan Data Diri | 1 hari |
| 4 | Layar Latihan Soal (radio button, checkbox, navigasi, panel nomor) | 2 hari |
| 5 | Layanan penilaian dan Layar Hasil | 1,5 hari |
| 6 | Pengujian, perbaikan, dan penyempurnaan UI | 1 hari |
| 7 | Build rilis (APK) dan dokumentasi | 0,5 hari |

**Total perkiraan: sekitar 7 hari kerja** untuk satu pengembang.

## 16. Risiko dan Mitigasi

| Risiko | Dampak | Mitigasi |
| --- | --- | --- |
| Aturan penilaian ambigu | Skor dipertanyakan | Tetapkan rumus di bagian 9 dan buat unit test |
| Soal hardcode sulit diubah | Perawatan lambat | Pusatkan semua soal di satu berkas dan satu format |
| Layar kecil overflow | Tampilan rusak | Pakai SingleChildScrollView dan uji di 360 px |
| Jawaban hilang saat rotasi atau berpindah layar | Data peserta hilang | Simpan state di Provider, bukan di widget |
| Logo resolusi rendah | Tampilan kurang profesional | Siapkan PNG minimal 512x512 dengan latar transparan |

## 17. Pengembangan Lanjutan (Roadmap)

- Acak urutan soal dan opsi jawaban.
- Riwayat nilai tersimpan di perangkat (shared\_preferences).
- Soal dimuat dari JSON atau Firebase.
- Beberapa paket soal/kategori.
- Ekspor hasil ke PDF.
- Mode gelap.
- Papan peringkat.

## 18. Hal yang Harus Disiapkan

1. File logo PNG (`assets/images/logo.png`, 512x512) sudah disiapkan.
2. Topik, tipe tiap soal (`single`/`multiple`), dan isi soal final beserta kunci jawaban (Dasar Flutter & Dart pada bagian 10.3).
3. Keputusan mode penilaian multi-jawaban (default: Exact Match tanpa pengurangan nilai; opsi lanjutan: penilaian parsial).
4. Batas nilai kelulusan (default 70).
5. Keputusan memakai timer atau tidak (v1.0: belum diaktifkan).
6. Daftar pilihan jurusan (`Komputer dan Bisnis`), prodi, dan kelas (`1A`–`1C`, `2A`–`2C`) pada dropdown sudah ditetapkan.

## 19. Persetujuan

| Peran | Nama | Tanggal | Tanda tangan |
| --- | --- | --- | --- |
| Pemilik produk |  |  |  |
| Pengembang |  |  |  |
| Penguji |  |  |  |
