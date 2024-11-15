import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_automation/APIs/OrderAPI.dart';
import 'package:sales_automation/Components/Components.dart';
import '../../Models/ChemistDropdownResponse.dart';
import '../../Models/Item.dart';
import '../../Models/LocationInfo.dart';
import '../../Services/LocationService.dart';
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
  List<ChemistModel> chemistDropdownList = [];
  String selecteddeliveryTimes = 'Morning';
  String chemistHint = "Select Chemist";
  String selectedPaymentTypes = 'Cash';
  String deliveryDispDate = 'Select Date';
  OrderAPI api = OrderAPI();

  @override
  void initState() {
    api.getChemistListForDropdown().then((value) {
      setState(() {
        chemistDropdownList = value;
      });
    });

    if(orderCreate.products.isEmpty){
      selecteddeliveryTimes = deliveryTimes[0];
      selectedPaymentTypes = paymentTypes[0];
    }else{
      selecteddeliveryTimes = orderCreate.deliveryTime;
      selectedPaymentTypes = orderCreate.paymentType;
      chemistHint = orderCreate.chemist;
      deliveryDispDate = orderCreate.deliveryDate;
      selectedDate = DateTime.parse(deliveryDispDate);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: MyTextView("Order Create", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: MyTextView("Delivery Date: ", 12, FontWeight.normal, Colors.black, TextAlign.start),
                        ),

                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              height: 52.0,
                              child: ElevatedButton(
                                onPressed: () => _selectDate(context),
                                style: ButtonStyle(
                                    surfaceTintColor: WidgetStateColor.resolveWith(
                                            (states) => Colors.white),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      deliveryDispDate.split(" ")[0],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12.0,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    const Icon(Icons.calendar_month)
                                  ],
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
                        Expanded(
                          flex: 1,
                          child: MyTextView("Delivery Time: ", 12, FontWeight.normal, Colors.black, TextAlign.start),
                        ),

                        Expanded(
                          flex: 3,
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
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.0,
                                        ),
                                      ),
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
                        Expanded(
                          flex: 1,
                          child: MyTextView("Chemist: ", 12, FontWeight.normal, Colors.black, TextAlign.start),
                        ),
                        Expanded(
                          flex: 3,
                          child: Card(
                            surfaceTintColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                              child: DropdownButton<ChemistModel>(
                                hint: MyTextView(chemistHint, 12, FontWeight.normal, Colors.black, TextAlign.start),
                                value: null, // Initially, no item is selected
                                isExpanded: true,
                                underline: Container(),
                                onChanged: (ChemistModel? selectedValue) {
                                  if(selectedValue?.name.isEmpty == true) selectedValue?.name = "No Name! id:${selectedValue.chemistID}";
                                  setState(() {
                                    chemistHint = selectedValue!.name;
                                    selectedChemist = selectedValue;
                                  });
                                },
                                items: chemistDropdownList.map((ChemistModel item) {
                                  if(item.name.isEmpty) item.name = "No Name! id:${item.chemistID}";
                                  return DropdownMenuItem<ChemistModel>(
                                    value: item,
                                    child: Text(item.name),
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
                        Expanded(
                          flex: 1,
                          child: MyTextView("Address: ", 12, FontWeight.normal, Colors.black, TextAlign.start),
                        ),

                        Expanded(
                          flex: 3,
                          child: Card(
                            surfaceTintColor: Colors.white,
                            child: SizedBox(
                              height: 50,
                              width: 280,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: MyTextView(
                                      selectedChemist.address.isEmpty ? "Please Select Chemist" : selectedChemist.address,
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
                        Expanded(
                          flex: 1,
                          child: MyTextView("Payment type: ", 12, FontWeight.normal, Colors.black, TextAlign.start),
                        ),

                        Expanded(
                          flex: 3,
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
                  ],
                ),
              ),

              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                            (states) => primaryButtonColor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                onPressed: () {
                  if(chemistHint != "Select Chemist" && deliveryDispDate != 'Select Date') {
                    orderCreate.deliveryDate = deliveryDispDate;
                    orderCreate.deliveryTime = selecteddeliveryTimes;
                    orderCreate.chemistId = int.tryParse(selectedChemist.chemistID) ?? 0;
                    orderCreate.chemist = selectedChemist.name;
                    orderCreate.chemistAddress = selectedChemist.address;
                    orderCreate.paymentType = selectedPaymentTypes;
                    goToPage(const ItemsDetails(), true, context);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Select chemist and date",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.orange,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                },
                child: MyTextView(
                    "Next", 12,
                    FontWeight.bold,
                    Colors.white,
                    TextAlign.center,
                ),
              ),
            ],
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
    setState(() {
      deliveryDispDate = selectedDate.toString();
      print("deliveryDispDate : ${deliveryDispDate}");
    });
  }
}
