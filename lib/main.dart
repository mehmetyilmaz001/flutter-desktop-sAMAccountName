import 'dart:io';

import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  var _samAccountName = '';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();

    _getSamAccountName();
  }

  _getSamAccountName() async {
    var shell = Shell();
    final List<ProcessResult> res = await shell.run('klist');
    final samAccountName = _parsePrincipal(res);
    setState(() {
      _samAccountName = samAccountName;
    });
  }

  _parsePrincipal(List<ProcessResult> res) {
    String samAccountName = '';
    for (var element in res) {
      if (element.exitCode == 0) {
        final String stdout = element.stdout;

        stdout.split('\n').forEach((stdoutEl) {
          final trimmed = stdoutEl.trim().toLowerCase();
          if (trimmed.contains('principal:')) {
            samAccountName = trimmed.split(":")[1];
            // print('Sam AccountName $samAccountName');

          }
        });
      }
    }

    return samAccountName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text('Found Account Name: $_samAccountName')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
