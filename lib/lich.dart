import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

class Date extends StatefulWidget {
  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {
  CalendarController _calendarController = CalendarController();
  DateTime? _selectedDay;
  List<double> _selectedData = [];

  List<_SalesData> temperatureData = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 60),
    _SalesData('Apr', 32),
    _SalesData('May', 40),
  ];
  List<_SalesData> ecData = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 60),
    _SalesData('Apr', 32),
    _SalesData('May', 40),
  ];

  @override
  void initState() {
    super.initState();
    // Khi widget được khởi tạo, hãy gọi hàm để đọc dữ liệu từ API
    fetchData();
  }

  // Hàm để đọc dữ liệu từ API Thingspeak
  Future<void> fetchData() async {
    final url =
        'https://api.thingspeak.com/channels/2352913/feeds.json?api_key=6LZCSH1BRII14KP4&results=10';

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

        temperatureList.add(_SalesData('${dateTime.day}/${dateTime.month}', temperature));
        ecList.add(_SalesData('${dateTime.day}/${dateTime.month}', ec));
      }

      setState(() {
        // temperatureData = temperatureList;
        // ecData = ecList;

        // Mặc định hiển thị dữ liệu của ngày cuối cùng
        _selectedDay = DateTime.parse(decodedData['feeds'].last['created_at']);
        // _selectedData = temperatureList.last.sales.toString() ?? [];
        
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch và Biểu Đồ'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1100,
          child: Column(
            children: [
              // Lịch
              TableCalendar(
                
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    // _selectedData = temperatureData
                    //     .firstWhere((element) => element.year == '${selectedDay.day}/${selectedDay.month}')
                    //     .sales
                    //     .toString() ??
                    //     [];
                  });
                },
                focusedDay: DateTime.now(),
                firstDay: DateTime(2023, 1, 1),
                lastDay: DateTime(2023, 12, 31),
              ),

              // Biểu đồ nhiệt độ
              if (_selectedDay != null)
                SingleChildScrollView(
                  child: Expanded(
                    child: Column(
                      children: [
                        Text('Biểu Đồ cho ngày ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}'),

                        // Biểu đồ nhiệt độ
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            title: ChartTitle(text: 'Nhiệt độ theo giờ'),
                            legend: const Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<_SalesData, String>>[
                              LineSeries<_SalesData, String>(
                                dataSource: temperatureData,
                                xValueMapper: (_SalesData sales, _) => sales.year,
                                yValueMapper: (_SalesData sales, _) => sales.sales,
                                name: 'Nhiệt độ',
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                              ),
                            ],
                          ),
                        ),

                        // Biểu đồ EC
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            title: ChartTitle(text: 'EC theo giờ'),
                            legend: const Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<_SalesData, String>>[
                              LineSeries<_SalesData, String>(
                                dataSource: ecData,
                                xValueMapper: (_SalesData sales, _) => sales.year,
                                yValueMapper: (_SalesData sales, _) => sales.sales,
                                name: 'EC',
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarController {
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
