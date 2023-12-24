import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryContent extends StatefulWidget {
  @override
  _HistoryContentState createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> {
  DateTime? _selectedDay;
  List<double> _selectedData = [];

  List<_SalesData> temperatureData = [];
  List<_SalesData> ecData = [];

  @override
  void initState() {
    super.initState();
    // Khi widget được khởi tạo, hãy gọi hàm để đọc dữ liệu từ API
    fetchData();
  }

  // Hàm để đọc dữ liệu từ API Thingspeak
  Future<void> fetchData() async {
    const url =
        'https://api.thingspeak.com/channels/2352913/feeds.json?api_key=6LZCSH1BRII14KP4&results=15';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        // Xử lý dữ liệu từ API để tạo danh sách nhiệt độ và EC
        List<_SalesData> temperatureList = [];
        List<_SalesData> ecList = [];

        for (final entry in decodedData['feeds']) {
          final DateTime dateTime = DateTime.parse(entry['created_at']);
          final double temperature = double.parse(entry['field1']);
          final double ec = double.parse(entry['field2']);
          print(dateTime);
          temperatureList.add(_SalesData('${dateTime.hour+7}:${dateTime.minute}:${dateTime.second}', temperature));
          ecList.add(_SalesData('${dateTime.minute}:${dateTime.second}', ec));
        }

        setState(() {
          temperatureData = temperatureList.reversed.toList();
          ecData = ecList.reversed.toList();

          // Mặc định hiển thị dữ liệu của ngày cuối cùng
          _selectedDay = DateTime.parse(decodedData['feeds'].last['created_at']);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Lịch sử đo'),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: ()=>fetchData(),
            ),
          ],
        ),
      ),
      body: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text(
                'Time',
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Temperature',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'EC',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
        rows: temperatureData.asMap().entries.map((entry) {
          final int index = entry.key;
          final _SalesData temperatureEntry = entry.value;
          final _SalesData ecEntry =  ecData[index];

          return DataRow(
            cells: <DataCell>[
              DataCell(Text(temperatureEntry.year)),
              DataCell(Text('${temperatureEntry.sales}')),
              DataCell(Text('${ecEntry.sales}')),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
