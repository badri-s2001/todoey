import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todoey/helpers/database_helper.dart';

import 'model/task.dart';

class TaskData extends ChangeNotifier {
  List<Task> _tasks;

  Future<void> getTasks() async {
    _tasks = await DatabaseHelper.instance.getTaskList();
  }

  Future<UnmodifiableListView<Task>> get tasks async {
    await getTasks();
    return UnmodifiableListView(_tasks);
  }

  void addTask(String name) {
    Task task = Task(name: name);
    DatabaseHelper.instance.insertTask(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    DatabaseHelper.instance.updateTask(task);
    getTasks();
    notifyListeners();
  }

  void deleteTask(Task task) {
    DatabaseHelper.instance.deleteTask(task);
    getTasks();
    notifyListeners();
  }
}
