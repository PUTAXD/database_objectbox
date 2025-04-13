import 'package:flutter/material.dart';
import 'package:many_many_2/objectbox.dart'; // Pastikan file objectbox.dart berada di folder yang tepat
import '../model.dart';

class AuthorListPage extends StatefulWidget {
  const AuthorListPage({Key? key}) : super(key: key);
  @override
  AuthorListPageState createState() => AuthorListPageState();
}

class AuthorListPageState extends State<AuthorListPage> {
  // Mengakses box untuk Author dan Book melalui instance ObjectBox yang telah diinisialisasi.
  late final Box<Author> authorBox;
  late final Box<Book> bookBox;

  @override
  void initState() {
    super.initState();
    authorBox = objectBoxStore.box<Author>();
    bookBox = objectBoxStore.box<Book>();
  }

  // Fungsi untuk refresh UI.
  void _refreshData() {
    setState(() {});
  }

  /// Dialog untuk menambahkan Author baru.
  Future<void> _showAddAuthorDialog() async {
    final nameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Author"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Masukkan nama Author",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Batal
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final newAuthor = Author(name: name);
                  authorBox.put(newAuthor);
                  _refreshData();
                }
                Navigator.pop(context);
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  /// Dialog untuk menampilkan detail Author dan menambahkan Book baru.
  Future<void> _showAuthorDetailDialog(Author author) async {
    final titleController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Detail Author & Tambah Book"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Author: ${author.name}"),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration:
                    const InputDecoration(hintText: "Masukkan judul Book"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Batal
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isNotEmpty) {
                  final newBook = Book(title: title);
                  // Menambahkan Book ke dalam properti many-to-many Author
                  author.books.add(newBook);
                  // Menyimpan ulang Author, sehingga relasi otomatis terkelola
                  authorBox.put(author);
                  _refreshData();
                }
                Navigator.pop(context);
              },
              child: const Text("Tambah Book"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil semua data Author dari ObjectBox.
    final authors = authorBox.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Authors & Books'),
      ),
      body: ListView.builder(
        itemCount: authors.length,
        itemBuilder: (context, index) {
          final author = authors[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(author.name),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Books:"),
                    // Menampilkan setiap Book yang berelasi dengan Author
                    ...author.books.map((book) => Text("- ${book.title}")),
                  ],
                ),
              ),
              onTap: () {
                _showAuthorDetailDialog(author);
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  authorBox.remove(author.id);
                  _refreshData();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAuthorDialog,
        child: const Icon(Icons.add),
        tooltip: "Tambah Author",
      ),
    );
  }
}
