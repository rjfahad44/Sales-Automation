import 'package:flutter/material.dart';

import '../../APIs/AttendanceAPI.dart';
import '../../Models/AttendanceData.dart';

import 'package:intl/intl.dart';

import '../../global.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  AttendanceAPI api = AttendanceAPI();
  List<AttendanceData> attendanceList = [];
  List<AttendanceData> filteredList = [];
  TextEditingController searchController = TextEditingController();
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime toDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  void _fetchAttendanceData() {
    api.getEmployeeAttendance(fromDate, toDate).then((dataList){
      if (dataList != null) {
        setState(() {
          attendanceList = dataList;
          filteredList = attendanceList;
        });
      }
    });
  }

  void _filterAttendance(String query) {
    setState(() {
      filteredList = attendanceList
          .where((attendance) =>
      attendance.name.toLowerCase().contains(query.toLowerCase()) ||
          attendance.signInAddress.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _selectDateRange() async {
    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: fromDate, end: toDate),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedRange != null) {
      setState(() {
        fromDate = pickedRange.start;
        toDate = pickedRange.end;
      });
      _fetchAttendanceData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _selectDateRange,
          ),
        ],
        backgroundColor: themeColor,
      ),
      body: attendanceList.isNotEmpty
          ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterAttendance,
              decoration: InputDecoration(
                hintText: 'Search by name or sign-in address',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('From: ${DateFormat('yyyy-MM-dd').format(fromDate)}'),
                Text('To: ${DateFormat('yyyy-MM-dd').format(toDate)}'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final attendance = filteredList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(attendance.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Sign-in: ${attendance.signInTime} (${attendance.signInAddress})'),
                        Text(
                            'Sign-out: ${attendance.signOutTime} (${attendance.signOutAddress})'),
                        Text('Date: ${DateFormat('yyyy-MM-dd').format(attendance.date)}'),
                      ],
                    ),
                    trailing: attendance.status
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.cancel, color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

