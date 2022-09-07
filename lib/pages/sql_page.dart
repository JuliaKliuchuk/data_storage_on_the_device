import 'package:flutter/material.dart';
import 'package:flutter_application/db/database.dart';
import 'package:flutter_application/model/student.dart';

// work with sqfltite database
// sqflite was used

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  StudentPageState createState() => StudentPageState();
}

class StudentPageState extends State<StudentPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _studentNameController = TextEditingController();

  late Future<List<Student>> _studentsList;
  late String _studentName;
  bool isUpdate = false;
  int? studentIdForUpdate;

  @override
  void initState() {
    super.initState();
    updateStudentList();
  }

  updateStudentList() {
    setState(() {
      _studentsList = DBProvider.db.getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey,
        title: const Text('SQLite CRUD Demo'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formStateKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Please Enter Student Name';
                      }
                      if (value.trim() == "") {
                        return "Only Space is Not Valid!!!";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _studentName = value!;
                    },
                    controller: _studentNameController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.greenAccent,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      labelText: "Student Name",
                      icon: Icon(
                        Icons.people,
                        color: Colors.black,
                      ),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: Text(
                  (isUpdate ? 'UPDATE' : 'ADD'),
                ),
                onPressed: () {
                  if (isUpdate) {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      DBProvider.db
                          .updateStudent(
                              Student(studentIdForUpdate!, _studentName))
                          .then((data) {
                        setState(() {
                          isUpdate = false;
                        });
                      });
                    }
                  } else {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      DBProvider.db.addStudent(Student(null, _studentName));
                    }
                  }
                  _studentNameController.text = '';
                  updateStudentList();
                },
              ),
              const Padding(
                padding: EdgeInsets.all(10),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: Text(
                  (isUpdate ? 'CANCEL UPDATE' : 'CLEAR'),
                ),
                onPressed: () {
                  _studentNameController.text = '';
                  setState(() {
                    isUpdate = false;
                    studentIdForUpdate = null;
                  });
                },
              ),
            ],
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: _studentsList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return generateList(snapshot.data as List<Student>);
                }
                if (snapshot.data == null ||
                    (snapshot.data as List<Student>).isEmpty) {
                  return const Text('No Data Found');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView generateList(List<Student> students) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('NAME'),
            ),
            DataColumn(
              label: Text('DELETE'),
            ),
          ],
          rows: students
              .map(
                (student) => DataRow(cells: [
                  DataCell(Text(student.name), onTap: () {
                    setState(() {
                      isUpdate = true;
                      studentIdForUpdate = student.id;
                    });
                    _studentNameController.text = student.name;
                  }),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        DBProvider.db.deleteStudent(student.id);
                        updateStudentList();
                      },
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }
}
