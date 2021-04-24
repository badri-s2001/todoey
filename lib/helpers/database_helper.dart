import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'package:todoey/model/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String taskTable = 'task_table';
  String colId = 'id';
  String colName = 'name';
  String colIsDone = 'isDone';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todoey.db';
    final todoeyDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return todoeyDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colIsDone INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(taskTable);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];

    taskMapList.forEach(
      (taskMap) {
        taskList.add(Task.fromMap(taskMap));
      },
    );

    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    int id = task.toMap()['id'];
    int isDone = task.toMap()['isDone'];
    int result;
    if (isDone == 0) {
      result = await db.rawUpdate(
        '''
      UPDATE $taskTable
      SET $colIsDone = 1
      WHERE $colId = $id
      ''',
      );
    } else {
      result = await db.rawUpdate(
        '''
      UPDATE $taskTable
      SET $colIsDone = 0
      WHERE $colId = $id
      ''',
      );
    }

    return result;
  }

  Future<int> deleteTask(Task task) async {
    Database db = await this.db;
    task.toMap();
    final int result = await db.delete(
      taskTable,
      where: '$colId = ?',
      whereArgs: [task.id],
    );
    return result;
  }
}
