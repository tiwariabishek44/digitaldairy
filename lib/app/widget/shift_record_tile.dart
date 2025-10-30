import 'package:flutter/material.dart';

class ShiftRecordTile extends StatelessWidget {
  final String shift;
  final double milkQuantity;
  final double fatPercentage;
  final double snfPercentage;
  final double rate;
  final double totalAmount;
  final String? collectionTime;

  const ShiftRecordTile({
    Key? key,
    required this.shift,
    required this.milkQuantity,
    required this.fatPercentage,
    required this.snfPercentage,
    required this.rate,
    required this.totalAmount,
    this.collectionTime,
  }) : super(key: key);

  Color get accentColor =>
      shift == 'Morning' ? const Color(0xFF2196F3) : const Color(0xFFFF9800);

  Color get labelColor => const Color(0xFF424242);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$shift (${milkQuantity.toStringAsFixed(1)} Ltr)',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    //   if (collectionTime != null)
                    //     Text(
                    //       collectionTime!,
                    //       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    //     ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Shift Label and Milk Quantity (Left side)

                // Metrics (Center)
                Row(
                  children: [
                    _metricValue(
                      'फ्याट',
                      '${fatPercentage.toStringAsFixed(1)}%',
                      labelColor,
                    ),
                    const SizedBox(width: 12),
                    _metricValue(
                      'एस.एन.एफ',
                      '${snfPercentage.toStringAsFixed(1)}%',
                      labelColor,
                    ),
                    const SizedBox(width: 12),
                    _metricValue(
                      'रेट',
                      'रू ${rate.toStringAsFixed(0)}',
                      labelColor,
                    ),
                  ],
                ),

                // Total Amount (Right side)
                Text(
                  'रू ${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: labelColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricValue(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('$label: ', style: TextStyle(fontSize: 13, color: color)),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
