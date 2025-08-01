import 'dart:convert';
import 'dart:developer';
import 'package:broke_amusement/net.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class ReadCardButton extends StatefulWidget {
  final String hostUrl;
  const ReadCardButton({super.key, required this.hostUrl});

  @override
  State<ReadCardButton> createState() => _ReadCardButtonState();
}

class _ReadCardButtonState extends State<ReadCardButton> {
  bool reading = false;

  void cardscan(BuildContext context) async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      log("you are not sigma!");
      return;
    }

    // this should not be possible, but it's a failsafe
    if (reading) {
      return;
    }

    log("card scan start");
    setState(() { reading = true;});

    try {
      var tag = await FlutterNfcKit.poll(readIso18092: true);

      // TODO: don't print the idm on log
      log(jsonEncode(tag));

      if (tag.type == NFCTagType.iso7816) {
        // idk what to do with this
      }
      if (tag.type == NFCTagType.mifare_classic) {
        // TODO: option to virtualize a card?
        await FlutterNfcKit.authenticateSector(0, keyA: "FFFFFFFFFFFF");
        var data = await FlutterNfcKit.readBlock(0); // read one block
        print(data);
      }
      // iso18092 = FeliCa = what we want
      if (tag.type == NFCTagType.iso18092) {
        // rename variable to a more sensible name
        var idm = tag.id;
        var pmm = tag.manufacturer;
        
        sendMessage(widget.hostUrl, 11321, PacketType.cardScan, idm);
      }

      final cardReadMessage = SnackBar(
        content: const Text('Card Read Succcessful!')
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(cardReadMessage);
      }

    } catch (e) {
      //
    } finally {
      // Call finish() only once
      await FlutterNfcKit.finish();
    }

    setState(() { reading = false; });
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
      onPressed: reading ? null : () => cardscan(context) ,
      child: Text(
        reading ? "Reading..." : "Read Card",
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}
