// import 'dart:convert';
// import 'dart:developer';
// import 'dart:math' hide log;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// class WeatherScreen extends StatefulWidget {
//   @override
//   _WeatherScreenState createState() => _WeatherScreenState();
// }

// class _WeatherScreenState extends State<WeatherScreen> {
//   Map<String, dynamic>? weatherData;
//   String? errorMessage;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchWeather();
//   }

//   Future<void> fetchWeather() async {
//     const apiKey = '9de3e58d55d84fd9540c4048c71fe992'; // Your Weatherstack key
//     const city = 'Tandi, Nepal';
//     final url = Uri.parse(
//       'https://api.weatherstack.com/current?access_key=$apiKey&query=$city',
//     );

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final response = await http.get(url);
//       print('[log] Response status: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('[log] Full API Response: ${json.encode(data)}');

//         if (data['success'] != false) {
//           setState(() {
//             weatherData = data;
//             errorMessage = null;
//             isLoading = false;
//           });
//           log(
//             '[log] Weather loaded: ${data['current']['temperature']}°C in ${data['location']['name']}',
//           );
//         } else {
//           final errorObj = data['error'] as Map<String, dynamic>?;
//           final errorInfo =
//               errorObj?['info'] ??
//               (errorObj?['type'] ?? 'Unknown API error—check key or quota');
//           setState(() {
//             weatherData = null;
//             errorMessage = errorInfo;
//             isLoading = false;
//           });
//           print('[log] API Error: $errorInfo');
//         }
//       } else {
//         setState(() {
//           weatherData = null;
//           errorMessage =
//               'HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Server issue'}';
//           isLoading = false;
//         });
//         print('[log] HTTP Error: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         weatherData = null;
//         errorMessage = 'Fetch crashed: $e';
//         isLoading = false;
//       });
//       print('[log] Catch Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Weatherstack Demo')),
//       body: Center(
//         child: isLoading
//             ? const CircularProgressIndicator()
//             : errorMessage != null
//             ? Text(errorMessage!, style: const TextStyle(color: Colors.red))
//             : weatherData != null
//             ? Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Button to detail screen (passes location + coords from Weatherstack)
//                     ElevatedButton(
//                       onPressed: () {
//                         final locName =
//                             '${weatherData!['location']['name']}, ${weatherData!['location']['country']}';
//                         final lat = weatherData!['location']['lat'];
//                         final lon = weatherData!['location']['lon'];
//                         Get.to(
//                           () => const DetailWeatherScreen(),
//                           arguments: {
//                             'location': locName,
//                             'lat': lat,
//                             'lon': lon,
//                           },
//                           binding: DetailWeatherBindings(),
//                         );
//                       },
//                       child: const Text('View Details'),
//                     ),
//                     Text(
//                       '${weatherData!['location']['name']}, ${weatherData!['location']['country']}',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       '${weatherData!['current']['temperature']}°C',
//                       style: const TextStyle(fontSize: 48),
//                     ),
//                     Text(
//                       weatherData!['current']['weather_descriptions'][0],
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                     Text(
//                       'Feels like: ${weatherData!['current']['feelslike']}°C',
//                     ),
//                     Text('Humidity: ${weatherData!['current']['humidity']}%'),
//                     Image.network(
//                       weatherData!['current']['weather_icons'][0],
//                       height: 100,
//                     ),
//                   ],
//                 ),
//               )
//             : const Text('No data'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: fetchWeather,
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }

// class DetailWeatherController extends GetxController {
//   final String location; // For display (from Weatherstack)
//   final String lat; // From Weatherstack
//   final String lon; // From Weatherstack
//   var forecastData = <String, dynamic>{}.obs;
//   var errorMessage = ''.obs;
//   var isLoading = true.obs;

//   DetailWeatherController({
//     required this.location,
//     required this.lat,
//     required this.lon,
//   });

//   @override
//   void onInit() {
//     super.onInit();
//     fetchForecast();
//   }

//   Future<void> fetchForecast() async {
//     const apiKey = 'da6c930f758a10d0fb1b73dd0e817da2'; // Your OWM key
//     final url = Uri.parse(
//       'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
//     );

//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       final response = await http.get(url);
//       log('[log] OWM Forecast Response status: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         log('[log] Full OWM Response: ${json.encode(data)}');
//         forecastData.value = data;
//         errorMessage.value = '';
//       } else {
//         errorMessage.value =
//             'HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Server issue'}';
//       }
//     } catch (e) {
//       errorMessage.value = 'Fetch failed: $e';
//       log('[log] OWM Forecast Error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

// class DetailWeatherBindings extends Bindings {
//   @override
//   void dependencies() {
//     final args = Get.arguments;
//     final location = args['location'] ?? 'Tandi, Nepal';
//     final lat = args['lat']?.toString() ?? '27.62';
//     final lon = args['lon']?.toString() ?? '84.52';
//     Get.put(DetailWeatherController(location: location, lat: lat, lon: lon));
//   }
// }

// class DetailWeatherScreen extends GetView<DetailWeatherController> {
//   const DetailWeatherScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('5-Day Forecast'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (controller.errorMessage.value.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                 const SizedBox(height: 16),
//                 Text(
//                   controller.errorMessage.value,
//                   style: const TextStyle(color: Colors.red),
//                   textAlign: TextAlign.center,
//                 ),
//                 ElevatedButton(
//                   onPressed: controller.fetchForecast,
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         }
//         final data = controller.forecastData;
//         if (data.isEmpty) return const Center(child: Text('No data loaded'));

//         // OWM structure: list of 3-hourly; group to daily
//         final list = data['list'] as List<dynamic>;

