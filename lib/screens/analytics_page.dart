import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:se_380_project/Helper/reading_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final readingProvider = Provider.of<ReadingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(readingProvider),
              SizedBox(height: 16),
              _buildReadingProgress(readingProvider),
              SizedBox(height: 16),
              _buildWeeklyReadingChart(readingProvider),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (index){
          if(index==0){
            Navigator.pushNamed(context, '/home');
          }else  if(index==2){
            Navigator.pushNamed(context, '/settings');
          }
        },
      ),
    );
  }

  Widget _buildHeader(ReadingProvider readingProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.deepPurple[100],
      child: Column(
        children:[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(Icons.local_fire_department, 'Current streak',
                    readingProvider.currentStreak, Colors.red),
                _buildStatCard(Icons.emoji_events, 'Best streak',
                    readingProvider.bestStreak, Colors.deepOrange),
              ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(Icons.book, 'Finished', readingProvider.finishedBooks,
                  Colors.deepPurpleAccent),
              _buildStatCard(Icons.timer, 'Reading time',
                  readingProvider.readingTime, Colors.blue),
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
        boxShadow: [
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
          SizedBox(height: 8),
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.black54)),
          SizedBox(height: 4),
          Text(value.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  Widget _buildReadingProgress(ReadingProvider readingProvider) {
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
          Text('Reading Progress', style: TextStyle(fontSize: 18)),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: readingProvider.readingProgress / 100,
            backgroundColor: Colors.grey[300],
            color: Colors.deepPurple,
          ),
          SizedBox(height: 8),
          Text('${readingProvider.readingProgress.toStringAsFixed(2)}% completed'),
        ],
      ),
    );
  }


  Widget _buildWeeklyReadingChart(ReadingProvider readingProvider) {
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
                    spots: readingProvider.weeklyReadingStats.map((stat) {
                      return FlSpot(stat['day'].toDouble(), stat['hours'].toDouble());
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