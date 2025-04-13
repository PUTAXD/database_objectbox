import 'package:objectbox/objectbox.dart';

@Entity()
class Author {
  int id;
  String name;

  // Daftar buku yang ditulis oleh penulis
  final books = ToMany<Book>();

  Author({this.id = 0, required this.name});
}

@Entity()
class Book {
  int id;
  String title;

  // Mengaitkan balik ke author berdasarkan properti 'books'
  @Backlink('books')
  final authors = ToMany<Author>();

  Book({this.id = 0, required this.title});
}
