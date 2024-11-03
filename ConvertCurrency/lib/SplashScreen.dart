import 'package:convertcurrency/controller/API_Provider.dart';
import 'package:convertcurrency/utils/Config.dart';
import 'package:convertcurrency/utils/ConstColor.dart';
import 'package:convertcurrency/utils/Next_Screen.dart';
import 'package:convertcurrency/view/MainView.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Map<String, String> countryFlags = {}; // Danh sách lưu trữ các loại tiền tệ

  Future getImageCountry() async {
    countryFlags = await fetchImageCountry();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getImageCountry().then((value) => {
          nextScreenReplace(
              context,
              MainView(
                countryFlags: countryFlags,
              ))
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      color: primaryColor,
      child: Center(
        child: Image.asset(
          Config.logo,
          width: MediaQuery.sizeOf(context).height * 0.5,
          height: MediaQuery.sizeOf(context).width * 0.5,
        ),
      ),
    ));
  }
}
