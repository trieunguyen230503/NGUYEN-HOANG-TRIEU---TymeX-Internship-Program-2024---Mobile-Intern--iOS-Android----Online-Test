import 'dart:convert';

import 'package:convertcurrency/controller/API_Provider.dart';
import 'package:convertcurrency/utils/FormatNumber.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/Config.dart';
import '../utils/ConstColor.dart';

class ListCurrencyChoosen extends StatefulWidget {
  const ListCurrencyChoosen(
      {super.key, required this.data, required this.countryFlags});

  final data;
  final countryFlags;

  @override
  State<ListCurrencyChoosen> createState() => _ListCurrencyChoosenState();
}

class _ListCurrencyChoosenState extends State<ListCurrencyChoosen> {
// Future kết hợp để lấy cả codeCurrency và listCurrency
  Future<Map<String, dynamic>> fetchCurrencyData() async {
    String codeCurrency = await getCurrencyFromShared(1) ?? 'VND';
    Map<String, double> listCurrencyChoosen =
        await getListCurrencyChoosen(widget.data.rates);

    //Lấy giá tiền người dùng chọn để nhân với các tỉ giá trong danh sách
    // 3 VND => 75K USD
    // 3 VND => 48 AUD
    String? currrentPrice = await getCurrentPrice();
    return {
      'codeCurrency': codeCurrency,
      'listCurrencyChoosen': listCurrencyChoosen,
      'currrentPrice': currrentPrice
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: fetchCurrencyData(),
        builder: (context, snapshot) {
          //Danh sách các currency người dùng muốn theo dõi
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: wordColor,
                strokeWidth: 5,
              ),
            ); // Hiển thị vòng quay khi đang chờ dữ liệu
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Hiển thị lỗi nếu có
          }
          if (snapshot.data!['listCurrencyChoosen'].length == 0) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: frameCountryColor,
              ),
              padding: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).width * 0.05,
                  right: MediaQuery.sizeOf(context).width * 0.05,
                  bottom: MediaQuery.sizeOf(context).width * 0.05),
              child: Text(
                'Choose more option',
                style: TextStyle(
                    fontSize: MediaQuery.sizeOf(context).width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: wordColor),
              ),
            ); // Hiển thị khi không có dữ liệu
          }
          Map<String, double> listCurrencyChoosen =
              snapshot.data!['listCurrencyChoosen'];
          //Lấy currency 1 (currency cần chuyển)
          String codeCurrency = snapshot.data!['codeCurrency'];
          double rateCodeCurrency = widget.data.rates[codeCurrency];

          // Lấy giá tiền người dùng đã nhập
          double currentPrice = double.parse(snapshot.data!['currrentPrice']);

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: frameCountryColor,
            ),
            padding: EdgeInsets.only(
                left: MediaQuery.sizeOf(context).width * 0.05,
                right: MediaQuery.sizeOf(context).width * 0.05,
                bottom: MediaQuery.sizeOf(context).width * 0.05),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: listCurrencyChoosen.length,
                        itemBuilder: (context, index) {
                          //Lấy key ra
                          String currency =
                              listCurrencyChoosen.keys.elementAt(index);
                          //Lấy value từ key đã lấy và chuyển đổi tỉ lệ
                          //currentPrice * Currency 2 / currency 1
                          double rate = currentPrice *
                              listCurrencyChoosen[currency]! /
                              rateCodeCurrency;

                          //Format tiền
                          String rateFormat = formatNumber(rate);

                          //Lấy ảnh cờ
                          String? flagURI = widget.countryFlags[currency];

                          return Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.sizeOf(context).width * 0.045,
                                top: MediaQuery.sizeOf(context).width * 0.045),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                color: wordColor.withOpacity(0.5),
                                width: 0.5,
                              )),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                flagURI != null
                                    ? Image.memory(
                                        base64Decode(flagURI!.split(',')[1]))
                                    : Image.network(
                                        Config.flagDefault,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.08,
                                        height:
                                            MediaQuery.sizeOf(context).width *
                                                0.08,
                                      ),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.05,
                                ),
                                Expanded(
                                    child: Text(
                                  currency,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.sizeOf(context).width *
                                              0.05,
                                      fontWeight: FontWeight.bold,
                                      color: wordColor),
                                )),
                                Text(
                                  rateFormat,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.sizeOf(context).width *
                                              0.04,
                                      color: wordColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ]),
          );
        });
  }
}
