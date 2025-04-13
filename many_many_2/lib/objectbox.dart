// objectbox.dart

export 'package:objectbox/objectbox.dart';
import 'objectbox.g.dart';

// Impor model yang Anda gunakan. Contoh: Todo dan model many-to-many (Author & Book)
import 'model.dart';

/// Variabel global untuk menyimpan instance Store ObjectBox.
late final Store objectBoxStore;

/// Fungsi untuk menginisiasi ObjectBox.
/// Pastikan Anda menjalankan fungsi ini sebelum aplikasi menggunakan database,
/// misalnya di dalam main() sebelum runApp().
Future<void> initObjectBox() async {
  // Membuka store yang secara otomatis memanfaatkan file binding objectbox.g.dart.
  objectBoxStore = await openStore();

  _putDemoData();
}

void _putDemoData() {
  // Mengakses box untuk Author dan Book.
  final authorBox = objectBoxStore.box<Author>();
  final bookBox = objectBoxStore.box<Book>();

  // Cek apakah database masih kosong dengan memeriksa box Author.
  if (authorBox.getAll().isEmpty) {
    // Membuat beberapa instance Book.
    final book1 = Book(title: 'The Flutter Journey');
    final book2 = Book(title: 'Mastering Dart');
    final book3 = Book(title: 'ObjectBox in Action');

    // Membuat instance Author pertama dan menambahkan beberapa buku.
    final author1 = Author(name: 'John Doe');
    author1.books.addAll([book1, book2]);

    // Membuat instance Author kedua dengan berbagi salah satu buku untuk relasi many-to-many.
    final author2 = Author(name: 'Jane Smith');
    author2.books.addAll([book2, book3]);

    // Menyimpan data Author (dan secara otomatis juga menyimpan Book terkait melalui relasi).
    authorBox.put(author1);
    authorBox.put(author2);

    print('Demo data berhasil ditambahkan ke database.');
  } else {
    print('Database sudah memiliki data, demo data tidak ditambahkan.');
  }
}
