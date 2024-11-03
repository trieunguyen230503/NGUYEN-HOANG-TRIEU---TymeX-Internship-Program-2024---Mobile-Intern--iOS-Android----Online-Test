class CurrencyData {
  final String date;
  final int timeStamp;
  final Map<String, double> rates;

  CurrencyData(
      {required this.date,
      required this.rates,
      required this.timeStamp});

  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    //Chuyển đổi các tỷ giá sang Map
    Map<String, double> rates = {};

    (json['rates'] as Map<String, dynamic>).forEach((key, value) {
      rates[key] =
          value is double ? value : double.tryParse(value.toString()) ?? 0.0;
    });
    return CurrencyData(
        date: json['date'],
        rates: rates,
        timeStamp: json['timestamp']);
  }
}
