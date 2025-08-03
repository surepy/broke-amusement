import 'package:broke_amusement/net.dart';
import 'package:flutter/material.dart';

///
/// Free Money Printer
/// 
/// Every time you press this button S*g* or K*n*mi loses a dollar (this is verified truth)
///
class AddCoinButton extends StatefulWidget {
  final String hostUrl;

  const AddCoinButton({super.key, required this.hostUrl});

  @override
  State<AddCoinButton> createState() => _AddCoinButtonState();
}

class _AddCoinButtonState extends State<AddCoinButton> {
  void addcoin() async {
    sendMessage(widget.hostUrl, 11321, PacketType.coinInput, null);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(28),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        minimumSize: Size.fromHeight(125),
      ),
      onPressed: addcoin,
      child: Text(
        "Add Coin",
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
