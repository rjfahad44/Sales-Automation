import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../APIs/OrderAPI.dart';
import '../../Components/Components.dart';
import '../../Models/Item.dart';
import '../../global.dart';

class ChemistListScreen extends StatefulWidget{
  const ChemistListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChemistListScreenState();

}

class _ChemistListScreenState extends State<ChemistListScreen> {

  OrderAPI api = OrderAPI();
  bool isChemistListEmpty = true;
  List<String> chemistList = ['a', 'b', 'c'];
  List<Item> chemistDropdownList = [];
  String chemistHint = "Select Chemist";

  @override
  void initState() {
    api.getChemistListForDropdown().then((value) {
      setState(() {
        chemistDropdownList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView("Image Archive", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: isChemistListEmpty? Column(
          children: [

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

            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: chemistList.length,
              itemBuilder: (context, index) {
                final data = chemistList[index];
                return Card(
                  elevation: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(6.0),
                          //   child: ClipRRect(
                          //     borderRadius:
                          //     BorderRadius.circular(8),
                          //     child: Image.file(
                          //       File(data.imagePath),
                          //       fit: BoxFit.cover,
                          //       height: 60,
                          //       width: 60,
                          //     ),
                          //   ),
                          // ),
                          Text(
                            "Chemist Name : ${data}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ): Center(
          child: MyTextView("No Data Found!", 18, FontWeight.bold,
              Colors.black, TextAlign.center),
        ),
      ),
    );
  }
}