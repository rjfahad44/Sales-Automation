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
  final TextEditingController _searchController = TextEditingController();
  List<Item> chemistList = [];
  List<Item> chemistSearchList = [];
  bool isLoading = false;

  @override
  void initState() {
    api.getChemistListForDropdown().then((value) {
      setState(() {
        chemistList = value;
        chemistSearchList = value;
        _searchController.addListener(_filterItems);
        isLoading = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView("Chemist List", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: isLoading ?
        Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 4.0,
                  right: 4.0,
                  bottom: 4.0
              ),
              child: TextField(
                controller: _searchController,
                style:  const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: primaryButtonColor,),
                  labelText: 'Search..',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: primaryButtonColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: primaryButtonColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: primaryButtonColor),
                  ),
                ),
              ),
            ),

            chemistList.isNotEmpty?
            Expanded(
              child: ListView.builder(
                primary: true,
                itemCount: chemistList.length,
                itemBuilder: (context, index) {
                  final data = chemistList[index];
                  return Card(
                    color: primaryButtonColor,
                    semanticContainer: true,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            softWrap: true,
                            "Chemist id : ${data.itemID}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            softWrap: true,
                            "Chemist Name : ${data.itemName}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ) :
            Center(
              child: MyTextView("No Data Found!", 18, FontWeight.bold,
                  Colors.black, TextAlign.center),
            ),
          ],
        ):
        const Center(
          child: CircularProgressIndicator()
        ),
      ),
    );
  }

  void _filterItems() {
    final query = _searchController.text.toUpperCase();
    setState(() {
      chemistList = chemistSearchList.where((item) { return (item.itemName.contains(query) || item.itemID.toString().contains(query)); }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }
}