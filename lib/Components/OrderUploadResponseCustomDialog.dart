import 'package:flutter/material.dart';
import 'package:sales_automation/global.dart';
import 'package:intl/intl.dart';
import '../Models/OrderResponse.dart';
import 'Components.dart';

Future<T?> showBottomSheetDialog<T>(
    BuildContext context,
    OrderResponse? response,
    String? message,
    double totalAmount,
    double totalDiscount,
    double finalAmount,
    Function() callBack) async {
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return CustomDialog(
        response: response,
        message: message,
        totalAmount: totalAmount,
        totalDiscount: totalDiscount,
        finalAmount: finalAmount,
        callBack: () => callBack.call(),
      );
    },
  );
}

class CustomDialog extends StatefulWidget {
  final OrderResponse? response;
  final String? message;
  final double totalAmount;
  final double totalDiscount;
  final double finalAmount;
  final Function() callBack;

  const CustomDialog(
      {super.key,
      required this.response,
      required this.message,
      required this.totalAmount,
      required this.totalDiscount,
      required this.finalAmount,
      required this.callBack});

  @override
  State<StatefulWidget> createState() => _BuildCustomDialogState();
}

class _BuildCustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height/3,
        padding: const EdgeInsets.all(10.0),
        // decoration: const BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(12.0),
        //     topRight: Radius.circular(12.0),
        //     bottomLeft: Radius.circular(0),
        //     bottomRight: Radius.circular(0),
        //   ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.callBack.call();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Message : ${widget.message}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Visibility(
                visible: widget.response != null,
                child: Column(
                  children: [
                    Text(
                      "Date : ${DateFormat('yyyy-MM-dd').format(widget.response!.dateTime)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "ChemistId : ${widget.response!.data.chemistId}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Order No : ${widget.response!.data.orderNo}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Total Products : ${widget.response!.data.orderDetails.length}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )),
            MyTextView("Price: ${widget.totalAmount.toStringAsFixed(2)}৳", 16,
                FontWeight.bold, Colors.black, TextAlign.start),
            MyTextView("Discount: ${widget.totalDiscount.toStringAsFixed(2)}৳",
                16, FontWeight.bold, Colors.black, TextAlign.start),
            Container(
              height: 1,
              color: Colors.grey,
              width: double.infinity,
            ),
            MyTextView("Total Price: ${widget.finalAmount.toStringAsFixed(2)}৳",
                16, FontWeight.bold, Colors.black, TextAlign.start),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 16,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateColor.resolveWith(
                          (states) => primaryButtonColor),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.callBack.call();
                  },
                  child: MyTextView("OK", 12, FontWeight.bold, Colors.white,
                      TextAlign.center),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
