import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MilkAnalysisPage extends StatefulWidget {
  const MilkAnalysisPage({Key? key}) : super(key: key);

  @override
  State<MilkAnalysisPage> createState() => _MilkAnalysisPageState();
}

class _MilkAnalysisPageState extends State<MilkAnalysisPage> {
  String selectedPeriod = '7D';
  String selectedMetric = 'ALL';

  final Map<String, List<MilkData>> periodData = {
    '7D': [
      MilkData(DateTime.now().subtract(Duration(days: 6)), 45, 8.2, 4.1),
      MilkData(DateTime.now().subtract(Duration(days: 5)), 52, 9.1, 4.8),
      MilkData(DateTime.now().subtract(Duration(days: 4)), 44, 8.0, 3.9),
      MilkData(DateTime.now().subtract(Duration(days: 3)), 48, 8.6, 4.3),
      MilkData(DateTime.now().subtract(Duration(days: 2)), 46, 8.3, 4.0),
      MilkData(DateTime.now().subtract(Duration(days: 1)), 49, 8.8, 4.5),
      MilkData(DateTime.now(), 51, 9.0, 4.7),
    ],
    '1M': [
      MilkData(DateTime.now().subtract(Duration(days: 28)), 44, 8.1, 4.0),
      MilkData(DateTime.now().subtract(Duration(days: 21)), 47, 8.5, 4.3),
      MilkData(DateTime.now().subtract(Duration(days: 14)), 48, 8.6, 4.4),
      MilkData(DateTime.now().subtract(Duration(days: 7)), 49, 8.8, 4.5),
      MilkData(DateTime.now(), 51, 9.0, 4.7),
    ],
    '3M': [
      MilkData(DateTime.now().subtract(Duration(days: 90)), 42, 7.8, 3.8),
      MilkData(DateTime.now().subtract(Duration(days: 60)), 45, 8.2, 4.1),
      MilkData(DateTime.now().subtract(Duration(days: 30)), 47, 8.5, 4.3),
      MilkData(DateTime.now().subtract(Duration(days: 15)), 49, 8.8, 4.5),
      MilkData(DateTime.now(), 51, 9.0, 4.7),
    ],
    '1Y': [
      MilkData(DateTime.now().subtract(Duration(days: 365)), 40, 7.5, 3.6),
      MilkData(DateTime.now().subtract(Duration(days: 180)), 43, 7.9, 3.9),
      MilkData(DateTime.now().subtract(Duration(days: 90)), 46, 8.3, 4.2),
      MilkData(DateTime.now().subtract(Duration(days: 30)), 50, 8.7, 4.6),
      MilkData(DateTime.now(), 51, 9.0, 4.7),
    ],
  };

  List<MilkData> get data => periodData[selectedPeriod]!;

  // --- Current Values ---
  MilkData get current => data.last;
  MilkData get previous => data.length > 1 ? data[data.length - 2] : data.first;

  double get rateChange => current.rate - previous.rate;
  double get snfChange => current.snf - previous.snf;
  double get fatChange => current.fat - previous.fat;

  // --- Best Performers ---
  MilkData get bestRate => data.reduce((a, b) => a.rate > b.rate ? a : b);
  MilkData get bestSnf => data.reduce((a, b) => a.snf > b.snf ? a : b);
  MilkData get bestFat => data.reduce((a, b) => a.fat > b.fat ? a : b);

  // --- Insight Message ---
  String get insightMessage {
    if (snfChange > 0 && rateChange > 0) {
      return "Great! Your SNF improved → Rate went up!";
    } else if (fatChange > 0 && rateChange > 0) {
      return "Good! Higher fat helped increase your rate.";
    } else if (snfChange < 0 || fatChange < 0) {
      return "Milk quality dropped slightly. Focus on feed!";
    } else {
      return "Your milk quality is stable. Keep it up!";
    }
  }

  // --- Mapping for Chart ---
  double _mapToRateScale(double value) {
    const inMin = 2.0;
    const inMax = 9.0;
    const outMin = 20.0;
    const outMax = 80.0;
    return (value - inMin) / (inMax - inMin) * (outMax - outMin) + outMin;
  }

