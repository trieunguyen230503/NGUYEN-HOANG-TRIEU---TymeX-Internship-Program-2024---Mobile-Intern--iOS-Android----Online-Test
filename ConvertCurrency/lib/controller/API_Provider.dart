import 'dart:convert';
import 'package:convertcurrency/model/Currency.dart';
import 'package:convertcurrency/utils/Config.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<CurrencyData?> fetchAndStoreCurrencyData(bool hasInternet) async {
  final prefs = await SharedPreferences.getInstance();
  String? storedData = prefs.getString('currencyData');

  // Nếu có mạng, tiến hành gọi API
  print(hasInternet);
  if (hasInternet) {
    final response = await http.get(Uri.parse(Config.ExchangeratesApi));
    print(response.statusCode);
    if (response.statusCode == 200) {
      // Parse dữ liệu JSON từ API
      CurrencyData currency = CurrencyData.fromJson(json.decode(response.body));
      // Lưu dữ liệu mới vào SharedPreferences
      await prefs.setString('currencyData', response.body);
      return currency;
    } else {
      throw Exception('Không thể tải dữ liệu từ API');
    }
  }

  // Nếu không có mạng hoặc gọi API thất bại, trả về dữ liệu từ SharedPreferences
  if (storedData != null) {
    print('Không mạng nè');
    print(storedData);
    return CurrencyData.fromJson(json.decode(storedData));
  } else {
    return null;
  }
}

Future<Map<String, String>> fetchImageCountry() async {
  // Đọc file JSON từ assets
  String jsonString =
      await rootBundle.loadString('assets/currencies-with-flags.json');
  final List<dynamic> jsonResponse = json.decode(jsonString);

  Map<String, String> tempCountryFlags = {}; // Tạo một map tạm thời

  for (var currency in jsonResponse) {
    // Kiểm tra và đảm bảo dữ liệu không null
    if (currency['code'] != null && currency['flag'] != null) {
      // Gán mã tiền tệ là key và cờ là value
      tempCountryFlags[currency['code']] = currency['flag'];
    }
  }
  return tempCountryFlags;
}

//Lấy các phần tử từ danh sách đã lưu
Future<Map<String, double>> getListCurrencyChoosen(currencyData) async {
  Map<String, double> listCurrencyChoosen = {};
  final prefs = await SharedPreferences.getInstance();
  String? stored = prefs.getString('listcurrencychoosen');
  if (stored == null) {
    return listCurrencyChoosen;
  }

  //Thêm các currency được chọn vào map mới từ currencyData
  if (stored != null) {
    List<String> selectedCurrencies = stored.split(' ');

    for (var currency in currencyData.keys) {
      if (selectedCurrencies.contains(currency)) {
        listCurrencyChoosen[currency] = currencyData[currency]!;
      }
    }
  }

  return listCurrencyChoosen;
}

Future saveListCurrencyChoosen(String currency) async {
  final prefs = await SharedPreferences.getInstance();
  //Lấy danh sách các code currency đã lưu vào danh sách chọn mặc định
  String? stored = prefs.getString('listcurrencychoosen');
  //Nếu chưa có thì tạo ra và thêm vào
  if (stored == null) {
    //Lưu vào sharepreference
    prefs.setString('listcurrencychoosen', '$currency ');
    //Gán giá trị mới vào stored
    stored = '$currency ';
  } else {
    //Lưu vào sharepreference
    prefs.setString('listcurrencychoosen', '$currency $stored');
    //Gán giá trị mới vào stored
    stored = '$currency $stored';
  }
}

Future removeCurrnecyFromList(String currency) async {
  final prefs = await SharedPreferences.getInstance();
  String? stored = prefs.getString('listcurrencychoosen');

  //Vì đã được chọn thì mới remove được nên chắc chắn khác null
  //Loại currency khỏi danh sách và lưu lại
  prefs.setString('listcurrencychoosen', stored!.replaceAll('$currency ', ''));
}

Future removeAllCurrnecyFromList() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('listcurrencychoosen');
}

// index = 1 là nước làm gốc
// indx = 2 là nước được chuyển qua
Future getCurrencyFromShared(int index) async {
  final prefs = await SharedPreferences.getInstance();

  String? currency = prefs.getString('country$index');

  // Kiểm tra giá trị của index để quyết định giá trị trả về
  if (currency == null) {
    if (index == 1) {
      return 'VND'; // Trả về 'VND' nếu index là 1
    } else if (index == 2) {
      return 'USD'; // Trả về 'USD' nếu index là 2
    }
  }

  // Nếu không phải null, trả về giá trị từ SharedPreferences
  return currency!;
}

//index là nước làm gốc hay được chuyển qua
//codeCurrency là mã tiền tệ
Future updateCurrencyShared(int index, String codeCurrency) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('country$index', codeCurrency);
}

//Lưu lại giá tiền người dùng nhập
Future saveCurrentPrice(double currentPrice) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setDouble('currentPrice', currentPrice);
}

//Lấy ra giá tiền người ta đã nhập
Future<String> getCurrentPrice() async {
  final prefs = await SharedPreferences.getInstance();
  double? currentPrice = prefs.getDouble('currentPrice');
  if (currentPrice != null) {
    return currentPrice.toString();
  } else {
    return '1';
  }
}
