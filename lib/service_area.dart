import 'package:broke_amusement/service_buttons.dart';
import 'package:flutter/material.dart';

class ServiceArea extends StatefulWidget {
  final String hostUrl;

  const ServiceArea({super.key, required this.hostUrl});

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
        ServiceButtons(hostUrl: widget.hostUrl, unlocked: _unlocked),
      ],
    );
  }
}