
import 'package:flutter/material.dart';
import 'package:sales_automation/Screens/DoctorListScreen/Model/Doctor.dart';

import '../../APIs/OrderAPI.dart';
import '../../Components/Components.dart';
import '../../Models/Item.dart';
import '../../global.dart';

class DoctorListScreen extends StatefulWidget{
  const DoctorListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DoctorListScreenState();

}

class _DoctorListScreenState extends State<DoctorListScreen> {

  OrderAPI api = OrderAPI();
  final TextEditingController _searchController = TextEditingController();
  List<Doctor> doctorList = [];
  List<Doctor> doctorSearchList = [];
  bool isLoading = false;

  @override
  void initState() {
    api.getDoctorList().then((value) {
      setState(() {
        doctorList = value;
        doctorSearchList = value;
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
          title: MyTextView("Doctors", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: isLoading?
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

            doctorList.isNotEmpty?
            Expanded(
              child: ListView.builder(
                primary: true,
                itemCount: doctorList.length,
                itemBuilder: (context, index) {
                  final data = doctorList[index];
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
                            "Doctor id : ${data.id}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Text(
                            "Doctor Name : ${data.doctorName}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Text(
                            "Doctor degree : ${data.degree}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Text(
                            "Doctor specialty : ${data.specialtyName}",
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
            ):
            Center(
              child: MyTextView("No Data Found!", 18, FontWeight.bold,
                  Colors.black, TextAlign.center),
            ),
          ],
        ): const Center(
          child: CircularProgressIndicator()
        ),
      ),
    );
  }

  void _filterItems() {
    final query = _searchController.text.toUpperCase();
    setState(() {
      doctorList = doctorSearchList.where((item) { return (item.doctorName.toUpperCase().contains(query) || item.id.toString().contains(query)); }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }
}