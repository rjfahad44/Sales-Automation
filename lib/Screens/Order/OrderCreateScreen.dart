import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_automation/APIs/OrderAPI.dart';
import 'package:sales_automation/Components/Components.dart';
import '../../Models/Item.dart';
import '../../global.dart';
import 'ItemAddScreen.dart';

class OrderCreateScreen extends StatefulWidget {
  const OrderCreateScreen({super.key});

  @override
  State<OrderCreateScreen> createState() => _OrderCreateScreenState();
}

class _OrderCreateScreenState extends State<OrderCreateScreen> {
  DateTime selectedDate = DateTime.now();

  List<String> deliveryTimes = ['Morning', 'Evening', 'Night'];
  List<String> paymentTypes = ['Cash', 'Bank deposit', 'Bkash'];
  List<Item> chemistDropdownList = [];
  String selecteddeliveryTimes = 'Morning';
  String chemistHint = "Select Chemist";
  String selectedPaymentTypes = 'Cash';
  String deliveryDispDate = 'Select Date';
  OrderAPI api = OrderAPI();

  @override
  void initState() {
    super.initState();
    selecteddeliveryTimes = deliveryTimes[0];
    selectedPaymentTypes = paymentTypes[0];
    api.getChemistListForDropdown().then((value) {
      setState(() {
        chemistDropdownList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView("Order Create", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyTextView("Delivary Date: ", 12, FontWeight.normal, Colors.black,
                      TextAlign.center),
                  Flexible(
                    child: SizedBox(
                      width: 280,
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        style: ButtonStyle(
                            surfaceTintColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(deliveryDispDate.split(" ")[0]),
                            Icon(Icons.calendar_month)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyTextView("Delivary Time: ", 12, FontWeight.normal, Colors.black,
                      TextAlign.center),
                  Flexible(
                    child: Card(
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        width: 280,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                          child: DropdownButton<String>(
                            value: selecteddeliveryTimes,
                            underline: Container(),
                            isExpanded: true,
                            items: deliveryTimes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: MyTextView(value, 12, FontWeight.normal,
                                    Colors.black, TextAlign.center),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              selecteddeliveryTimes = newValue!;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: MyTextView("Chemist: ", 12, FontWeight.normal, Colors.black, TextAlign.center),
                  ),
                  Flexible(
                    flex: 4,
                    child: Card(
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                        child: DropdownButton<Item>(
                          hint: MyTextView(chemistHint, 12, FontWeight.normal, Colors.black, TextAlign.center),
                          value: null, // Initially, no item is selected
                          isExpanded: true,
                          underline: Container(),
                          onChanged: (Item? selectedValue) {
                            setState(() {
                              chemistHint = selectedValue!.itemName;
                              selectedChemist = selectedValue;
                            });
                          },
                          items: chemistDropdownList.map((Item item) {
                            return DropdownMenuItem<Item>(
                              value: item,
                              child: Text(item.itemName),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyTextView("Chem.Address: ", 12, FontWeight.normal, Colors.black,
                      TextAlign.center),
                  Flexible(
                    child: Card(
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        height: 50,
                        width: 280,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                          child: Center(
                            child: MyTextView(
                                "Mohammadpur, Dhaka - 1207, Bangladesh",
                                12,
                                FontWeight.normal,
                                Colors.black,
                                TextAlign.left),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyTextView("Payment type: ", 12, FontWeight.normal, Colors.black,
                      TextAlign.center),
                  Flexible(
                    child: Card(
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        width: 280,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                          child: DropdownButton<String>(
                            value: selectedPaymentTypes,
                            underline: Container(),
                            isExpanded: true,
                            items: paymentTypes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: MyTextView(value, 12, FontWeight.normal,
                                    Colors.black, TextAlign.center),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              selectedPaymentTypes = newValue!;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                            (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                onPressed: () {
                  if(selectedChemist.itemName != "InitChem" && deliveryDispDate != 'Select Date') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ItemsDetails()));
                  } else {
                    Fluttertoast.showToast(
                        msg: "Select chemist and date",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                },
                child: MyTextView(
                    "Next", 12, FontWeight.bold, Colors.white, TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) selectedDate = picked;
    deliveryDispDate = selectedDate.toString();

    setState(() {});
  }
}
