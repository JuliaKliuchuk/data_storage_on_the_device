import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// working with local files. read and write
// path_provider was used
class ReadWriteFile extends StatefulWidget {
  const ReadWriteFile({super.key});

  @override
  ReadWriteFileState createState() => ReadWriteFileState();
}

class ReadWriteFileState extends State<ReadWriteFile> {
  final TextEditingController _textController = TextEditingController();

  static const String kLocalFileName = 'demo_localfile.txt';
  String _localFileContent = '';
  String _localFilePath = kLocalFileName;

  @override
  void initState() {
    super.initState();
    _readDataFromLocalFile();
    _getLocalFile.then((file) => setState(() => _localFilePath = file.path));
  }

  @override
  Widget build(BuildContext context) {
    FocusNode textFieldFocusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey,
        title: const Text('Local file read/write Demo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const Text('Write to local file:', style: TextStyle(fontSize: 20)),
          TextField(
              focusNode: textFieldFocusNode,
              controller: _textController,
              maxLines: null,
              style: const TextStyle(fontSize: 20)),
          ButtonBar(
            children: <Widget>[
              MaterialButton(
                child: const Text('Load', style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  _readDataFromLocalFile();
                  _textController.text = _localFileContent;
                  FocusScope.of(context).requestFocus(textFieldFocusNode);
                  log('String successfuly laoded from local file');
                },
              ),
              MaterialButton(
                child: const Text('Save', style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  await _writeDataToLocalFile(_textController.text);
                  _textController.clear();
                  await _readDataFromLocalFile();
                  log('String successfuly written to local file');
                },
              ),
            ],
          ),
          const Divider(height: 20.0),
          Text('Local file path:',
              style: Theme.of(context).textTheme.titleLarge),
          Text(_localFilePath, style: Theme.of(context).textTheme.titleMedium),
          const Divider(height: 20.0),
          Text('Local file content:',
              style: Theme.of(context).textTheme.titleLarge),
          Text(_localFileContent,
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

// поиск пути к файлу
  Future<String> get _getLocalPath async {
    // путь к каталогу документов
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

// получаем ссылку на местоположение файла
  Future<File> get _getLocalFile async {
    final path = await _getLocalPath;
    return File('$path/$kLocalFileName');
  }

  // запись данных в файл
  Future<File> _writeDataToLocalFile(String text) async {
    final file = await _getLocalFile;
    return file.writeAsString(text);
  }

  //получение данных из файла
  Future _readDataFromLocalFile() async {
    String content;

    try {
      final file = await _getLocalFile;
      content = await file.readAsString();
    } catch (err) {
      content = 'Error loading local file: $err';
    }
    setState(() {
      _localFileContent = content;
    });
  }
}
