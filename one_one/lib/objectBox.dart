import 'package:flutter/material.dart';

import 'model.dart';
import 'objectbox.g.dart';

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  late final Store store;

  late final Box<Task> taskBox;
  late final Box<Owner> ownerBox;

  ObjectBox._create(this.store) {
    taskBox = Box<Task>(store);
    ownerBox = Box<Owner>(store);

    if (taskBox.isEmpty()) {
      _putDemoData();
    }
  }

  void _putDemoData() {
    Owner owner1 = Owner('Eren');
    Owner owner2 = Owner('Annie');

    Task task1 = Task("This is Annie's Task");
    task1.owner.target = owner1;

    Task task2 = Task("This is Eren's Task");
    task2.owner.target = owner2;

    taskBox.putMany([task1, task2]);
  }

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  void addTask(String taskText, Owner owner) {
    Task newTask = Task(taskText);
    newTask.owner.target = owner;

    taskBox.put(newTask);

    debugPrint(
        "Added Task: ${newTask.text} assigned to ${newTask.owner.target?.name}");
  }

  int addOwner(String newOwner) {
    Owner ownerToAdd = Owner(newOwner);
    int newObjectId = ownerBox.put(ownerToAdd);

    return newObjectId;
  }

  Stream<List<Task>> getTasks() {
    final builder = taskBox.query()..order(Task_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }
}
