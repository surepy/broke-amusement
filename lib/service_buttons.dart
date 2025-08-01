import 'package:flutter/material.dart';

class ServiceButtons extends StatefulWidget {
  const ServiceButtons({super.key, required this.hostUrl, required this.unlocked});
  final String hostUrl;
  final bool unlocked;

  @override
  State<StatefulWidget> createState() => _ServiceButtonsState();
}

class _ServiceButtonsState extends State<ServiceButtons> {
  void serviceButton() async {

  }

  void testButton() async {

    
  }

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
