import 'package:flutter/material.dart';
import 'package:digitaldairy/app/widget/balance_card.dart';
import 'package:digitaldairy/app/widget/daily_collection.dart';
import 'package:digitaldairy/app/widget/snf_graph_card.dart';
import 'package:digitaldairy/app/widget/welcomemessage.dart' hide BalanceCard;
import 'package:responsive_sizer/responsive_sizer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with actual farmer name from your data source
    const farmerName = 'राम प्रसाद';
    const totalEarnings = 12500.00; // Example value

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeSection(
              farmerName: "Ram Prasad",
              collectionCenter: "Chitwan Collection Center",
            ),
            SizedBox(height: 1.h),
            BalanceCard(
              totalAmount: totalEarnings,
              totalMilkCollected: 320.5,
              daysCount: 30,
            ),
            SizedBox(height: 20),
            DailyMetricsSection(
              morningData: {
                'milk': 12.5,
                'fat': 4.2,
                'snf': 8.5,
                'rate': 45.0,
                'total': 562.50,
                'time': '6:30 AM',
                'isCollected': true,
              },
              eveningData: {
                'milk': 15.0,
                'fat': 4.5,
                'snf': 9.0,
                'rate': 50.0,
                'total': 750.00,
                'time': '6:30 PM',
                'isCollected': true,
              },
            ),
            SizedBox(height: 20),
            // Replace DairyTrendChart() with this:
            NoticeSection(
              notices: [
                {
                  'title': 'Milk Rate Update',
                  'message':
                      'From 1st Nov, milk rate will be Rs. 52 per liter.',
                  'date': 'Oct 25, 2025',
                },
                {
                  'title': 'Holiday Notice',
                  'message': 'Collection center will remain closed on Tihar.',
                  'date': 'Oct 29, 2025',
                },
                {
                  'title': 'Clean Milk Reminder',
                  'message':
                      'Please ensure your milk cans are clean and sealed properly before submission.',
                  'date': 'Oct 23, 2025',
                },
              ],
            ),
          ],
          // Add other widgets like recent activities here
        ),
      ),
    );
  }
}
