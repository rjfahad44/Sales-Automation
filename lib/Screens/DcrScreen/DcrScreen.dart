
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sales_automation/Components/PlanUploadCustomDialog.dart';
import '../../APIs/PlanApis.dart';
import '../../Components/Components.dart';
import '../../global.dart';
import 'package:intl/intl.dart';

import 'Models/DoctorPlan.dart';
import 'Models/DoctorPlanResponse.dart';

class DcrScreen extends StatefulWidget {
  const DcrScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DcrScreenState();
}

class _DcrScreenState extends State<DcrScreen> {
  PlanApis planApis = PlanApis();
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<DoctorPlan> doctorPlanList = [];
  bool _isAscending = false;
  bool _isLoading = true;

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    getData();
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    var onDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    setState(() {
      _isLoading = true;
    });
    planApis.getPlansToVisitList(onDate, (response) {
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 200) {
        final resp = jsonDecode(response.body);
        var data = DoctorPlanResponse.fromJson(resp);
        print('resp : ${resp}');
        print('message : ${data.message}');
        print('data : ${data.data.map((a) => a.toJson())}');
        setState(() {
          doctorPlanList = data.data;
          doctorPlanList.sort((a, b) => _isAscending
              ? a.date.compareTo(b.date)
              : b.date.compareTo(a.date));
        });
      } else {
        print(
            'statusCode -> ${response.statusCode} : message ->${response.reasonPhrase}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView(
              "DCR", 16, FontWeight.bold, Colors.black, TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  CalendarDatePicker(
                    currentDate: _focusedDay,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2050),
                    onDateChanged: _onDateChanged,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selected Date: ${DateFormat('MMMM-dd-yyyy').format(_selectedDate)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: Icon(_isAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward),
                          onPressed: _toggleSortOrder,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: doctorPlanList.length,
                    itemBuilder: (context, index) {
                      final doctor = doctorPlanList[index];
                      return Card(
                        margin: const EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 5.0),
                        semanticContainer: true,
                        child: ListTile(
                          title: Text(doctor.doctorName),
                          subtitle: Text(
                              '${doctor.shift} | ${doctor.designation}\n${doctor.doctorAddress}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              showPlanUploadDialog(
                                context,
                                (data) {
                                  print('doctorId: ${doctor.doctorID}');
                                  print('Accompany: ${data['accompany']}');
                                  print('Promote: ${data['promote']}');
                                  print('Remarks: ${data['remarks']}');
                                  print('SampleQty: ${data['sampleQty']}');
                                  print('GiftQty: ${data['giftQty']}');
                                  print(
                                      'LiteratureQty: ${data['literatureQty']}');

                                  planApis.doctorVisitSubmit(
                                      doctor.doctorID,
                                      data['accompany'],
                                      data['promote'],
                                      data['remarks'],
                                      data['sampleQty'],
                                      data['giftQty'],
                                      data['literatureQty'], (response) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (response.statusCode == 200) {
                                      getData();
                                      var resp = jsonDecode(response.body);
                                      print('resp: ${resp}');
                                    } else {
                                      print('Failed : ${response.toString()}');
                                    }
                                  });
                                },
                              );
                            },
                            child: Visibility(
                              visible: !doctor.isVisited,
                              child:
                                  Text(doctor.isVisited ? "History" : "Visit"),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
