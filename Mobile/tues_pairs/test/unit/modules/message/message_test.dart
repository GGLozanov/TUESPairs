import 'package:flutter_test/flutter_test.dart';
import 'package:tues_pairs/modules/message.dart';

void main() {

  group('Message', () {
    test('Creates a message instance', () {
      Message message = new Message(mid: 'SameId!');

      expect(message, isA<Message>());
    });

    test('Creates two message instances and compares them by their Id', () {
      Message message1 = new Message(mid: 'SameId!');
      Message message2 = new Message(mid: 'SameId!');

      expect(message1, message2);
    });

    test('Encrypts and decrypts a message', () {
      Message message = new Message(mid: 'SameId!', content: 'RandContent', fromId: 'senderId', toId: 'receiverId', sentTime: '04/10/2002');

      String originalMessage = message.content;
      message.encryptMessage();
      message.decryptMessage();

      expect(originalMessage, equals(message.content));
    });
  });
}
