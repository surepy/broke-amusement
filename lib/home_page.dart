import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _hostnamecontroller = TextEditingController(
    text: "cadence.in.faca.dev",
  );

  void _openNumpad() {}

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
                      child: ReadCardButton(),
                    ),
                    // Coin
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AddCoinButton(),
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
                      child: ServiceArea(),
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

class ReadCardButton extends StatelessWidget {
  const ReadCardButton({super.key});

  void cardscan() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      print("you are not sigma!");
      return;
    }

    print("card scan start");

    try {
      var tag = await FlutterNfcKit.poll(readIso18092: true);

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
    } finally {
      // Call finish() only once
      await FlutterNfcKit.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(28),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        // fromHeight use double.infinity as width and 40 is the height
        minimumSize: Size.fromHeight(175),
      ),
      onPressed: cardscan,
      child: Text(
        "Read Card",
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 25,
          color: Colors.white
        ),
      ),
    );
  }
}

class AddCoinButton extends StatelessWidget {
  const AddCoinButton({super.key});

  void addcoin() async {}

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(28),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        // fromHeight use double.infinity as width and 40 is the height
        minimumSize: Size.fromHeight(125),
      ),
      onPressed: addcoin,
      child: Text(
        "Add Coin",
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: Colors.white
        ),
      ),
    );
  }
}

class ServiceArea extends StatefulWidget {
  const ServiceArea({super.key});

  @override
  State<StatefulWidget> createState() => _ServiceAreaState();
}

class _ServiceAreaState extends State<ServiceArea> {
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: SizedBox(
            width: double.infinity,
            child: SwitchListTile(
              title: const Text('Service Button Unlock'),
              value: _unlocked,
              onChanged: (bool value) {
                setState(() {
                  _unlocked = value;
                });
              },
            ),
          ),
        ),
        ServiceButtons(unlocked: _unlocked),
      ],
    );
  }
}

class ServiceButtons extends StatefulWidget {
  const ServiceButtons({super.key, required this.unlocked});

  final bool unlocked;

  @override
  State<StatefulWidget> createState() => _ServiceButtonsState();
}

class _ServiceButtonsState extends State<ServiceButtons> {
  void serviceButton() async {}

  void testButton() async {}

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              minimumSize: Size.fromHeight(42),
            ),
            onPressed: widget.unlocked ? serviceButton : null,
            child: Text("Service"),
          ),
        ),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              minimumSize: Size.fromHeight(42),
            ),
            onPressed: widget.unlocked ? testButton : null,
            child: Text("Test"),
          ),
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
