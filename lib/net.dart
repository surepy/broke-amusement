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

void sendMessage(String host, int port, PacketType type, String message) async {

  log('connecting to: ${host}:${port}');
  try {
    // port is usually 11321
    final socket = await Socket.connect(host, port);
    log('Connected.');

    Uint8List data = Uint8List(17);


    Uint8List cardData = utf8.encode(message);

    // warn because this is clearly not a felica data, but still send it i guess
    if (cardData.length != 16) {
      log("Warn: data.length != 16 (is ${cardData.length})", level: 3);
    }
    data[0] = type.index;
    for (int i = 0; i < 16; i++){
      data[i + 1] = cardData[i];
    }

    socket.add(data);
    print('Message sent: $data');
    socket.close();
  } catch (e) {
    print('Error: $e');
  }
}
