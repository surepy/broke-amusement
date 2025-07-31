import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class ReadCardButton extends StatefulWidget {
  final String hostUrl;

  const ReadCardButton({super.key, required this.hostUrl});

  @override
  State<ReadCardButton> createState() => _ReadCardButtonState();
}

class _ReadCardButtonState extends State<ReadCardButton> {
 

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
          color: Colors.white,
        ),
      ),
    );
  }
}
