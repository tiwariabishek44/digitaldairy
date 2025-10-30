import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShiftCollectionCard extends StatelessWidget {
  final String shift;
  final double? milkQuantity;
  final double? fatPercentage;
  final double? snfPercentage;
  final double? rate;
  final double? totalAmount;
  final String? collectionTime;
  final bool isCollected;

  const ShiftCollectionCard({
    Key? key,
    required this.shift,
    this.milkQuantity,
    this.fatPercentage,
    this.snfPercentage,
    this.rate,
    this.totalAmount,
    this.collectionTime,
    this.isCollected = false,
  }) : super(key: key);

  // Card Background: A very light version of the accent color
  Color get cardColor => shift == 'Morning'
      ? const Color(0xFFE3F2FD) // Light Blue background
      : const Color(0xFFFFF3E0); // Light Orange background

  // Accent Color: Used for titles, total, and main metrics (Strong, distinct color)
  Color get accentColor => shift == 'Morning'
      ? const Color(0xFF2196F3) // Bright Sky Blue
      : const Color(0xFFFF9800); // Vibrant Orange

  // Label Color: Used for minor labels and context text (Deep neutral color for maximum readability)
  Color get labelColor => const Color(0xFF424242); // Dark Gray/Near Black

  // ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final hasData = milkQuantity != null;
    return Container(
      width: 70.w,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        // Border uses the accentColor (Blue or Orange)
        border: Border.all(color: accentColor.withOpacity(0.25), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Shift & Total Liter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shift,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentColor, // Title uses accent color
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (collectionTime != null)
                    Text(
                      collectionTime!,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                ],
              ),
              if (hasData)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${milkQuantity!.toStringAsFixed(1)} L',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: accentColor, // Metric uses accent color
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          if (hasData) ...[
            // Fat, SNF, Rate in a row with clear hierarchy
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _metricColumn(
                  'Fat',
                  '${fatPercentage!.toStringAsFixed(1)} %',
                  labelColor,
                  accentColor,
                ),
                _metricColumn(
                  'SNF',
                  '${snfPercentage!.toStringAsFixed(1)} %',
                  labelColor,
                  accentColor,
                ),
                _metricColumn(
                  'Rate',
                  'रू ${rate!.toStringAsFixed(0)}/L',
                  labelColor,
                  accentColor,
                ),
              ],
            ),
            const Divider(height: 28, thickness: 1.2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: labelColor, // Label uses dark neutral color
                  ),
                ),
                Text(
                  'रू ${totalAmount!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: accentColor, // Total uses accent color
                  ),
                ),
              ],
            ),
          ] else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No collection yet',
                style: TextStyle(fontSize: 15, color: Colors.grey[500]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _metricColumn(
    String label,
    String value,
    Color labelColor,
    Color valueColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: labelColor, // Label text uses dark neutral color
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: valueColor, // Metric value uses accent color
          ),
        ),
      ],
    );
  }
}

class DailyMetricsSection extends StatelessWidget {
  final Map<String, dynamic>? morningData;
  final Map<String, dynamic>? eveningData;

  const DailyMetricsSection({Key? key, this.morningData, this.eveningData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Collection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a1a2e),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 26.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ShiftCollectionCard(
                  shift: 'Morning',
                  milkQuantity: morningData?['milk'],
                  fatPercentage: morningData?['fat'],
                  snfPercentage: morningData?['snf'],
                  rate: morningData?['rate'],
                  totalAmount: morningData?['total'],
                  collectionTime: morningData?['time'],
                  isCollected: morningData?['isCollected'] ?? false,
                ),
                ShiftCollectionCard(
                  shift: 'Evening',
                  milkQuantity: eveningData?['milk'],
                  fatPercentage: eveningData?['fat'],
                  snfPercentage: eveningData?['snf'],
                  rate: eveningData?['rate'],
                  totalAmount: eveningData?['total'],
                  collectionTime: eveningData?['time'],
                  isCollected: eveningData?['isCollected'] ?? false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
