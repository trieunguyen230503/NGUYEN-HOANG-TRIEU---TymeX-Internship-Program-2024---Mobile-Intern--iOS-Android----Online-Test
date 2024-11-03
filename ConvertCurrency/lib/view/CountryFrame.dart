import 'dart:convert';

import 'package:convertcurrency/utils/Config.dart';
import 'package:flutter/material.dart';

import '../utils/ConstColor.dart';

class CountryFrame extends StatefulWidget {
  const CountryFrame(
      {super.key, required this.countryName, required this.flagURI});

  final countryName;
  final flagURI;

  @override
  State<CountryFrame> createState() => _CountryFrameState();
}

class _CountryFrameState extends State<CountryFrame> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: frameCountryColor, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.05),
      width: MediaQuery.sizeOf(context).width * 0.4,
      height: MediaQuery.sizeOf(context).height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width * 0.15,
            child: Text(
              widget.countryName,
              style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: wordColor,
                  height: 1.0),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          widget.flagURI != null
              ? Image.memory(
                  base64Decode(widget.flagURI!.split(',')[1]),

                )
              : Image.network(
                  Config.flagDefault,
                  width: MediaQuery.sizeOf(context).width * 0.1,
                  height: MediaQuery.sizeOf(context).width * 0.1,
                ),
        ],
      ),
    );
  }
}
