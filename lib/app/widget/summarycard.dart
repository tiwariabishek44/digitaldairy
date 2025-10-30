import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class CollectionSummaryCard extends StatelessWidget {
  // Accepts a flat list of all collected shifts in the required period.
  final List<Map<String, dynamic>> allShiftRecords;
  final int daysInPeriod;

  const CollectionSummaryCard({
    Key? key,
    required this.allShiftRecords,
    this.daysInPeriod = 15, // Defaulting to 15 days based on current records
  }) : super(key: key);

  // --- PROFESSIONAL COLOR PALETTE (Matching BalanceCard) ---
  static const Color darkPrimary = Color(0xFF004D40); // Deep Teal
  static const Color darkSecondary = Color(0xFF00695C); // Medium Teal
  static const Color accentGold = Color(0xFFFFD700); // Gold for secondary focus
  static const Color textWhite = Colors.white;
  static const Color textSubtle = Colors.white70;

  Map<String, double> _calculateMetrics() {
    double totalAmount = 0.0;
    double totalLiters = 0.0;
    double totalFat = 0.0;
    double totalSNF = 0.0;
    double totalRate = 0.0;
    int count = 0; // Count of valid shifts

    for (var shift in allShiftRecords) {
      // Safely access values, assuming they are doubles based on the mock data fix.
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

  @override
  Widget build(BuildContext context) {
    final metrics = _calculateMetrics();
    final formattedAmount = NumberFormat(
      '#,##,##0.00',
      'en_IN',
    ).format(metrics['totalAmount']);

    return Container(
      margin: const EdgeInsets.only(bottom: 4, left: 6, right: 6),
      padding: const EdgeInsets.all(24),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'रू $formattedAmount',
                    style: const TextStyle(
                      fontSize: 34,
                      color: textWhite,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Text(
                    'Total Collection Value',
                    style: TextStyle(
                      fontSize: 15,
                      color: textSubtle,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Spacer(),
              _buildMetricColumn(
                label: 'Total Liters',
                value: '${metrics['totalLiters']!.toStringAsFixed(1)} L',
                color: textWhite,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: textSubtle,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
