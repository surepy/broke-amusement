import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';

enum PacketType {
  none, // bad data
  cardScan,
  coinInput,
  testButton,
  serviceButton,
  keypadInput,
}

void sendMessage(
  String host,
  int port,
  PacketType type,
  String? message,
) async {
  log('connecting to: $host:$port');
  try {
    // port is usually 11321
    final socket = await Socket.connect(host, port);
    log('Connected.');

    Uint8List data = Uint8List(17);

    data[0] = type.index;

    if (message != null) {
      Uint8List optData = utf8.encode(message);

      // warn because this is clearly not felica data, but still send it i guess
      if (type == PacketType.cardScan && optData.length != 16) {
        log("Warn: Card data.length != 16 (is ${optData.length}), data will likely be dropped", level: 3);
      }

      for (int i = 0; i < 16; i++) {
        data[i + 1] = optData[i];
      }
    }

    socket.add(data);
    log('Message sent: $data');
    socket.close();
  } catch (e) {
    log('Error: $e', error: e);
  }
}
