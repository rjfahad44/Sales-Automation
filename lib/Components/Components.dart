import 'package:flutter/material.dart';
import 'package:sales_automation/global.dart';

class MyTextView extends StatelessWidget {
  final String text;
  final double textSize;
  final FontWeight width;
  final Color color;
  final TextAlign textAlign;

  MyTextView(this.text, this.textSize, this.width, this.color, this.textAlign);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: width,
          color: color,
        ),
        textAlign: textAlign,
      ),
    );
  }
}

class MyAssetImageView extends StatelessWidget {
  // final double len;
  final String assetPath;

  MyAssetImageView(this.assetPath);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // height: len,
        child: Image(image: AssetImage(assetPath)),
      ),
    );
  }
}


ButtonStyle appButtonStyle(double width) {
  return ElevatedButton.styleFrom(
      elevation: 3,
      minimumSize: Size(width, 40),
      backgroundColor: primaryButtonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ));
}

ButtonStyle secondaryButtonStyle(double width) {
  return ElevatedButton.styleFrom(
      elevation: 3,
      minimumSize: Size(width, 40),
      backgroundColor: secondaryButtonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ));
}

Widget buildTextField(TextEditingController controller, String hint,
    IconData icon, bool obsSecure, int maxLine, TextInputType type) {
  return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: TextField(
        controller: controller,
        maxLines: maxLine,
        obscureText: obsSecure,
        keyboardType: type,
        cursorColor: Colors.black,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        decoration: InputDecoration(
          hoverColor: Colors.black12,
          fillColor: Colors.white,
          focusColor: Colors.black,
          filled: true,
          focusedBorder: ////UnderlineInputBorder(),
          OutlineInputBorder(
              gapPadding: 6,
              borderRadius: BorderRadius.circular(5.0),
              borderSide:
              const BorderSide(color: Colors.black, width: 2.0)),
          enabledBorder: //UnderlineInputBorder(),
          OutlineInputBorder(
              gapPadding: 6,
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0)),
          labelText: hint,
          labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
          // prefixIcon: Icon(icon, color: Colors.black54)
        ),
      ));
}
