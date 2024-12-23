import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../Firebase/AuthService.dart';

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 16),
              _buildReadingProgress(),
              SizedBox(height: 16),
              _buildWeeklyReadingChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.deepPurple[100]
      ),
      child: Column(
        children:[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(Icons.local_fire_department, 'Current streak',
                    AuthService.userStats["currentStreak"], Colors.red),
                _buildStatCard(Icons.emoji_events, 'Best streak',
                    AuthService.userStats["bestStreak"], Colors.deepOrange),
              ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(Icons.book, 'Finished', AuthService.userStats["finishedBooks"],
                  Colors.deepPurpleAccent),
              _buildStatCard(Icons.timer, 'Reading time',
                  0, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, int value, Color color) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          SizedBox(height: 4),
          Text(value.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  Widget _buildReadingProgress() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.deepPurple,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reading Progress', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: AuthService.userStats["readingProgress"] / 100,
            backgroundColor: Colors.grey[300],
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 8),
          Text('${AuthService.userStats["currentStreak"].toStringAsFixed(2)}% completed'),
        ],
      ),
    );
  }


  Widget _buildWeeklyReadingChart() {
    final gradientColors = [
      Colors.deepPurple,
      Colors.deepPurple.withOpacity(0.5),
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Reading Stats', style: TextStyle(fontSize: 18)),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Text(daysOfWeek[value.toInt()]);
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: AuthService.userStats["readingStats"].map<FlSpot>((stat) {
                      final day = double.tryParse(stat['day'].toString()) ?? 0.0;
                      final hours = double.tryParse(stat['hours'].toString()) ?? 0.0;
                      return FlSpot(day, hours);
                    }).toList(),
                    isCurved: true,
                    color: Colors.greenAccent,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}