
# ObjectBox
ObjectBox adalah database NoSQL yang ringan dan cepat, dirancang untuk aplikasi mobile dan IoT. Ia menyimpan data dalam bentuk objek Dart secara langsung tanpa memerlukan konversi ke format lainnya.

# One To One

Pertama kita Membuat model.dart terlebih dahulu. Pada Relasi One to One saya membuat hubungan relasi antara 1 task berhubungan dengan 1 Owner. Seperti ini : 

```dart
@Entity()
class Task {
  @Id()
  int id;
  String text;

  bool status;

  Task(this.text, {this.id = 0, this.status = false});

  // To-one relation to a Owner Object.
  // https://docs.objectbox.io/relations#to-one-relations
  final owner = ToOne<Owner>();
  bool setFinished() {
    status = !status;
    return status;
  }
}

@Entity()
class Owner {
  @Id()
  int id;
  String name;

  Owner(this.name, {this.id = 0});
}
```

### 1. Class Task ###
@Entity(): Menandakan bahwa Task adalah entitas yang akan disimpan dalam database.

@Id(): Menandakan bahwa field id adalah primary key yang digunakan untuk mengidentifikasi objek Task secara unik dalam database.

Fields:

int id: ID unik dari task.

String text: Deskripsi dari task.

bool status: Status untuk menentukan apakah task sudah selesai atau belum.

Relation:

final owner = ToOne<Owner>(): Relasi satu-ke-satu dengan objek Owner. Ini berarti setiap task memiliki satu owner yang terkait. Owner ini bisa diakses melalui properti owner.

Method:

setFinished(): Method ini digunakan untuk membalikkan status task, sehingga jika task sebelumnya selesai, maka akan kembali menjadi belum selesai, dan sebaliknya.

### 2. Class Owner ###
@Entity(): Menandakan bahwa Owner adalah entitas yang akan disimpan dalam database.

Fields:

int id: ID unik untuk setiap Owner.

String name: Nama pemilik (Owner).

Kelas ini berfungsi untuk menyimpan data mengenai pemilik yang memiliki satu atau lebih task terkait. Setiap task akan merujuk ke satu Owner.

### Penjelasan Lanjutan ###

Setelah itu kita membuat ObjectBox menggunakan code generation untuk membuat file pendukung, seperti objectbox.g.dart dan objectbox-model.json

Jalankan 
```bash
flutter pub run build_runner build
```

setelah mendapatkan objectbox.g.dart, kita membuat File objectBox.dart dimana berfungsi sebagai jembatan antara aplikasi Flutter kamu dengan database ObjectBox. Di dalam file ini, terdapat kelas ObjectBox yang mengelola inisialisasi, operasi CRUD (Create, Read, Update, Delete), serta streaming data dari entitas yang telah saya definisikan (misalnya Task dan Owner). Bisa dibilang ini miirp sebagai Controller pada konsep PHP. 

Beberapa contohnya :
```dart
// Untuk Menambahkan Task ke database
void addTask(String taskText, Owner owner) {
    Task newTask = Task(taskText);
    newTask.owner.target = owner;

    taskBox.put(newTask);

    debugPrint(
        "Added Task: ${newTask.text} assigned to ${newTask.owner.target?.name}");
  }

// Untuk Menambahkan Owner Pada Database
  int addOwner(String newOwner) {
    Owner ownerToAdd = Owner(newOwner);
    int newObjectId = ownerBox.put(ownerToAdd);

    return newObjectId;
  }

// Untuk Mendapatkan Data Task Pada Database
  Stream<List<Task>> getTasks() {
    final builder = taskBox.query()..order(Task_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }
```

Setelah itu kita membuat fitur yang lebih interaktif untuk user didalam komponent UI-nya. 

a. Widget Tambah Task (task_add.dart)
Widget AddTask memungkinkan pengguna untuk menambahkan task baru dan mengassign owner. Fitur yang terdapat di widget ini antara lain:

- Text Field untuk memasukkan deskripsi task.

- Dropdown untuk memilih owner yang sudah ada.

- Dialog untuk menambahkan owner baru jika belum tersedia.

Tombol Save yang memanggil fungsi addTask() pada ObjectBox dan kembali ke halaman utama.

b. Widget Tampilan Task (task_card.dart)
Widget TaskCard digunakan untuk menampilkan setiap task dalam sebuah card. Pada card ini, pengguna dapat:

- Melihat deskripsi task.

- Melihat nama owner yang bertugas.

- Mengubah status task dengan mengklik checkbox.

- Menghapus task melalui menu opsi (Popup Menu).

c. Widget Daftar Task (task_list_view.dart)
Widget TaskList menggabungkan seluruh task yang telah disimpan dengan menggunakan StreamBuilder. Stream dari fungsi getTasks() dipantau sehingga setiap perubahan pada data langsung di-reflect pada UI menggunakan ListView.



