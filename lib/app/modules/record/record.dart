import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:digitaldairy/app/widget/shift_record_tile.dart';

class CollectionRecordsPage extends StatefulWidget {
  const CollectionRecordsPage({super.key});

  @override
  State<CollectionRecordsPage> createState() => _CollectionRecordsPageState();
}

class _CollectionRecordsPageState extends State<CollectionRecordsPage> {
  // Filter states
  DateTime selectedMonth = DateTime.now();
  String selectedPeriod = 'all'; // 'all', 'first', 'second'

  // Nepali abbreviated month names
  static const List<String> nepaliMonths = [
    'जन',
    'फेब',
    'मार्च',
    'अप्रि',
    'मे',
    'जुन',
    'जुला',
    'अग',
    'सेप्ट',
    'अक्टो',
    'नोभे',
    'डिसे',
  ];

  // Mock data for demonstration
  List<Map<String, dynamic>> get mockCollectionData {
    // Generate data based on selected month and period
    return _generateMockData();
  }

  List<Map<String, dynamic>> _generateMockData() {
    List<Map<String, dynamic>> data = [];
    int startDay = selectedPeriod == 'second' ? 16 : 1;
    int endDay = selectedPeriod == 'first'
        ? 15
        : selectedPeriod == 'second'
        ? DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day
        : DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;

    if (selectedPeriod == 'all') {
      startDay = 1;
    }

    for (int day = endDay; day >= startDay; day--) {
      data.add({
        'date': DateTime(selectedMonth.year, selectedMonth.month, day),
        'morning': {
          'milk': 4.5 + (day % 3) * 0.3,
          'fat': 4.3 + (day % 4) * 0.2,
          'snf': 8.2 + (day % 3) * 0.2,
          'rate': 44.0 + (day % 3),
          'total': (4.5 + (day % 3) * 0.3) * (44.0 + (day % 3)),
          'time': '7:30 AM',
        },
        'evening': {
          'milk': 4.2 + (day % 3) * 0.4,
          'fat': 4.4 + (day % 4) * 0.15,
          'snf': 8.3 + (day % 3) * 0.15,
          'rate': 45.0 + (day % 3),
          'total': (4.2 + (day % 3) * 0.4) * (45.0 + (day % 3)),
          'time': '5:45 PM',
        },
      });
    }
    return data;
  }

  List<Map<String, dynamic>> get allShifts {
    List<Map<String, dynamic>> shifts = [];
    for (var day in mockCollectionData) {
      if (day['morning'] != null)
        shifts.add(day['morning'] as Map<String, dynamic>);
      if (day['evening'] != null)
        shifts.add(day['evening'] as Map<String, dynamic>);
    }
    return shifts;
  }

  // --- PROFESSIONAL COLOR PALETTE (Matching BalanceCard) ---
  static const Color darkPrimary = Color.fromARGB(
    255,
    211,
    245,
    239,
  ); // Deep Teal
  static const Color darkSecondary = Color.fromARGB(
    255,
    163,
    192,
    188,
  ); // Medium Teal

  Map<String, double> _calculateMetrics() {
    double totalAmount = 0.0;
    double totalLiters = 0.0;
    double totalFat = 0.0;
    double totalSNF = 0.0;
    double totalRate = 0.0;
    int count = 0;

    for (var shift in allShifts) {
      if (shift['total'] != null && shift['milk'] != null) {
        totalAmount += shift['total'] as double;
        totalLiters += shift['milk'] as double;
        totalFat += shift['fat'] as double;
        totalSNF += shift['snf'] as double;
        totalRate += shift['rate'] as double;
        count++;
      }
    }

    if (count == 0) {
      return {
        'totalAmount': 0.0,
        'totalLiters': 0.0,
        'avgFat': 0.0,
        'avgSNF': 0.0,
        'avgRate': 0.0,
      };
    }

    return {
      'totalAmount': totalAmount,
      'totalLiters': totalLiters,
      'avgFat': totalFat / count,
      'avgSNF': totalSNF / count,
      'avgRate': totalRate / count,
    };
  }

  String _formatDateInNepali(DateTime date) {
    final monthAbbr = nepaliMonths[date.month - 1];
    return '$monthAbbr ${date.day}, ${date.year}';
  }

