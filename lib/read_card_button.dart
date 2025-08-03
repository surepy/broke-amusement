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
    setState(() {
      reading = true;
    });

    try {
      var tag = await FlutterNfcKit.poll(readIso18092: true);

      // iso18092 = FeliCa = what we want
      if (tag.type == NFCTagType.iso18092) {
        // rename variable to a more sensible name
        var idm = tag.id;
        // unused
        // var pmm = tag.manufacturer;

        sendMessage(widget.hostUrl, 11321, PacketType.cardScan, idm);

        final cardReadMessage = SnackBar(
          content: const Text('Card Read Succcessful!'),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(cardReadMessage);
        }
      } else {
        // TODO: decide what I want to do with other card types that isn't felica
        // I can "virtualize" a card by copying ac_pico's implementation
        // (and preferred because people already use that impl)
        // but eh....

        // if (tag.type == NFCTagType.iso7816) {
        if (tag.type == NFCTagType.mifare_classic) {
          await FlutterNfcKit.authenticateSector(0, keyA: "FFFFFFFFFFFF");
          // var data = await FlutterNfcKit.readBlock(0); // read one block
        }

        // for now just return that it's unsupported
        final cardReadMessage = SnackBar(
          // TODO: better color
          backgroundColor: Colors.deepOrange,
          content: const Text('Unsupported Card Type.'),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(cardReadMessage);
        }
      }
    } catch (e) {
      // TODO better error handling
      log(e.toString());
      
      final cardReadMessage = SnackBar(content: const Text('Unknown Error'));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(cardReadMessage);
      }
    } finally {
      await FlutterNfcKit.finish();
    }

    setState(() {
      reading = false;
    });
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
      onPressed: reading ? null : () => cardscan(context),
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
