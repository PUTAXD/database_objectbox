import 'dart:async';
import 'components/authorListPage.dart';
import 'package:flutter/material.dart';
import 'objectbox.dart';

/// Provides access to the ObjectBox Store throughout the app.
Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  await initObjectBox();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ObjectBox Relations Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthorListPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        title: const Text("Events"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: const [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Text("+", style: TextStyle(fontSize: 29))),
    );
  }
}
