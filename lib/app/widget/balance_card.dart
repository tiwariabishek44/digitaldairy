import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  final double totalAmount;
  final double totalMilkCollected;
  final int daysCount;

  const BalanceCard({
    Key? key,
    required this.totalAmount,
    required this.totalMilkCollected,
    required this.daysCount,
  }) : super(key: key);

  String get formattedAmount {
    final formatter = NumberFormat('#,##,##0.00', 'en_IN');
    return formatter.format(totalAmount);
  }

  // --- NEW PROFESSIONAL COLOR PALETTE ---
  static const Color darkPrimary = Color(0xFF004D40); // Deep Teal
  static const Color darkSecondary = Color(0xFF00695C); // Medium Teal
  static const Color accentGold = Color(0xFFFFD700); // Gold for secondary focus
  static const Color textWhite = Colors.white;
  static const Color textSubtle = Colors.white70;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Dark, deep gradient for a premium look
        gradient: const LinearGradient(
          colors: [darkPrimary, darkSecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            // Shadow matching the card's deep color
            color: darkPrimary.withOpacity(0.45),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title and Days Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Balance',
                style: TextStyle(
                  fontSize: 17,
                  color: textSubtle,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              // Days Count badge using subtle gold accent
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: accentGold.withOpacity(0.1), // Very light gold tint
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accentGold.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, size: 16, color: accentGold),
                    const SizedBox(width: 5),
                    Text(
                      '$daysCount दिन',
                      style: const TextStyle(
                        fontSize: 15,
                        color: accentGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Reduced space
          // Amount
          Text(
            'रू $formattedAmount',
            style: const TextStyle(
              fontSize: 38, // Prominent size
              color: textWhite, // Crisp white
              fontWeight: FontWeight.w900, // Extra bold
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'कुल खातामा जम्मा',
            style: TextStyle(
              fontSize: 17,
              color: textSubtle,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),

          // Total Milk Collected Metric
          const Divider(color: Colors.white12, thickness: 1.0),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'कुल दूध संकलन :-',
                style: TextStyle(
                  fontSize: 17,
                  color: textSubtle,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '${totalMilkCollected.toStringAsFixed(2)} L',
                style: const TextStyle(
                  fontSize: 18,
                  color: textWhite, // Crisp white metric value
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
