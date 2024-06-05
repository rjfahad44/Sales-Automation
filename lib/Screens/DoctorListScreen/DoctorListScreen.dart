
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
  List<Doctor> doctorList = [];

  @override
  void initState() {
    api.getDoctorList().then((value) {
      setState(() {
        doctorList = value;
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
        body: doctorList.isNotEmpty? Column(
          children: [
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
            ),
          ],
        ): const Center(
          child: CircularProgressIndicator()
        ),
      ),
    );
  }
}