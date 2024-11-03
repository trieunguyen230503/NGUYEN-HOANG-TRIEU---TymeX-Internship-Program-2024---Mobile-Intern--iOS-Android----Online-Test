import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//Custome lại texfied nhập số
class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Chuyển đổi chuỗi sang số và định dạng lại
    final number = int.tryParse(newValue.text.replaceAll(',', ''));
    final formattedNumber = NumberFormat('#,##0', 'en_US').format(number);

    // Trả về giá trị mới
    return TextEditingValue(
      text: formattedNumber,
      selection: TextSelection.collapsed(offset: formattedNumber.length),
    );
  }
}

//Custome lại rate tỉ giá
String formatNumber(double number) {
  //Kiểm tra nếu có số phần thập phân
  bool hasDecimal = (number % 1 != 0);
  //Tạo NumberFormat tùy chỉnh
  final formatter =
      hasDecimal ? NumberFormat('#,###.##') : NumberFormat('#,###');
  return formatter.format(number);
}

