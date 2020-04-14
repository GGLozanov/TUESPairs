import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';

class Message {
  String mid;
  String content;
  String fromId;
  String toId;
  String sentTime;

  final key = encrypt.Key.fromLength(32); // key
  final iv = encrypt.IV.fromLength(16); // initialization vector

  Message({this.mid, @required this.content, @required this.fromId, @required this.toId, @required this.sentTime});
  
  void encryptMessage() {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    content = encrypter.encrypt(this.content, iv: iv).base64;
  }

  void decryptMessage() {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    content = encrypter.decrypt64(content, iv: iv);
  }

  @override
  bool operator ==(other) {
    return other is Message ? mid == other.mid : false;
  }

}