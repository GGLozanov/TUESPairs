import 'package:flutter_test/flutter_test.dart';
import 'package:tues_pairs/modules/tag.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tag', () {

    test('Creates two tag instances and compares their Ids', () {
      Tag tag1 = new Tag(tid: 'sameId!');
      Tag tag2 = new Tag(tid: 'sameId!');

      expect(tag1, tag2);
    });
  });
}