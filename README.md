
# ObjectBox
ObjectBox adalah database NoSQL yang ringan dan cepat, dirancang untuk aplikasi mobile dan IoT. Ia menyimpan data dalam bentuk objek Dart secara langsung tanpa memerlukan konversi ke format lainnya.

Untuk melakukan instalasi bisa baca di dokumen resminya : https://docs.objectbox.io/getting-started



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

### Class Task ###
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

### Class Owner ###
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

Pada setiap task_card.dart yang dipanggil melalui task_list_view.dart, kita bisa membuat fitur delete untuk sebuah task.

task_card.dart
```dart
...
            PopupMenuButton<MenuElement>(
            onSelected: (item) => onSelected(context, widget.task),
            itemBuilder: (BuildContext context) =>
                [...MenuItems.itemsFirst.map(buildItem).toList()],
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(color: Colors.grey, Icons.more_horiz),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<MenuElement> buildItem(MenuElement item) =>
      PopupMenuItem<MenuElement>(value: item, child: Text(item.text!));

  void onSelected(BuildContext context, Task task) {

    // untuk menghapus task berdasarkan ID
    objectbox.taskBox.remove(task.id);
    debugPrint("Task ${task.text} deleted");
  }
}
```


# One To Many ( database_2 ) #

Saya menambahkan entitas baru dari project one_to_one, yaitu Event. Dimana event memiliki banyak task, tetapi task hanya bisa memiliki 1 event ( One To Many ). Berikut model.dart :

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

  final event = ToOne<Event>();

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

@Entity()
class Event {
  @Id()
  int id;
  String name;

  @Property(type: PropertyType.date)
  DateTime? date;

  String? location;

  Event(this.name, {this.id = 0, this.date, this.location});

  @Backlink('event')
  final tasks = ToMany<Task>();
}

```


Tentu! Berikut adalah penjelasan model yang bisa langsung kamu salin ke README dengan format yang sesuai:

---

### Entitas Task

#### Atribut:

#### **id:**
Ditandai dengan anotasi `@Id()`, atribut ini berperan sebagai primary key (ID unik) untuk setiap objek *Task*.

#### **text:**
Menyimpan deskripsi atau judul dari task.

#### **status:**
Tipe boolean yang menandakan apakah task sudah selesai (`true`) atau belum (`false`).

#### **Konstruktor:**
Konstruktor `Task(this.text, {this.id = 0, this.status = false})` memungkinkan pembuatan objek *Task* dengan nilai default untuk `id` dan `status`.

#### **Relasi:**

- **owner:**  
  Dideklarasikan sebagai `final owner = ToOne<Owner>();` yang artinya setiap *Task* memiliki hubungan one-to-one dengan entitas *Owner*. Dengan demikian, satu task hanya dapat memiliki satu owner.

- **event:**  
  Dideklarasikan sebagai `final event = ToOne<Event>();` yang menunjukkan bahwa setiap task juga memiliki hubungan one-to-one dengan entitas *Event*. Ini memungkinkan task dikaitkan dengan sebuah event tertentu.

#### **Method:**

- **setFinished():**  
  Fungsi ini membalik nilai dari atribut `status`. Jika task belum selesai, maka akan diubah menjadi selesai, dan sebaliknya. Fungsi ini kemudian mengembalikan nilai status yang baru.

---

### Entitas Owner

#### Atribut:

#### **id:**
Ditandai dengan `@Id()`, atribut ini berfungsi sebagai primary key untuk setiap objek *Owner*.

#### **name:**
Menyimpan nama dari owner.

#### **Konstruktor:**
Konstruktor `Owner(this.name, {this.id = 0})` memungkinkan pembuatan objek *Owner* dengan nama tertentu dan ID default 0.

---

### Entitas Event

#### Atribut:

#### **id:**
Ditandai dengan `@Id()`, atribut ini berfungsi sebagai primary key untuk setiap objek *Event*.

#### **name:**
Menyimpan nama atau judul dari event.

#### **date:**
Tipe `DateTime?` yang menandakan tanggal event, ditandai dengan anotasi `@Property(type: PropertyType.date)` untuk memastikan bahwa data tanggal disimpan dengan format yang tepat.

#### **location:**
String opsional yang menyimpan informasi lokasi event.

#### **Konstruktor:**
Konstruktor `Event(this.name, {this.id = 0, this.date, this.location})` memungkinkan pembuatan objek event dengan parameter yang fleksibel untuk tanggal dan lokasi.

#### **Relasi:**

- **tasks:**  
  Dideklarasikan sebagai `final tasks = ToMany<Task>();` dengan anotasi `@Backlink('event')`, yang menunjukkan bahwa satu event dapat memiliki banyak task terkait. Dengan adanya backlink ini, setiap *Task* yang memiliki relasi dengan *Event* ini akan otomatis masuk ke dalam koleksi `tasks` pada entitas *Event*.
---

### Penjelasan Lanjutan ###
Semua komponen mirip dengan one_to_one, disini kita bisa menambahkan Event dengan metode yang sama pada Task sebelumnya.

event_list.dart
gambar

event_add.dart
gambar



