import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:broke_amusement/add_coin_button.dart';
import 'package:broke_amusement/read_card_button.dart';
import 'package:broke_amusement/service_area.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // _hostnamecontroller.text
  final TextEditingController _hostnamecontroller = TextEditingController(
    text: "cadence.in.faca.dev",
  );
  String hostname = "";

  @override
  void initState() {
    super.initState();
    // Start listening to changes
    _hostnamecontroller.addListener(_saveHostName);hostname = _hostnamecontroller.text;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    // This also removes the _printLatestValue listener
    _hostnamecontroller.dispose();
    super.dispose();
  }

  void _saveHostName() {
    log(hostname);
    setState(() { hostname = _hostnamecontroller.text;});

    // TODO: Save _hostnamecontroller.text into something that saves the state
  }

  void _openNumpad() {  
    // TODO: open numpad impl
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.white60,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18.0, // Adjust the font size here
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: ListView(
                  children: [
                    // read card button
                    Padding(
                      padding: EdgeInsetsGeometry.only(bottom: 12),
                      child: ReadCardButton(hostUrl: hostname),
                    ),
                    // Coin
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AddCoinButton(hostUrl: hostname),
                    ),
                    // Hostname
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: TextField(
                        controller: _hostnamecontroller,
                        maxLines: 1,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          filled: true,
                          border: null,
                          labelText: '"Cabinet" ip / hostname',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 64),
                      child: ServiceArea(hostUrl: hostname),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNumpad,
        tooltip: 'Numpad',
        child: const Icon(Icons.numbers),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class KeypadButton extends StatelessWidget {
  const KeypadButton({super.key, required this.numKey});

  final String numKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: ElevatedButton(
        onPressed: () async {},
        child: Text(
          style: Theme.of(context).textTheme.displaySmall,
          numKey,
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
      ),
    );
  }
}

class KeypadWidget extends StatelessWidget {
  const KeypadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: null,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            KeypadButton(numKey: "1"),
            KeypadButton(numKey: "2"),
            KeypadButton(numKey: "3"),
          ],
        ),
        TableRow(
          children: <Widget>[
            KeypadButton(numKey: "3"),
            KeypadButton(numKey: "4"),
            KeypadButton(numKey: "5"),
          ],
        ),
        TableRow(
          children: <Widget>[
            KeypadButton(numKey: "6"),
            KeypadButton(numKey: "7"),
            KeypadButton(numKey: "8"),
          ],
        ),
        TableRow(
          children: <Widget>[
            KeypadButton(numKey: "0"),
            KeypadButton(numKey: "00"),
            // this button seems to exist, but always bound to nothing
            ElevatedButton(onPressed: null, child: Text('')),
          ],
        ),
      ],
    );
  }
}
