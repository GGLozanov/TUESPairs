

import 'package:encrypt/encrypt.dart' as encrypt;

class Message{
  String mid;
  String content;
  String fromId;
  String toId;
  String sentTime;
  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(16);


  Message({this.mid, this.content, this.fromId, this.toId, this.sentTime});
  
  void encryptMessage(){
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    content = encrypter.encrypt(this.content, iv: iv).base64;
  }

  void decryptMessage(){
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    content = encrypter.decrypt64(content, iv: iv);
  }

}