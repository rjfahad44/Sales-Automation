import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_automation/global.dart';

import '../Screens/ImageCaptureScreen/Model/ImageUploadResponse.dart';
import 'Components.dart';


Future<T?> showBottomSheetDialog<T>(BuildContext context, ImageUploadResponse responseData) async {
  return await showModalBottomSheet<T>(
    context: context,
    isDismissible: false,
    builder: (context) => CustomBottomSheetsDialog(responseData: responseData),
  );
}

class CustomBottomSheetsDialog extends StatefulWidget{
  final ImageUploadResponse responseData;
  const CustomBottomSheetsDialog({super.key, required this.responseData});

  @override
  State<StatefulWidget> createState() => _BuildBottomSheetDialogState();

}

class _BuildBottomSheetDialogState extends State<CustomBottomSheetsDialog>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/3.5,
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
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, color: Colors.red,),
            ),
          ),

          const SizedBox(height: 10,),

          Text(
            "${widget.responseData.message}",
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