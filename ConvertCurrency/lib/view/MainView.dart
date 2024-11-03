import 'dart:convert';

import 'package:convertcurrency/provider/Internet_Provider.dart';
import 'package:convertcurrency/utils/ConstColor.dart';
import 'package:convertcurrency/view/CountryFrame.dart';

import 'package:convertcurrency/view/ListCurrencyChoosen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/Currency.dart';
import '../../controller/API_Provider.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:http/http.dart' as http;

import '../../utils/Config.dart';
import 'CurrencyConvert.dart';
import 'ListCurrencyChoosen.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.countryFlags});

  final countryFlags;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  var currencyData;
  bool checkdata = false;
  Map<String, double> listCurrencyChoosen = {};
  ValueNotifier<Map<String, double>> listCurrencyChoosenNotifier =
      ValueNotifier({});

// Cập nhật danh sách mới ở đây
  void loadCurrencyList() {
    listCurrencyChoosenNotifier.value = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<InternetProvider>(
          builder: (context, internetProvider, child) {
        return FutureBuilder<CurrencyData?>(
            future: fetchAndStoreCurrencyData(internetProvider.hasInternet),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: wordColor,
                    strokeWidth: 5,
                  ),
                );
              } else if (snapshot.data == null) {
                // Không có mạng, và mới cài app lần đầu
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.red, size: 50),
                      SizedBox(height: 10),
                      Text("No Internet Connection",
                          style: TextStyle(color: Colors.red)),
                    ],
                  ),
                );
              }
              CurrencyData data = snapshot.data!;

              //Lấy timestampt để đổi qua thời gian
              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(data.timeStamp * 1000);
              String formattedDate =
                  "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} "
                  "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

              return Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.06),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Phần thông tin cập nhật
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.sizeOf(context).width * 0.03),
                          alignment: Alignment.center,
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!internetProvider.hasInternet)
                                  Container(
                                    margin: EdgeInsets.only(
                                        right:
                                            MediaQuery.sizeOf(context).width *
                                                0.02),
                                    child: Icon(
                                      Icons.wifi_off,
                                      color: Colors.red,
                                      size: MediaQuery.sizeOf(context).width *
                                          0.05,
                                    ),
                                  ),
                                Text(
                                  'Lastest updated $formattedDate',
                                  style: TextStyle(
                                      color: thirdColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                        ),
                        // Phần chuyển đổi tiền tệ giữa 2 nước
                        CurrencyConvert(
                          countryFlags: widget.countryFlags,
                          data: data,
                          onToggle: loadCurrencyList,
                        ),
                        // Phần danh sách các loại tiền tệ khác
                        Expanded(
                            child: ValueListenableBuilder<Map<String, double>>(
                          valueListenable: listCurrencyChoosenNotifier,
                          builder: (context, listCurrencyChoosen, _) {
                            return ListCurrencyChoosen(
                              data: data,
                              countryFlags: widget.countryFlags,
                            );
                          },
                        )),
                      ],
                    ),
                  ));
            });
      }),
    );
  }
}
