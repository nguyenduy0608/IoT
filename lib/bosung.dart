import 'package:flutter/material.dart';

class Bosung extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Các yếu tố ảnh hưởng chất lượng nước',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
          ),
          WaterQualityCard(
            title: 'Dung lượng',
            content1:
                'Tác động: Dung lượng đo lường lượng chất rắn và các hạt có thể nằm trong nước.',
            content2:
                ' Cải thiện: Sử dụng bộ lọc nước hoặc hệ thống xử lý nước để loại bỏ các chất độc hại và tăng dung lượng của nước.',
          ),
          WaterQualityCard(
            title: 'Màu sắc và Tạp chất hữu cơ',
            content1: 'Tác động: Màu sắc và tạp chất hữu cơ có thể làm ảnh hưởng đến thị giác và mùi vị của nước.',
            content2: 'Cải thiện: Sử dụng hệ thống lọc hoặc xử lý nước để giảm mức độ màu sắc và loại bỏ tạp chất hữu cơ.',
          ),
          WaterQualityCard(
            title: 'Các chất dinh dưỡng (Nitrogen và Phosphorus)',
            content1: 'Tác động: Các chất dinh dưỡng có thể gây ra tình trạng nước eutrophication, dẫn đến sự phát triển quá mức của tảo và sinh vật nước khác.',
            content2: 'Cải thiện: Áp dụng các biện pháp quản lý nông nghiệp bền vững để giảm lượng chất dinh dưỡng từ phân bón và thải ra môi trường.',
          ),
          WaterQualityCard(
            title: 'Chất ô nhiễm hữu cơ và hóa học',
            content1: 'Tác động: Các chất ô nhiễm như hóa chất công nghiệp, dầu mỏ, và các chất hóa học có thể gây hại cho sức khỏe con người và động vật nước.',
            content2: 'Cải thiện: Giám sát và kiểm soát quá trình xử lý chất thải công nghiệp, xử lý nước thải, và quản lý an toàn các chất hóa học để giảm thiểu rủi ro ô nhiễm.',
          ),
          WaterQualityCard(
            title: 'Nhiệt độ',
            content1: 'Tác động: Nhiệt độ nước ảnh hưởng đến sinh học của các loài sống trong nước.',
            content2: 'Cải thiện: Duy trì nhiệt độ nước tự nhiên hoặc sử dụng hệ thống điều hòa nhiệt độ để bảo vệ sinh quyển nước.',
          ),
          WaterQualityCard(
            title: 'Chất độc hại (chì, thủy ngân, arsenic, fluorua, vv.)',
            content1: 'Tác động: Gây hại cho sức khỏe con người khi nước bị nhiễm phải.',
            content2: 'Cải thiện: Sử dụng hệ thống xử lý nước phù hợp để loại bỏ chất độc hại và thực hiện kiểm tra định kỳ chất lượng nước.',
          ),
          WaterQualityCard(
            title: 'Vi khuẩn và vi sinh vật gây bệnh',
            content1: 'Tác động: Gây bệnh cho người sử dụng nước nếu nước bị nhiễm vi khuẩn và vi sinh vật gây bệnh.',
            content2: 'Cải thiện: Sử dụng hệ thống xử lý nước như lọc, khuỷu tay UV, hoặc hóa chất để diệt khuẩn và vi sinh vật.',
          ),
          WaterQualityCard(
            title: 'Các chất phóng xạ',
            content1: 'Tác động: Gây ảnh hưởng đối với sức khỏe con người và môi trường nếu nước bị nhiễm các chất phóng xạ.',
            content2: 'Cải thiện: Giám sát chất lượng nước đối với các chất phóng xạ và thực hiện các biện pháp an toàn nếu cần.',
          ),

          // Thêm các WaterQualityCard khác tương tự ở đây cho các yếu tố khác
        ],
      ),
    );
  }
}

class WaterQualityCard extends StatelessWidget {
  final String title;
  final String content1;
  final String content2;

  const WaterQualityCard({
    required this.title,
    required this.content1,
    required this.content2,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Xử lý khi card được bấm vào, ví dụ: chuyển hướng sang trang chi tiết
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaterQualityDetail(
              title: title,
              content1: content1,
              content2: content2,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaterQualityDetail extends StatelessWidget {
  final String title;
  final String content1;
  final String content2;

  const WaterQualityDetail({
    required this.title,
    required this.content1,
    required this.content2,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 16),
            Text(
              content1,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              content2,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Bosung(),
  ));
}
