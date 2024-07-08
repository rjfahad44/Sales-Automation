


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../APIs/PlanApis.dart';
import '../../Components/Components.dart';
import '../../global.dart';
import 'package:intl/intl.dart';

class DcrScreen extends StatefulWidget {
  const DcrScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DcrScreenState();
}


class _DcrScreenState extends State<DcrScreen> {

  PlanApis planApis = PlanApis();
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _isAscending = false;

  // Mock data source
  final Map<String, List<Doctor>> doctorsData = {
    '2024-07-01': [
      Doctor(name: "Dr. Shamsuddin Ahamed", specialty: "Gynaecologist And Obstetricians", type: "Regular", location: "BOLIVODRA", buttonText: "History"),
      Doctor(name: "Dr. Farhad Hossin", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Shafiqul Islam", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Shohan", specialty: "Cardiologist", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
    ],
    '2024-07-02': [
      Doctor(name: "Dr. Shafiqul Islam", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Shohan", specialty: "Cardiologist", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
    ],
    '2024-07-03': [
      Doctor(name: "Dr. Shamsuddin Ahamed", specialty: "Gynaecologist And Obstetricians", type: "Regular", location: "BOLIVODRA", buttonText: "History"),
      Doctor(name: "Dr. Farhad Hossin", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Shafiqul Islam", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Shohan", specialty: "Cardiologist", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
    ],
    '2024-07-04': [
      Doctor(name: "Dr. Shafiqul Islam", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Shohan", specialty: "Cardiologist", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
    ],
    '2024-07-05': [
      Doctor(name: "Dr. Shamsuddin Ahamed", specialty: "Gynaecologist And Obstetricians", type: "Regular", location: "BOLIVODRA", buttonText: "History"),
      Doctor(name: "Dr. Farhad Hossin", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
    ],
    '2024-07-06': [
      Doctor(name: "Dr. Shamsuddin Ahamed", specialty: "Gynaecologist And Obstetricians", type: "Regular", location: "BOLIVODRA", buttonText: "History"),
      Doctor(name: "Dr. Farhad Hossin", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Shafiqul Islam", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Shohan", specialty: "Cardiologist", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
    ],
    '2024-07-07': [
      Doctor(name: "Dr. Shafiqul Islam", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Shohan", specialty: "Cardiologist", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
    ],
    '2024-07-08': [
      Doctor(name: "Dr. Shafiqul Islam", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Shohan", specialty: "Cardiologist", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
    ],
    '2024-07-09': [
      Doctor(name: "Dr. Shamsuddin Ahamed", specialty: "Gynaecologist And Obstetricians", type: "Regular", location: "BOLIVODRA", buttonText: "History"),
      Doctor(name: "Dr. Shafiqul Islam", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Shohan", specialty: "Cardiologist", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Shafiqul Islam", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Shohan", specialty: "Cardiologist", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
    ],
    '2024-07-10': [
      Doctor(name: "Dr. Shamsuddin Ahamed", specialty: "Gynaecologist And Obstetricians", type: "Regular", location: "BOLIVODRA", buttonText: "History"),
      Doctor(name: "Dr. Shafiqul Islam", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Juel", specialty: "General Practitioner", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
      Doctor(name: "Dr. Arif Mohammed Shohan", specialty: "Cardiologist", type: "Visiting", location: "BOLIVODRA", buttonText: "Visit"),
    ],
  };

  List<Doctor> _getDoctorsForSelectedDate() {
    String formattedDate = _selectedDate.toIso8601String().substring(0, 10);
    List<Doctor> doctors = doctorsData[formattedDate] ?? [];
    doctors.sort((a, b) => _isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    return doctors;
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
  }

  @override
  void initState() {
    planApis.getPlansToVisitList("2024-07-01", "2024-07-01");
    // Future.delayed(const Duration(minutes: 2)).then((value){
    //   planApis.doctorVisitSubmit();
    // });
    setState(() {
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView("DCR", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: Column(
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
                    icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                    onPressed: _toggleSortOrder,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: _getDoctorsForSelectedDate().length,
                itemBuilder: (context, index) {
                  final doctor = _getDoctorsForSelectedDate()[index];
                  return DoctorCard(
                    name: doctor.name,
                    specialty: doctor.specialty,
                    type: doctor.type,
                    location: doctor.location,
                    buttonText: doctor.buttonText,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Doctor {
  final String name;
  final String specialty;
  final String type;
  final String location;
  final String buttonText;

  Doctor({
    required this.name,
    required this.specialty,
    required this.type,
    required this.location,
    required this.buttonText,
  });
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String type;
  final String location;
  final String buttonText;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.type,
    required this.location,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 5.0
      ),
      semanticContainer: true,
      child: ListTile(
        title: Text(name),
        subtitle: Text('$type | $specialty\n$location'),
        trailing: ElevatedButton(
          onPressed: () {

          },
          child: Text(buttonText),
        ),
      ),
    );
  }
}