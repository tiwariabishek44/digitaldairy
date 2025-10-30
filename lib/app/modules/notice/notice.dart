import 'package:flutter/material.dart';

class Notice {
  final String userImage;
  final String userName;
  final String time;
  final String content;
  final String? imageUrl;
  final NoticeType type;

  Notice({
    required this.userImage,
    required this.userName,
    required this.time,
    required this.content,
    this.imageUrl,
    required this.type,
  });
}

enum NoticeType { collection, rateChange, meeting, holiday, general }

// Mock Data with Dairy-specific notices in Nepali
final List<Notice> notices = [
  Notice(
    userImage: 'https://randomuser.me/api/portraits/men/1.jpg',
    userName: 'डेरी प्रशासक',
    time: '२ घण्टा अघि',
    content: 'सार्वजनिक बिदाको कारण भोलि दूध संकलन हुने छैन।',
    imageUrl: null,
    type: NoticeType.holiday,
  ),
  Notice(
    userImage: 'https://randomuser.me/api/portraits/women/2.jpg',
    userName: 'व्यवस्थापक',
    time: '५ घण्टा अघि',
    content:
        'दूधको मूल्य वृद्धि! नयाँ दर: रु. ६५ प्रति लिटर (गाई), रु. ७५ प्रति लिटर (भैंसी)।',
    imageUrl: null,
    type: NoticeType.rateChange,
  ),
  Notice(
    userImage: 'https://randomuser.me/api/portraits/men/3.jpg',
    userName: 'संकलन अधिकारी',
    time: '१ दिन अघि',
    content:
        'भोलि दूध संकलन बिहान ६:०० बजे सुरु हुनेछ। कृपया समयमै उपस्थित हुनुहोस्।',
    imageUrl: null,
    type: NoticeType.collection,
  ),
  Notice(
    userImage: 'https://randomuser.me/api/portraits/women/4.jpg',
    userName: 'सचिव',
    time: '२ दिन अघि',
    content:
        'शुक्रबार बिहान १०:०० बजे वार्षिक साधारण सभा। वार्षिक योजना र नाफा वितरणबारे छलफल गर्न सबै किसानहरू उपस्थित हुनुपर्नेछ।',
    imageUrl: 'https://images.unsplash.com/photo-1431540015161-0bf868a2d407',
    type: NoticeType.meeting,
  ),
  Notice(
    userImage: 'https://randomuser.me/api/portraits/men/5.jpg',
    userName: 'डेरी प्रशासक',
    time: '३ दिन अघि',
    content:
        'गुणस्तर बोनस घोषणा! SNF ८.५% भन्दा माथि भएका किसानहरूले प्रति लिटर रु. २ थप पाउनेछन्।',
    imageUrl: null,
    type: NoticeType.general,
  ),
  Notice(
    userImage: 'https://randomuser.me/api/portraits/women/6.jpg',
    userName: 'पशु चिकित्सक',
    time: '४ दिन अघि',
    content:
        'आइतबार गाईवस्तुका लागि निःशुल्क खोप शिविर। कृपया बिहान ८ बजेदेखि दिउँसो २ बजेसम्म आफ्ना पशुहरू ल्याउनुहोस्।',
    imageUrl: 'https://images.unsplash.com/photo-1560493676-04071c5f467b',
    type: NoticeType.general,
  ),
  Notice(
    userImage: 'https://randomuser.me/api/portraits/men/7.jpg',
    userName: 'संकलन अधिकारी',
    time: '५ दिन अघि',
    content:
        'नोट: दूध संकलन गर्दा FAT र SNF परीक्षण अनिवार्य छ। कृपया गुणस्तरीय दूध मात्र ल्याउनुहोस्।',
    imageUrl: null,
    type: NoticeType.collection,
  ),
  Notice(
    userImage: 'https://randomuser.me/api/portraits/women/8.jpg',
    userName: 'व्यवस्थापक',
    time: '१ हप्ता अघि',
    content:
        'महिना अन्त्यमा भुक्तानी वितरण हुनेछ। कृपया आफ्नो बैंक खाता विवरण अपडेट गर्नुहोस्।',
    imageUrl: null,
    type: NoticeType.general,
  ),
];

class NoticePage extends StatelessWidget {
  const NoticePage({Key? key}) : super(key: key);

  void _openDetail(BuildContext context, Notice notice) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoticeDetailPage(notice: notice)),
    );
  }

  Color _getTypeColor(NoticeType type) {
    switch (type) {
      case NoticeType.collection:
        return Colors.blue;
      case NoticeType.rateChange:
        return Colors.orange;
      case NoticeType.meeting:
        return Colors.purple;
      case NoticeType.holiday:
        return Colors.red;
      case NoticeType.general:
        return Colors.green;
    }
  }

  IconData _getTypeIcon(NoticeType type) {
    switch (type) {
      case NoticeType.collection:
        return Icons.water_drop;
      case NoticeType.rateChange:
        return Icons.currency_rupee;
      case NoticeType.meeting:
        return Icons.groups;
      case NoticeType.holiday:
        return Icons.celebration;
      case NoticeType.general:
        return Icons.info;
    }
  }

  String _getTypeName(NoticeType type) {
    switch (type) {
      case NoticeType.collection:
        return 'संकलन';
      case NoticeType.rateChange:
        return 'दर परिवर्तन';
      case NoticeType.meeting:
        return 'सभा';
      case NoticeType.holiday:
        return 'बिदा';
      case NoticeType.general:
        return 'सामान्य';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'नेपाल डेरी संस्था',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'सूचनाहरू',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        itemCount: notices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final notice = notices[index];
          return GestureDetector(
            onTap: () => _openDetail(context, notice),
            child: Material(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(notice.type).withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getTypeIcon(notice.type),
                            size: 16,
                            color: _getTypeColor(notice.type),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getTypeName(notice.type),
                            style: TextStyle(
                              color: _getTypeColor(notice.type),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Avatar, Name, Time
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(notice.userImage),
                                radius: 26,
                                backgroundColor: const Color(0xFFE1E8ED),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notice.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Color(0xFF222B45),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time_rounded,
                                          size: 14,
                                          color: Color(0xFF8F9BB3),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          notice.time,
                                          style: const TextStyle(
                                            color: Color(0xFF8F9BB3),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Color(0xFFBDBDBD),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // Content
                          Text(
                            notice.content,
                            style: const TextStyle(
                              fontSize: 15.5,
                              color: Color(0xFF222B45),
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Optional Image
                          if (notice.imageUrl != null) ...[
                            const SizedBox(height: 14),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                notice.imageUrl!,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 180,
                                      color: const Color(0xFFF7F9F9),
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Color(0xFF8899A6),
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NoticeDetailPage extends StatelessWidget {
  final Notice notice;

  const NoticeDetailPage({Key? key, required this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'नेपाल डेरी संस्था',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'सूचना विवरण',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(notice.userImage),
                  radius: 30,
                  backgroundColor: const Color(0xFFE1E8ED),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 15,
                            color: Color(0xFF8F9BB3),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notice.time,
                            style: const TextStyle(
                              color: Color(0xFF8F9BB3),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              notice.content,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xFF222B45),
                height: 1.7,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (notice.imageUrl != null) ...[
              const SizedBox(height: 22),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  notice.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: const Color(0xFFF7F9F9),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Color(0xFF8899A6),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
