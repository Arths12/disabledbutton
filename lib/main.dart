import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DisabledButtonPage(),
    );
  }
}

class DisabledButtonPage extends StatefulWidget {
  const DisabledButtonPage({super.key});

  @override
  State<DisabledButtonPage> createState() => _DisabledButtonPageState();
}

class _DisabledButtonPageState extends State<DisabledButtonPage> {
  SharedPreferences? _prefs;
  bool? _isButtonDisabled;

  @override
  void initState() {
    super.initState();
    _loadButtonStatus();
  }

  void _loadButtonStatus() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs!.reload();
      _isButtonDisabled = _prefs!.getBool('isButtonDisabled') ?? false;
    });
  }

  void _disableButton() async {
   bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apakah Anda Yakin Melamar Pekerjaan ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Iya'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _isButtonDisabled = true;
      });
      await _prefs!.setBool('isButtonDisabled', true);
    }
  }

  void _enableButton() async {
    setState(() {
      _isButtonDisabled = false;
    });
    await _prefs!.setBool('isButtonDisabled', false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SafeArea(
                minimum: EdgeInsets.all(5),
                child: Column(
                  children: [
                    SizedBox(
                        width: 100,
                        child: ElevatedButton(
                            onPressed:  _isButtonDisabled == true ? null : _disableButton, child: Text("Hire"))),
                    SizedBox(
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              _enableButton();
                            }, child: Text("Cancel"))),
                    SizedBox(
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              _enableButton();
                            }, child: Text("Reject"))),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
