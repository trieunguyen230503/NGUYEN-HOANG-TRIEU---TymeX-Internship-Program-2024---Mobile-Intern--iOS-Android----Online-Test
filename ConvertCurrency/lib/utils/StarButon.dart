import 'package:convertcurrency/controller/API_Provider.dart';
import 'package:flutter/material.dart';

class StarButton extends StatefulWidget {
  StarButton(
      {super.key,
      required this.isSelected,
      required this.currency,
      required this.onToggle1,
      required this.onToggle2});

  var isSelected;
  final currency;
  final VoidCallback onToggle1;
  final VoidCallback onToggle2;

  @override
  _StarButtonState createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.isSelected = !widget.isSelected; // Đổi trạng thái khi nhấn

        if (widget.isSelected) {
          saveListCurrencyChoosen(widget.currency);
        } else {
          removeCurrnecyFromList(widget.currency);
        }
        widget.onToggle1();
        setState(() {});
        //widget.onToggle2();
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isSelected
              ? Colors.yellow
              : Colors.grey, // Màu nền tùy thuộc vào trạng thái
        ),
        padding: const EdgeInsets.all(10.0), // Khoảng cách xung quanh ngôi sao
        child: Icon(
          Icons.star,
          color: widget.isSelected ? Colors.white : Colors.black,
          // Màu ngôi sao tùy thuộc vào trạng thái
          size: MediaQuery.sizeOf(context).width *
              0.05, // Kích thước của ngôi sao
        ),
      ),
    );
  }
}
