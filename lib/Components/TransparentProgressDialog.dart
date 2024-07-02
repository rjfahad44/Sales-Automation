
import 'package:flutter/material.dart';
import 'package:sales_automation/global.dart';


void showTransparentProgressDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const TransparentProgressDialog();
    },
  );
}

void hideTransparentProgressDialog(BuildContext context) {
  Navigator.of(context).pop();
}


class TransparentProgressDialog extends StatelessWidget {
  const TransparentProgressDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff095f98)),
        ),
      ),
    );
  }
}
