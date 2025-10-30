import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  final String farmerName;
  final String collectionCenter;
  final double temperature;
  final String weatherCondition;
  final int notificationCount;

  const WelcomeSection({
    Key? key,
    required this.farmerName,
    required this.collectionCenter,
    this.temperature = 25.0,
    this.weatherCondition = 'Sunny',
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String greeting = _getGreeting(now.hour);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Section - Greeting and Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  farmerName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        collectionCenter,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right Section - Weather and Notification
          Row(
            children: [
              // Weather Card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getWeatherIcon(weatherCondition),
                      color: _getWeatherColor(weatherCondition),
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${temperature.toStringAsFixed(0)}°',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        Text(
                          weatherCondition,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Notification Bell
              Stack(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 22,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE74C3C),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'शुभ प्रभात';
    } else if (hour < 17) {
      return 'शुभ दिन';
    } else if (hour < 20) {
      return 'शुभ साँझ';
    } else {
      return 'शुभ रात्रि';
    }
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.grain;
      case 'stormy':
        return Icons.thunderstorm;
      default:
        return Icons.wb_sunny;
    }
  }

  Color _getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return const Color(0xFFF39C12);
      case 'cloudy':
        return const Color(0xFF7F8C8D);
      case 'rainy':
        return const Color(0xFF3498DB);
      case 'stormy':
        return const Color(0xFF8E44AD);
      default:
        return const Color(0xFFF39C12);
    }
  }
}
