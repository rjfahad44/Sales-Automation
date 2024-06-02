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
  List<Item> chemistList = [];

  @override
  void initState() {
    api.getChemistListForDropdown().then((value) {
      setState(() {
        chemistList = value;
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
        body: chemistList.isNotEmpty? Column(
          children: [
            Expanded(
              child: ListView.builder(
                primary: true,
                itemCount: chemistList.length,
                itemBuilder: (context, index) {
                  final data = chemistList[index];
                  return Card(
                    semanticContainer: true,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Chemist Name : ${data.itemName}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ): const Center(
          child: CircularProgressIndicator()
        ),
      ),
    );
  }
}