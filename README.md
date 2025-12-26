# Coffee Shop App ☕  
Aplikasi Mobile Coffee Shop dengan Flutter & Laravel API

Project ini merupakan aplikasi pemesanan coffee shop sederhana yang terhubung dengan backend **Laravel REST API** melalui metode **HTTP request**.  
Aplikasi mendukung **CRUD produk**, **autentikasi user**, **reset password**, dan **navigasi produk berdasarkan kategori**.

---

## 🚀 Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| Register & Login | User membuat akun lalu login menggunakan email & password |
| CRUD Produk | Tambah, edit, hapus dan lihat daftar produk |
| Upload Gambar Produk | Upload file gambar saat create/update |
| Detail Produk | Menampilkan detail lengkap produk |
| Reset Password | User dapat mengubah password melalui API |
| Kategori & Navigasi | Produk ditampilkan berdasarkan kategori atau semua produk |
| Local Token Storage | Token disimpan menggunakan SharedPreferences untuk autentikasi |

---

## 📱 Alur Navigasi Aplikasi

1. Pengguna baru harus membuat akun (**register**)
2. Setelah registrasi, pengguna melakukan **login**
3. Pada halaman utama (**home**) tampil promosi, kategori produk, dan produk terbaru
4. Jika pengguna menekan **kategori**, aplikasi menampilkan daftar produk dalam kategori tersebut
5. Jika pengguna menekan **More**, aplikasi menampilkan **semua produk**
6. Pada halaman daftar produk, user dapat:
   - menambahkan produk
   - mengupdate produk
   - menghapus produk
   - melihat detail produk
7. Pada halaman detail, user dapat melihat deskripsi produk & opsi untuk menambah ke keranjang (belum diimplementasikan checkout)

---

## 🔧 Teknologi yang Digunakan

| Bagian | Teknologi |
|--------|-----------|
| Frontend | Flutter (Dart), HTTP, SharedPreferences |
| Backend | Laravel 10, REST API, MySQL |
| Database | MySQL / MariaDB |
| Autentikasi | Token Bearer (Sanctum / JWT bergantung pada setup) |

---

## 🧪 Contoh Pemanggilan API di Flutter

```dart
final response = await http.get(
  Uri.parse('$baseUrl/products'),
  headers: {'Authorization': 'Bearer $token'},
);

if (response.statusCode == 200) {
  final List data = jsonDecode(response.body);
  return data.map((e) => Product.fromJson(e)).toList();
}
