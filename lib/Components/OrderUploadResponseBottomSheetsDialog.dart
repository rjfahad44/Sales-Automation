
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_automation/global.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Screens/ImageCaptureScreen/Model/ImageUploadResponse.dart';
import '../Screens/Order/Models/OrderSendResponse.dart';
import 'Components.dart';


Future<T?> showBottomSheetDialog<T>(BuildContext context, OrderSendResponse response, Function() callBack) async {
  return await showModalBottomSheet<T>(
    context: context,
    isDismissible: false,
    builder: (context) => CustomBottomSheetsDialog(response: response, callBack: () => callBack.call(),),
  );
}

class CustomBottomSheetsDialog extends StatefulWidget{
  final OrderSendResponse response;
  final Function() callBack;
  const CustomBottomSheetsDialog({super.key, required this.response, required this.callBack});

  @override
  State<StatefulWidget> createState() => _BuildBottomSheetDialogState();

}

class _BuildBottomSheetDialogState extends State<CustomBottomSheetsDialog>{

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/3,
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                widget.callBack.call();
              },
              child: const Icon(Icons.close, color: Colors.red,),
            ),
          ),

          const SizedBox(height: 10,),

          Text(widget.response.message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            DateFormat('yyyy-MM-dd').format(widget.response.dateTime),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text("${widget.response.data.chemistId}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text("${widget.response.data.id}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            DateFormat('yyyy-MM-dd').format(widget.response.data.orderDate),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text("${widget.response.data.orderDetails.length}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10,),

          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 16,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                            (states) => primaryButtonColor),
                    shape: WidgetStateProperty.all<
                        RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                onPressed: () {
                  Navigator.pop(context);
                  widget.callBack.call();
                },
                child: MyTextView("OK", 12, FontWeight.bold,
                    Colors.white, TextAlign.center),
              ),
            ),
          ),

        ],
      ),
    );
  }
}