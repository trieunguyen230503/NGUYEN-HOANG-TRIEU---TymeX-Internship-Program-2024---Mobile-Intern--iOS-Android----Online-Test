import 'package:convertcurrency/controller/API_Provider.dart';
import 'package:convertcurrency/utils/FormatNumber.dart';
import 'package:convertcurrency/view/CountryFrame.dart';
import 'package:convertcurrency/view/ListCurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/ConstColor.dart';
import '../utils/ConvertFunction.dart';
import '../utils/SnackBar.dart';

class CurrencyConvert extends StatefulWidget {
  const CurrencyConvert(
      {super.key,
      required this.countryFlags,
      required this.data,
      required this.onToggle});

  final countryFlags;
  final data;
  final VoidCallback onToggle;

  @override
  State<CurrencyConvert> createState() => _CurrencyConvertState();
}

class _CurrencyConvertState extends State<CurrencyConvert> {
  final inputAmountOfMoney = TextEditingController();
  String currency1 = 'VND';
  String currency2 = 'USD';
  double rate1 = 0;
  double rate2 = 0;

  double fontsize = 20;

  //Thiết lập các giá trị ban đầu
  Future getCurrency() async {
    inputAmountOfMoney.text = await getCurrentPrice();
    currency1 = await getCurrencyFromShared(1);
    currency2 = await getCurrencyFromShared(2);
    rate1 = await widget.data.rates[currency1];
    rate2 = await widget.data.rates[currency2];
    fontsize = MediaQuery.sizeOf(context).width * 0.05;
  }

  //Hàm thực hiện chọn các đất nước 1 và 2 theo mong muốn
  //Không được chọn 2 nước giống nhau
  void _showCurrencySelector(BuildContext context, String currentCurrency) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.8,
          child: ListCurrency(
            data: widget.data,
            countryFlags: widget.countryFlags,
            onToggle: widget.onToggle,
            currencyPicker: currentCurrency,
            //Chuyển hàm onCurrencySelected vô constructor ListCurrency để update currency1 || currency2
            onCurrencySelected: (currencyPicker) {
              // Cập nhật currency1 hoặc currency2 dựa trên currencyPicker
              if (currentCurrency == currency1) {
                //Chọn currency thứ 1 trùng với currency 2
                if (currencyPicker == currency2) {
                  openSnackbar(
                      context, 'Please choose different country', Colors.red);
                } else {
                  //Cập nhật lại giá trị trong Shared
                  updateCurrencyShared(1, currencyPicker);
                  setState(() {
                    currency1 = currencyPicker;
                  });
                }
              } else if (currentCurrency == currency2) {
                //Chọn currency thứ 2 trùng với currency 1
                if (currencyPicker == currency1) {
                  openSnackbar(
                      context, 'Please choose different country', Colors.red);
                } else {
                  //Cập nhật lại giá trị trong Shared
                  updateCurrencyShared(2, currencyPicker);
                  setState(() {
                    currency2 = currencyPicker;
                  });
                }
              }
            },
          ),
        );
      },
      isScrollControlled: true,
    ).then((value) {
      // Gọi setState để làm mới giao diện khi BottomSheet đóng
      widget.onToggle();
    });
  }

  //Hiển thị Dialog để nhập só liệu
  Future<void> showInputDialog(BuildContext context) async {
    inputAmountOfMoney.text =
        formatNumber(double.parse(inputAmountOfMoney.text));
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              "Enter amount",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: primaryColor,
          content: TextFormField(
            keyboardType: TextInputType.number,
            controller: inputAmountOfMoney,
            inputFormatters: [
              NumberTextInputFormatter(),
              LengthLimitingTextInputFormatter(21),
            ],
            onChanged: (value) {
              if (value.length == 21) {
                openSnackbar(context, 'The number is maximized', Colors.red);
              }
            },
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Please fill money',
              hintStyle:
                  TextStyle(fontSize: MediaQuery.sizeOf(context).width * 0.03),
            ),
            style: TextStyle(
              fontSize: fontsize,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                  setState(() {});
                },
                child: const Text("Confirm"),
              ),
            ),
          ],
        );
      },
    );
  }

  Future exchangeCurrecyPosition(double convertedAmount) async {
    // Đổi chỗ hai giá trị
    String temp = currency1;
    currency1 = currency2;
    currency2 = temp;

    inputAmountOfMoney.text = formatNumber(convertedAmount);

    //Update currncy 1, 2 vào Sharepreference;
    await updateCurrencyShared(1, currency1);
    await updateCurrencyShared(2, currency2);

    setState(() {});
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCurrency(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 5,
              ),
            );
          }
          // Lấy tỷ giá và số tiền
          double amount = inputAmountOfMoney.text.isNotEmpty
              ? double.parse(inputAmountOfMoney.text.replaceAll(',', ''))
              : 1;
          double convertedAmount = convert(amount, rate1, rate2);
          String rateFormat = formatNumber(convertedAmount);

          return Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.4,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        _showCurrencySelector(context, currency1);
                      },
                      child: CountryFrame(
                        countryName: currency1,
                        flagURI: widget.countryFlags[currency1],
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          _showCurrencySelector(context, currency2);
                        },
                        child: CountryFrame(
                            countryName: currency2,
                            flagURI: widget.countryFlags[currency2])),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.1,
                  height: MediaQuery.sizeOf(context).width * 0.1,
                  child: ElevatedButton(
                      onPressed: () async {
                        await exchangeCurrecyPosition(convertedAmount);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(), // Hình tròn
                        padding: EdgeInsets.all(
                            MediaQuery.sizeOf(context).width * 0.02),
                        backgroundColor: primaryColor,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.currency_exchange,
                          color: coinColor,
                          size: MediaQuery.sizeOf(context).width * 0.05,
                        ),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        await showInputDialog(context);
                        //Lưu currentPrice vào Shared
                        await saveCurrentPrice(double.parse(
                            inputAmountOfMoney.text.replaceAll(',', '')));
                        widget.onToggle();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: frameCountryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(
                            MediaQuery.sizeOf(context).width * 0.05),
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        height: MediaQuery.sizeOf(context).height * 0.15,
                        child: Text(
                            inputAmountOfMoney.text.isNotEmpty
                                ? formatNumber(
                                    double.parse(inputAmountOfMoney.text))
                                : '1',
                            style: TextStyle(
                                fontSize: fontsize -
                                    inputAmountOfMoney.text.length * 0.5,
                                fontWeight: FontWeight.bold,
                                color: wordColor)),
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: frameCountryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(
                            MediaQuery.sizeOf(context).width * 0.05),
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        height: MediaQuery.sizeOf(context).height * 0.15,
                        child: Text(
                          rateFormat,
                          style: TextStyle(
                              fontSize: fontsize - rateFormat.length * 0.5,
                              fontWeight: FontWeight.bold,
                              color: wordColor),
                        ))
                  ],
                ),
              ],
            ),
          );
        });
  }
}
