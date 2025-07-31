import 'package:flutter/material.dart';

class AddCoinButton extends StatefulWidget {
  final String hostUrl;

  const AddCoinButton({super.key, required this.hostUrl});

  @override
  State<AddCoinButton> createState() => _AddCoinButtonState();
}

class _AddCoinButtonState extends State<AddCoinButton> {
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
          color: Colors.white,
        ),
      ),
    );
  }
}
