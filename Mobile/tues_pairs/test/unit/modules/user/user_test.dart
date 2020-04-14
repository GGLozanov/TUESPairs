import 'package:flutter_test/flutter_test.dart';
import 'package:tues_pairs/modules/student.dart';
import 'package:tues_pairs/modules/teacher.dart';
import 'package:tues_pairs/modules/user.dart';

void main() {

  group('User', () {
    test('Creates a user instance', () {
      User user1 = new User(uid: 'sameId!');

      expect(user1, isA<User>());
    });

    test('Creates two user instances and compares their Ids', () {
      User user1 = new User(uid: 'sameId!');
      User user2 = new User(uid: 'sameId!');

      expect(user1, user2);
    });

    test('Creates two student instances and compares their Ids', () {
      Student student1 = new Student(uid: 'sameId!');
      Student student2 = new Student(uid: 'sameId!');

      expect(student1, student2);
    });

    test('Throws exception upon failed student instance creation (isTeacher = true)', () {
      expect(() => new Student(uid: 'sameId!', isTeacher: true), throwsA(isA<AssertionError>()));
    });

    test('Creates two teacher instances and compares their Ids', () {
      Teacher teacher1 = new Teacher(uid: 'sameId!');
      Teacher teacher2 = new Teacher(uid: 'sameId!');

      expect(teacher1, teacher2);
    });

    test('Throws exception upon failed teacher instance creation (isTeacher = false)', () {
      expect(() => new Teacher(uid: 'sameId!', isTeacher: false), throwsA(isA<AssertionError>()));
    });

    // TODO: Add tests for specific functionality later on

  });
}
