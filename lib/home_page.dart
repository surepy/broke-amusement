import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  // temp function so i can figure out cardscan
  void cardscan() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      print("you are not sigma!");
      return;
    }

    print("card scan start");

    try {
      var tag = await FlutterNfcKit.poll(
        readIso18092: true,
        timeout: Duration(seconds: 20)
      );

      print(jsonEncode(tag));

      if (tag.type == NFCTagType.iso7816) {
        // idk what to do with this
      }
      if (tag.type == NFCTagType.mifare_classic) {
        // option to virtualize a card?
        await FlutterNfcKit.authenticateSector(0, keyA: "FFFFFFFFFFFF");
        var data = await FlutterNfcKit.readBlock(0); // read one block
        print(data);
      }
      // FeliCa
      if (tag.type == NFCTagType.iso18092) {
        // rename variable to a more sensible name
        var idm = tag.id;
        var pmm = tag.manufacturer;
      }
    } catch (e) {
      //
    }
    finally {
      // Call finish() only once
      await FlutterNfcKit.finish();
    }
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            const Text('Login'),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              child: ElevatedButton(
                onPressed: cardscan,
                style: ElevatedButton.styleFrom(
                  // fromHeight use double.infinity as width and 40 is the height
                  minimumSize: Size.fromHeight(40),
                ),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Start Scanning',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              child: KeypadWidget(),
            ),
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
