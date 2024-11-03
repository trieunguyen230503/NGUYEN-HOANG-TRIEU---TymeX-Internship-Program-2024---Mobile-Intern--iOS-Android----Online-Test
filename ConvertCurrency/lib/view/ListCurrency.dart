import 'dart:convert';
import 'package:convertcurrency/controller/API_Provider.dart';
import 'package:convertcurrency/utils/Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/ConstColor.dart';
import '../../utils/StarButon.dart';

class ListCurrency extends StatefulWidget {
  ListCurrency({
    super.key,
    required this.data,
    required this.countryFlags,
    required this.onToggle,
    required this.currencyPicker,
    required this.onCurrencySelected, // Callback mới
  });

  final data;
  final countryFlags;
  final VoidCallback onToggle;
  var currencyPicker;
  final Function(String) onCurrencySelected; // Định nghĩa kiểu cho callback

  @override
  State<ListCurrency> createState() => _ListCurrencyState();
}

class _ListCurrencyState extends State<ListCurrency> {
  final TextEditingController searchController = TextEditingController();
  Map<String, double> dataTemp = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Ban đầu gán danh sách gốc vào danh sách tạm
    dataTemp = widget.data.rates;
  }

  //Truy vấn các loại tiền tệ theo từ khóa
  Future performSearch(
      String keyword, Map<String, double> listCurrencyChoosen) async {
    Map<String, double> temp = {};
    if (keyword.isEmpty) {
      //Tạo bản sao từ Map ban đầu
      temp = dataTemp;
    } else {
      for (var currency in widget.data.rates.entries) {
        if (currency.key.toLowerCase().contains(keyword.toLowerCase())) {
          temp[currency.key] = currency.value;
        }
      }
    }

    print(dataTemp); // Kiểm tra kết quả tìm kiếm
    return temp;
  }

  void loadCurrencyChoosenList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).width * 0.06,
                  bottom: MediaQuery.sizeOf(context).width * 0.06),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02),
              height: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                    color: Colors.grey, width: 2.0, style: BorderStyle.solid),
              ),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) async {
                  dataTemp = await performSearch(value, {});
                  setState(() {});
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter a keyword",
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: Icon(
                    Icons.search,
                    size: MediaQuery.sizeOf(context).width * 0.075,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                removeAllCurrnecyFromList();
                widget.onToggle();
                setState(() {});
              },
              child: Container(
                child: const Text('Clear all'),
              ),
            ),
            Expanded(
                child: FutureBuilder<Map<String, double>>(
                    future: getListCurrencyChoosen(widget.data.rates),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            strokeWidth: 5,
                          ),
                        );
                      }
                      Map<String, double> listCurrencyChoosen = snapshot.data!;

                      return ListView.builder(
                          itemCount: dataTemp.length,
                          itemBuilder: (context, index) {
                            //Lấy key ra
                            String currency = dataTemp.keys.elementAt(index);
                            String? flagURI = widget.countryFlags[currency];

                            return InkWell(
                              onTap: () {
                                widget.onCurrencySelected(currency);
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.sizeOf(context).width * 0.02,
                                    top: MediaQuery.sizeOf(context).width *
                                        0.02),
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
                                        ? Image.memory(base64Decode(
                                            flagURI!.split(',')[1]))
                                        : Image.network(
                                            Config.flagDefault,
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.08,
                                            height: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.08,
                                          ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.05,
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
                                    listCurrencyChoosen.containsKey(currency)
                                        ? StarButton(
                                            isSelected: true,
                                            currency: currency,
                                            onToggle1: widget.onToggle,
                                            onToggle2: loadCurrencyChoosenList,
                                          )
                                        : StarButton(
                                            isSelected: false,
                                            currency: currency,
                                            onToggle1: widget.onToggle,
                                            onToggle2: loadCurrencyChoosenList,
                                          ),
                                  ],
                                ),
                              ),
                            );
                          });
                    })),
          ]),
    );
  }
}
