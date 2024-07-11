import 'package:flutter/material.dart';

import '../global.dart';
import 'Components.dart';

Future<T?> showPlanUploadDialog<T>(
  BuildContext context,
  Function(Map<String, dynamic> data) onSubmit,
) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PlanUploadCustomDialog(
        onSubmit: (data) => onSubmit.call(data),
      );
    },
  );
}

class PlanUploadCustomDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const PlanUploadCustomDialog({super.key, required this.onSubmit});

  @override
  State<PlanUploadCustomDialog> createState() => _PlanUploadCustomDialogState();
}

class _PlanUploadCustomDialogState extends State<PlanUploadCustomDialog> {
  final TextEditingController accompanyController = TextEditingController();
  final TextEditingController promoteController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController sampleQtyController = TextEditingController();
  final TextEditingController giftQtyController = TextEditingController();
  final TextEditingController literatureQtyController = TextEditingController();

  @override
  void dispose() {
    accompanyController.dispose();
    promoteController.dispose();
    remarksController.dispose();
    sampleQtyController.dispose();
    giftQtyController.dispose();
    literatureQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyTextView('Enter Details', 14, FontWeight.bold, Colors.black,
              TextAlign.center),
          GestureDetector(
            onTap: () {
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.close,
              size: 30.0,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 30,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: accompanyController,
                decoration: const InputDecoration(
                  labelText: 'Accompany',
                ),
              ),
              TextField(
                controller: promoteController,
                decoration: const InputDecoration(
                    labelText: 'Promote',
                ),
              ),
              TextField(
                controller: remarksController,
                decoration: const InputDecoration(
                    labelText: 'Remarks',
                ),
              ),
              TextField(
                controller: sampleQtyController,
                decoration: const InputDecoration(
                    labelText: 'Sample Qty',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: giftQtyController,
                decoration: const InputDecoration(
                    labelText: 'Gift Qty',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: literatureQtyController,
                decoration: const InputDecoration(
                    labelText: 'Literature Qty',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith(
                    (states) => primaryButtonColor),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
            onPressed: () {
              Map<String, dynamic> data = {
                'accompany': accompanyController.text,
                'promote': promoteController.text,
                'remarks': remarksController.text,
                'sampleQty': int.tryParse(sampleQtyController.text) ?? 0,
                'giftQty': int.tryParse(giftQtyController.text) ?? 0,
                'literatureQty':
                    int.tryParse(literatureQtyController.text) ?? 0,
              };
              widget.onSubmit(data);
              Navigator.of(context).pop();
            },
            child: MyTextView(
                "Submit", 12, FontWeight.bold, Colors.white, TextAlign.center),
          ),
        )
      ],
    );
  }
}
