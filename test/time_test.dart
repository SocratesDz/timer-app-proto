import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test date operations', () {
    final date1 = DateTime.now().subtract(Duration(minutes: 10));
    print(date1.toIso8601String());
    expect(DateTime.now().difference(date1).inMinutes, 10);
  });
}