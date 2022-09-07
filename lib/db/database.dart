import 'dart:io';

import 'package:flutter_application/model/student.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// TODO
// used singleton pattern
class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static late Database _database;

  String studentsTable = 'Students';
  String columnId = 'id';
  String columnName = 'name';

  // ленивая инициализация
  Future<Database> get database async {
    // if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    // получение пути для сохранения db на устройстве
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'Student.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Student
  // Id | Name
  // 0    ..
  // 1    ..

  void _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $studentsTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT)',
    );
  }

  // READ
  Future<List<Student>> getStudents() async {
    Database db = await database;

    final List<Map<String, dynamic>> studentsMapList =
        await db.query(studentsTable);

    final List<Student> studentsList = [];

    studentsMapList.forEach((studentMap) {
      studentsList.add(Student.fromMap(studentMap));
    });

    return studentsList;
  }

  // ADD
  Future<Student> addStudent(Student student) async {
    Database db = await database;
    student.id = await db.insert(studentsTable, student.toMap());
    return student;
  }

  // UPDATE
  Future<int> updateStudent(Student student) async {
    Database db = await database;
    return await db.update(
      studentsTable,
      student.toMap(),
      where: '$columnId = ?', // знак ? будет заменен новым значением
      whereArgs: [student.id],
    );
  }

  // DELETE
  Future<int> deleteStudent(int? id) async {
    Database db = await database;
    return await db.delete(
      studentsTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
