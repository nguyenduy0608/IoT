import 'package:flutter/material.dart';
class HistoryContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataTable(
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
              'Chỉ số EC',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Tempe',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Thời Gian 1')),
            DataCell(Text('Chỉ Số Dẫn Điện 1')),
            DataCell(Text('Nhiệt Độ 1')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Thời Gian 2')),
            DataCell(Text('Chỉ Số Dẫn Điện 2')),
            DataCell(Text('Nhiệt Độ 2')),
          ],
        ),
        // Thêm các dòng khác tương tự cho mỗi thông tin lịch sử
      ],
    );
  }
}

