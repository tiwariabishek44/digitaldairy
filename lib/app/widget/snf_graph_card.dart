import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NoticeSection extends StatelessWidget {
  final List<Map<String, String>> notices;

  const NoticeSection({Key? key, required this.notices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📢 Dairy Notices",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 22.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                return NoticeCard(
                  title: notice['title'] ?? 'Notice',
                  message: notice['message'] ?? '',
                  date: notice['date'] ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NoticeCard extends StatelessWidget {
  final String title;
  final String message;
  final String date;

  const NoticeCard({
    Key? key,
    required this.title,
    required this.message,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // light green background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF66BB6A).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              date,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
