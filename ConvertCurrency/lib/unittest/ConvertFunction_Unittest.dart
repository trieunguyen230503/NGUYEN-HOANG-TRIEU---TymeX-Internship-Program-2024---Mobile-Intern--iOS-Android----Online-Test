import 'package:flutter_test/flutter_test.dart';
import '../utils/ConvertFunction.dart';

void main() {
  group('Currency Conversion', () {
    test('Trường hợp 3 số đều là số dương', () {
      final amount = 100.0; // Số tiền người dng muốn chuyển đổi
      final rate1 = 1.0; // Tỷ giá đầu vào
      final rate2 = 2.0; // Tỷ giá đầu ra

      // Gọi hàm convert (lib/utils/ConvertFunction.dart)
      final result = convert(amount, rate1, rate2);

      expect(result, 200.0);
    });

    test('Trường hợp amount là 0', () {
      final amount = 0.0;
      final rate1 = 1.0;
      final rate2 = 2.0;

      final result = convert(amount, rate1, rate2);

      expect(result, 0.0);
    });

    test('Trường hợp amount là số âm', () {
      final amount = -50.0;
      final rate1 = 1.0;
      final rate2 = 2.0;

      final result = convert(amount, rate1, rate2);

      expect(result, -1);
    });
  });
}
