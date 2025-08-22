import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

enum PacketType {
  none, // bad data
  cardScan,
  coinInput,
  testButton,
  serviceButton,
  keypadInput,
}

int encodeStringToInt64(String input) {
  // Convert the string to bytes (UTF-8 encoding)
  List<int> bytes = utf8.encode(input);

  // Ensure the byte list is exactly 8 bytes (64 bits)
  Uint8List paddedBytes = Uint8List(8);
  for (int i = 0; i < bytes.length && i < 8; i++) {
    paddedBytes[i] = bytes[i];
  }

  // Convert the bytes to an int64
  ByteData byteData = ByteData.sublistView(paddedBytes);
  return byteData.getInt64(0, Endian.little); // Use Endian.little if needed
}

Uint8List intToUint8List(BigInt value) {
  // Convert the integer to bytes (little-endian format)
  var byteData = ByteData(8); 
  byteData.setInt64(0, value.toInt(), Endian.big);
  return byteData.buffer.asUint8List();
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

    Uint8List data = Uint8List(9);

    data[0] = type.index;

    if (message != null) {
      var dataToSplit = BigInt.parse(message, radix: 16);
      Uint8List optData = intToUint8List(dataToSplit);

      // warn because this is clearly not felica data, but still send it i guess
      if (type == PacketType.cardScan && optData.length != 8) {
        log("Warn: Card data.length != 8 (is ${optData.length}), data will likely be dropped", level: 3);
      }

      for (int i = 0; i < 8; i++) {
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
