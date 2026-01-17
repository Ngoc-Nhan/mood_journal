import 'package:flutter/material.dart';
import 'dart:ui';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all (16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),

            // ===== Stats =====
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _StatItem(title: 'Bài viết', value: '2'),
                  _StatItem(title: 'Tâm trạng', value: '2'),
                  _StatItem(title: 'Chuỗi liên tục', value: '2'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== Journal streak =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chuỗi nhật ký',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      final isDone = index < 2;
                      return Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDone
                                  ? Colors.pink.shade100
                                  : Colors.grey.shade200,
                            ),
                            child: Icon(
                              isDone ? Icons.favorite : Icons.add,
                              size: 16,
                              color: isDone ? Colors.pink : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text('Thg 1', style: TextStyle(fontSize: 12)),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.local_fire_department,
                          color: Colors.orange, size: 16),
                      SizedBox(width: 6),
                      Text('Chuỗi dài nhất: 2',
                          style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== Tip card =====
            GestureDetector(
              onTap: () => _openImage(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black12),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/insight_tipcard.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange.shade100,
                            ),
                            child: const Icon(Icons.pets, color: Colors.orange),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Van Huynh',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Lưu lại bản chưa cập nhật kịp thời để có thể chia sẻ cùng bạn bè, không có bản nháp rất buồn đấy',
                                  style: TextStyle(fontSize: 13, height: 1.4),
                                ),
                              ],
                            ),
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
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title,
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}

void _openImage(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black54,
    pageBuilder: (_, __, ___) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black26),
            ),
            Center(
              child: Image.asset('assets/images/insight_tipcard.png', fit: BoxFit.contain),
            ),
          ],
        ),
      );
    },
  );
}
