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

  ];
  List<_SalesData> ecData = [

  ];
  String ecStatusMessage = '';


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
    int safeCount = 0;
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
        if (ec >= 0 && ec <= 1.5) {
          safeCount++;
        }
        temperatureList.add(_SalesData('${dateTime.minute}:${dateTime.second}', temperature));
        ecList.add(_SalesData('${dateTime.minute}:${dateTime.second}', ec));
      }
      if (safeCount > (decodedData['feeds'].length / 2)) {
        ecStatusMessage = 'Chỉ số dẫn điện của bạn đang ở mức an toàn';
      } else {
        ecStatusMessage = 'Chỉ số dẫn điện của bạn đang ở mức nguy hiểm, cần làm các biện pháp cải thiện ngay';
      }

      // Hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ecStatusMessage),
        ),
      );
      setState(() {
        temperatureData = temperatureList;

        ecData = ecList;

        // Mặc định hiển thị dữ liệu của ngày cuối cùng
        _selectedDay = DateTime.parse(decodedData['feeds'].last['created_at']);
        // _selectedData = temperatureList.last.sales.toString() ?? [];

      });
    } else {
      throw Exception('Failed to load data');
    }

  }
  void handleRefresh() {
    // Gọi lại hàm fetchData khi cần làm mới dữ liệu
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Biểu Đồ'),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: handleRefresh,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1100,
          child: Column(
            children: [
              // Lịch

              // Biểu đồ nhiệt độ
              if (_selectedDay != null)
                SingleChildScrollView(
                  child: Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
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