  String _formatMonthInNepali(DateTime date) {
    final monthAbbr = nepaliMonths[date.month - 1];
    return '$monthAbbr ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _calculateMetrics();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2E7D32), // Deep green
                    Color(0xFF43A047), // Medium green
                  ],
                ),
                // Rounded curve at the bottom
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'दूध सङ्कलन रेकर्डहरू',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'तपाईंको दूध सङ्कलन ट्र्याक गर्नुहोस्',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildMonthSelector(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Filter Pills - Using Wrap to avoid horizontal scroll
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildPeriodFilter('all', 'पूर्ण महिना'),
                        _buildPeriodFilter('first', '१-१५'),
                        _buildPeriodFilter('second', '१६-३१'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 7),
                    // Summary Section with Big Total Card and Curved Average Container
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [darkPrimary, darkSecondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: darkPrimary.withOpacity(0.45),
                              blurRadius: 25,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF2E7D32,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Icon(
                                    Icons.trending_up_rounded,
                                    color: Color(0xFF2E7D32),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'कुल सारांश',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      Text(
                                        'तपाईंको समग्र प्रदर्शन',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                            255,
                                            78,
                                            77,
                                            77,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: _buildBigSummaryItem(
                                    icon: Icons.account_balance_wallet_rounded,
                                    label: 'कुल आम्दानी',
                                    value:
                                        '₹${NumberFormat('#,##,##0.00', 'en_IN').format(metrics['totalAmount'])}',
                                    color: const Color(0xFF2E7D32),
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                Expanded(
                                  child: _buildBigSummaryItem(
                                    icon: Icons.water_drop_outlined,
                                    label: 'कुल लिटर',
                                    value:
                                        '${metrics['totalLiters']!.toStringAsFixed(1)} L',
                                    color: const Color(0xFF1976D2),
                                  ),
                                ),
                              ],
                            ),
                            //divider
                            Divider(
                              color: const Color.fromARGB(
                                255,
                                104,
                                103,
                                103,
                              ).withOpacity(0.3),
                              thickness: 1,
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Average ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: _buildAverageColumn(
                                        label: 'FAT',
                                        value:
                                            '${metrics['avgFat']!.toStringAsFixed(1)}%',
                                        icon: Icons.opacity,
                                        color: const Color.fromARGB(
                                          255,
                                          77,
                                          76,
                                          76,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildAverageColumn(
                                        label: 'SNF',
                                        value:
                                            '${metrics['avgSNF']!.toStringAsFixed(1)}%',
                                        icon: Icons.grain,
                                        color: const Color.fromARGB(
                                          255,
                                          77,
                                          76,
                                          76,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildAverageColumn(
                                        label: 'RATE',
                                        value:
                                            '₹${metrics['avgRate']!.toStringAsFixed(1)}',
                                        icon: Icons.currency_rupee,
                                        color: const Color.fromARGB(
                                          255,
                                          77,
                                          76,
                                          76,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Daily Records List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: List.generate(mockCollectionData.length, (
                          index,
                        ) {
                          final dayData = mockCollectionData[index];
                          final morning =
                              dayData['morning'] as Map<String, dynamic>;
                          final evening =
                              dayData['evening'] as Map<String, dynamic>;
                          final date = dayData['date'] as DateTime;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _formatDateInNepali(date),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A237E),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                ShiftRecordTile(
                                  shift: 'Morning',
                                  milkQuantity: morning['milk'] as double,
                                  fatPercentage: morning['fat'] as double,
                                  snfPercentage: morning['snf'] as double,
                                  rate: morning['rate'] as double,
                                  totalAmount: morning['total'] as double,
                                  collectionTime: '7:30 AM',
                                ),

                                ShiftRecordTile(
                                  shift: 'Evening',
                                  milkQuantity: evening['milk'] as double,
                                  fatPercentage: evening['fat'] as double,
                                  snfPercentage: evening['snf'] as double,
                                  rate: evening['rate'] as double,
                                  totalAmount: evening['total'] as double,
                                  collectionTime: '5:45 PM',
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),

                    // Bottom padding
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedMonth,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDatePickerMode: DatePickerMode.year,
        );
        if (picked != null) {
          setState(() {
            selectedMonth = DateTime(picked.year, picked.month);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              color: Color(0xFF2E7D32),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              _formatMonthInNepali(selectedMonth),
              style: const TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF2E7D32),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodFilter(String period, String label) {
    final isSelected = selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBigSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAverageColumn({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Extension to darken colors
extension ColorExtension on Color {
  Color darker(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );
    return darkened.toColor();
  }
}