  double _reverseMapFromRateScale(double scaledValue) {
    const outMin = 2.0;
    const outMax = 9.0;
    const inMin = 20.0;
    const inMax = 80.0;
    return (scaledValue - inMin) / (inMax - inMin) * (outMax - outMin) + outMin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Insight Banner
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.auto_stories, color: Colors.green, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          insightMessage,
                          style: const TextStyle(
                            color: Color(0xFF166534),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Current Metrics Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _metricCard(
                      'Rate',
                      '₹${current.rate}',
                      rateChange,
                      rateChange >= 0 ? Colors.green : Colors.red,
                    ),
                    _metricCard(
                      'SNF',
                      '${current.snf}%',
                      snfChange,
                      snfChange >= 0 ? Colors.green : Colors.red,
                    ),
                    _metricCard(
                      'Fat',
                      '${current.fat}%',
                      fatChange,
                      fatChange >= 0 ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Period Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _periodButton('7D'),
                    _periodButton('1M'),
                    _periodButton('3M'),
                    _periodButton('1Y'),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF64748B),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Chart
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _metricChip('All', 'ALL'),
                        _metricChip('Rate', 'RATE'),
                        _metricChip('SNF', 'SNF'),
                        _metricChip('Fat', 'FAT'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _legendItem('Rate', const Color(0xFF3B82F6)),
                        _legendItem('SNF', const Color(0xFF8B5CF6)),
                        _legendItem('Fat', const Color(0xFFF59E0B)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 10,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: const Color(0xFFE2E8F0),
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 10,
                                getTitlesWidget: (value, meta) {
                                  if (value < 20 || value > 80)
                                    return const Text('');
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= data.length)
                                    return const Text('');
                                  final date = data[value.toInt()].date;
                                  if (selectedPeriod == '7D') {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        [
                                          'S',
                                          'M',
                                          'T',
                                          'W',
                                          'T',
                                          'F',
                                          'S',
                                        ][value.toInt()],
                                        style: const TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 12,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        '${date.day}/${date.month}',
                                        style: const TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 11,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: _getChartLines(),
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: const Color(0xFF1E293B),
                              tooltipRoundedRadius: 8,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  final date = data[spot.x.toInt()].date;
                                  String label = '${date.day}/${date.month}';
                                  if (spot.barIndex == 0) {
                                    label +=
                                        '\nRate: ₹${spot.y.toStringAsFixed(1)}';
                                  } else if (spot.barIndex == 1) {
                                    double realSnf = _reverseMapFromRateScale(
                                      spot.y,
                                    );
                                    label +=
                                        '\nSNF: ${realSnf.toStringAsFixed(1)}%';
                                  } else if (spot.barIndex == 2) {
                                    double realFat = _reverseMapFromRateScale(
                                      spot.y,
                                    );
                                    label +=
                                        '\nFat: ${realFat.toStringAsFixed(1)}%';
                                  }
                                  return LineTooltipItem(
                                    label,
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Best Performers Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Performances',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _bestCard(
                            'Best Rate',
                            '₹${bestRate.rate}',
                            bestRate.date,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _bestCard(
                            'Best SNF',
                            '${bestSnf.snf}%',
                            bestSnf.date,
                            Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _bestCard(
                            'Best Fat',
                            '${bestFat.fat}%',
                            bestFat.date,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tip
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEECCF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.orange[800],
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tip: Milk with SNF > 8.5% and Fat > 4.5% often qualifies for premium rates!',
                          style: const TextStyle(
                            color: Color(0xFF92400E),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricCard(String title, String value, double change, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              change >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: color,
            ),
            Text(
              '${change.abs().toStringAsFixed(change >= 1 ? 0 : 1)}${title == 'Rate' ? '' : '%'}',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bestCard(String title, String value, DateTime date, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${date.day}/${date.month}',
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _periodButton(String label) {
    bool isSelected = selectedPeriod == label;
    return GestureDetector(
      onTap: () {
        if (periodData.containsKey(label)) {
          setState(() => selectedPeriod = label);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _metricChip(String label, String value) {
    bool isSelected = selectedMetric == value;
    return GestureDetector(
      onTap: () => setState(() => selectedMetric = value),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3B82F6).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFF94A3B8),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Row(
      children: [
        Container(width: 14, height: 3, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    ),
  );

  List<LineChartBarData> _getChartLines() {
    List<LineChartBarData> lines = [];

    if (selectedMetric == 'ALL' || selectedMetric == 'RATE') {
      lines.add(
        LineChartBarData(
          spots: List.generate(
            data.length,
            (i) => FlSpot(i.toDouble(), data[i].rate),
          ),
          isCurved: true,
          color: const Color(0xFF3B82F6),
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: selectedMetric == 'RATE',
            gradient: LinearGradient(
              colors: [
                const Color(0xFF3B82F6).withOpacity(0.2),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      );
    }

    if (selectedMetric == 'ALL' || selectedMetric == 'SNF') {
      lines.add(
        LineChartBarData(
          spots: List.generate(
            data.length,
            (i) => FlSpot(i.toDouble(), _mapToRateScale(data[i].snf)),
          ),
          isCurved: true,
          color: const Color(0xFF8B5CF6),
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: selectedMetric == 'SNF',
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8B5CF6).withOpacity(0.2),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      );
    }

    if (selectedMetric == 'ALL' || selectedMetric == 'FAT') {
      lines.add(
        LineChartBarData(
          spots: List.generate(
            data.length,
            (i) => FlSpot(i.toDouble(), _mapToRateScale(data[i].fat)),
          ),
          isCurved: true,
          color: const Color(0xFFF59E0B),
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: selectedMetric == 'FAT',
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF59E0B).withOpacity(0.2),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      );
    }

    return lines;
  }
}

class MilkData {
  final DateTime date;
  final double rate;
  final double snf;
  final double fat;

  MilkData(this.date, this.rate, this.snf, this.fat);
}
