import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_automation/Models/OrderHistoryData.dart';
import 'package:sales_automation/Screens/HomeScreen/HomeScreen.dart';
import 'package:sales_automation/global.dart';

import '../../APIs/OrderAPI.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {

  OrderAPI api = OrderAPI();
  List<OrderHistoryData> filteredData = [];
  List<OrderHistoryData> originalData = [];
  TextEditingController searchController = TextEditingController();
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    filterData();
  }

  void filterData() {
    api.getOrderHistoryData(startDate, endDate).then((dataList){
      if(dataList != null){
        setState(() {
          originalData = dataList;
          filteredData = List.from(originalData);
        });
      }
    });
  }

  void _filterData(String query){
    setState(() {
      filteredData = originalData.where((order) {
        final searchTerm = searchController.text.toLowerCase();

        // Check if the order date is within the selected date range
        final isWithinDateRange = order.orderDate.isAfter(
            startDate?.subtract(const Duration(days: 1)) ?? DateTime.now()) &&
            order.orderDate.isBefore(
                endDate?.add(const Duration(days: 1)) ?? DateTime.now());

        // Check if the search term matches chemist name, order number, or product name
        final matchesSearch = order.chemistName.toLowerCase().contains(searchTerm) ||
            order.orderNo.contains(searchTerm) ||
            order.orderDetails.any((detail) =>
                detail.productName.toLowerCase().contains(searchTerm));

        return matchesSearch && isWithinDateRange;
      }).toList();
    });
  }

  Future<void> pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate!, end: endDate!),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      filterData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
        backgroundColor: themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            goToPage(const HomeScreen(), false, context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: _filterData,
                    decoration: const InputDecoration(
                      labelText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => pickDateRange(context),
                  child: const Text('Filter by Date'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final order = filteredData[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(
                        'Order No: ${order.orderNo} | Chemist: ${order.chemistName}'),
                    subtitle: Text(
                      'Total Price: ${order.totalPrice} | Date: ${DateFormat.yMMMd().format(order.orderDate)}',
                    ),
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Product')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('Price')),
                            DataColumn(label: Text('Total Price')),
                          ],
                          rows: (order.orderDetails)
                              .map<DataRow>((detail) => DataRow(cells: [
                            DataCell(Text(detail.productName)),
                            DataCell(Text(detail.quantity.toString())),
                            DataCell(Text(detail.price.toString())),
                            DataCell(Text(detail.totalPrice.toString())),
                          ]))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
