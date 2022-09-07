import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferece extends StatefulWidget {
  const SharedPreferece({super.key});

  @override
  SharedPrefereceState createState() => SharedPrefereceState();
}

class SharedPrefereceState extends State<SharedPreferece> {
  late SharedPreferences _prefs;

  static const String kNumberPrefKey = 'number_pref';
  static const String kBoolPrefKey = 'bool_pref';

  int _numberPref = 0;
  bool _boolPref = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _prefs = prefs);
      _loadNumberPref();
      _loadBoolPref();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey,
        title: const Text('Shared Preference Demo'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(children: <Widget>[
                const Text('Number Preference'),
                Text('$_numberPref'),
                ElevatedButton(
                  child: const Text('Increment'),
                  onPressed: () => _setNumberPref(_numberPref + 1),
                ),
              ]),
              TableRow(children: <Widget>[
                const Text('Boolean Preference'),
                Text('$_boolPref'),
                ElevatedButton(
                  child: const Text('Toogle'),
                  onPressed: () => _setBoolPref(!_boolPref),
                ),
              ]),
            ],
          ),
          ElevatedButton(
            child: const Text('Reset Data'),
            onPressed: () => _resetDataPref(),
          ),
        ],
      ),
    );
  }

// загрузка _numberPref в хранилище
  Future<void> _setNumberPref(int value) async {
    await _prefs.setInt(kNumberPrefKey, value);
    _loadNumberPref();
  }

// загрузка _boolPref в хранилище
  Future<void> _setBoolPref(bool value) async {
    await _prefs.setBool(kBoolPrefKey, value);
    _loadBoolPref();
  }

// загрузка _numberPref их хранилища
  void _loadNumberPref() {
    setState(() {
      _numberPref = _prefs.getInt(kNumberPrefKey) ?? 0;
    });
  }

// загрузка _boolPref их хранилища
  void _loadBoolPref() {
    setState(() {
      _boolPref = _prefs.getBool(kBoolPrefKey) ?? false;
    });
  }

  Future<void> _resetDataPref() async {
    await _prefs.remove(kNumberPrefKey);
    await _prefs.remove(kBoolPrefKey);
    _loadNumberPref();
    _loadBoolPref();
  }
}