//         // Group by date
//         final dailyForecast = <String, dynamic>{};
//         for (var item in list) {
//           final dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
//           final dateKey = DateFormat('yyyy-MM-dd').format(dt);
//           if (!dailyForecast.containsKey(dateKey)) {
//             dailyForecast[dateKey] = {
//               'maxtemp': double.negativeInfinity,
//               'mintemp': double.infinity,
//               'descs': <String>[],
//               'icons': <String>[],
//             };
//           }
//           final day = dailyForecast[dateKey];
//           final temp = item['main']['temp'] as double;
//           day['maxtemp'] = max(day['maxtemp'] as double, temp);
//           day['mintemp'] = min(day['mintemp'] as double, temp);
//           day['descs'].add(item['weather'][0]['description']);
//           day['icons'].add(
//             'https://openweathermap.org/img/wn/${item['weather'][0]['icon']}@2x.png',
//           );
//         }

//         // Current (first item)
//         final currentItem = list[0];
//         final currentTemp = currentItem['main']['temp'];
//         final currentDesc = currentItem['weather'][0]['description'];
//         final currentIcon =
//             'https://openweathermap.org/img/wn/${currentItem['weather'][0]['icon']}@2x.png';
//         final currentFeels = currentItem['main']['feels_like'];
//         final currentHumidity = currentItem['main']['humidity'];

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Current Weather Card (uses passed location name)
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       Text(
//                         controller.location,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         '$currentTemp°C',
//                         style: const TextStyle(fontSize: 48),
//                       ),
//                       Text(currentDesc, style: const TextStyle(fontSize: 18)),
//                       Image.network(currentIcon, height: 64),
//                       Text(
//                         'Feels like: $currentFeels°C | Humidity: $currentHumidity%',
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Next 4 Days',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),

//               // Forecast Cards (next 4 after today)
//               ...dailyForecast.entries.skip(1).take(4).map((entry) {
//                 final dateKey = entry.key;
//                 final day = entry.value;
//                 final date = DateFormat(
//                   'MMM dd',
//                 ).format(DateTime.parse(dateKey));
//                 final maxTemp = day['maxtemp'];
//                 final minTemp = day['mintemp'];
//                 final desc = day['descs'].first;
//                 final iconUrl = day['icons'].first;

//                 return Card(
//                   child: ListTile(
//                     leading: Image.network(iconUrl, width: 50, height: 50),
//                     title: Text(
//                       date,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(desc),
//                     trailing: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('$maxTemp°', style: const TextStyle(fontSize: 18)),
//                         Text(
//                           '$minTemp°',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ],
//           ),
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: controller.fetchForecast,
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeatherForecast {
  final String date;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;

  WeatherForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final dt = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    final main = json['main'];
    final weather = json['weather'][0];

    return WeatherForecast(
      date: '${dt.day}/${dt.month}',
      tempMin: main['temp_min'].toDouble(),
      tempMax: main['temp_max'].toDouble(),
      description: weather['description'],
      icon: weather['icon'],
    );
  }
}

class WeatherController extends GetxController {
  final String apiKey =
      'da6c930f758a10d0fb1b73dd0e817da2'; // 🔑 Replace with your key
  final String city = 'Tandi,NP'; // ✅ Recommended
  var forecastList = <WeatherForecast>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetch5DayForecast();
    super.onInit();
  }

  Future<void> fetch5DayForecast() async {
    isLoading(true);
    try {
      final url =
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';
      final response = await http.get(Uri.parse(url));
      log("[log] Weather API Response status: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['list'] as List;

        // Group by day (keep only one entry per day — e.g., noon)
        final Map<String, dynamic> dailyMap = {};
        for (var item in list) {
          final dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
          final dayKey = '${dt.year}-${dt.month}-${dt.day}';
          // Prefer forecast around 12:00 PM
          if (!dailyMap.containsKey(dayKey) || dt.hour >= 10 && dt.hour <= 14) {
            dailyMap[dayKey] = item;
          }
        }

        final forecasts = dailyMap.values
            .take(5)
            .map((item) => WeatherForecast.fromJson(item))
            .toList();

        forecastList.assignAll(forecasts);
      } else {
        Get.snackbar('Error', 'Failed to load weather data');
      }
    } catch (e) {
      log(' erorr $e');
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class WeatherScreen extends StatelessWidget {
  WeatherScreen({Key? key}) : super(key: key);

  final WeatherController controller = Get.put(WeatherController());

  Future<void> _refreshWeather() async {
    await controller.fetch5DayForecast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          '${controller.city} Weather',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _refreshWeather,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWeather,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.forecastList.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          // Today's weather (first entry)
          final today = controller.forecastList[0];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Today's Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${today.tempMax.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          today.description.capitalize!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Image.network(
                      'https://openweathermap.org/img/wn/${today.icon}@4x.png',
                      width: 80,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5-Day Forecast
              const Text(
                '5-Day Forecast',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              ...List.generate(controller.forecastList.length, (index) {
                final item = controller.forecastList[index];
                // Skip "Today" since it's already shown
                if (index == 0) return const SizedBox.shrink();

                return Dismissible(
                  key: Key(item.date),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Day
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _getDayName(index), // e.g., "Tomorrow", "Wed"
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.description.capitalize!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icon
                        Image.network(
                          'https://openweathermap.org/img/wn/${item.icon}.png',
                          width: 40,
                        ),
                        const SizedBox(width: 12),
                        // Temp
                        Text(
                          '${item.tempMax.toInt()}°',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  String _getDayName(int index) {
    if (index == 1) return 'Tomorrow';
    final now = DateTime.now();
    final day = now.add(Duration(days: index));
    return DateFormat('EEE').format(day); // e.g., Mon, Tue
  }
}
