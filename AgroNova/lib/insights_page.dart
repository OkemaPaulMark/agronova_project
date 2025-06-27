import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Insights', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Crop Health Trends'),
            _buildHealthChart(),
            const SizedBox(height: 10),

            const SectionTitle(title: 'Weather Impact'),
            _buildWeatherChart(),
            const SizedBox(height: 10),

            const SectionTitle(title: 'Common Diagnoses'),
            _buildDiagnosesList(),
            const SizedBox(height: 10),

            const SectionTitle(title: 'Farm Activity Summary'),
            _buildActivitySummary(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthChart() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 1.5,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 30,
                sections: [
                  PieChartSectionData(
                    value: 80,
                    color: Colors.green,
                    radius: 28,
                    title: '80%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 20,
                    color: Colors.redAccent,
                    radius: 28,
                    title: '20%',
                    titleStyle: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '🟢 Healthy - 80%',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '🔴 Affected - 20%',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildWeatherChart() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 1.5,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 160,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    const days = ['S', 'M', 'T', 'W', 'T'];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        days[value.toInt()],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: [
              makeGroup(0, 2),
              makeGroup(1, 4),
              makeGroup(2, 8),
              makeGroup(3, 6),
              makeGroup(4, 7),
            ],
            maxY: 10,
          ),
        ),
      ),
    ),
  );
}


  Widget _buildDiagnosesList() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            DiagnosisItem(label: 'Leaf Spot', percent: '40%'),
            DiagnosisItem(label: 'Blight', percent: '25%'),
            DiagnosisItem(label: 'Worm Infestation', percent: '15%'),
          ],
        ),
      ),
    );
  }

Widget _buildActivitySummary() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.green[50],
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('✅ Diagnoses'),
              Text('12 crops'),
            ],
          ),
          const SizedBox(height: 10), // vertical spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('💊 Treatments Applied'),
              Text('7 crops'),
            ],
          ),
        ],
      ),
    ),
  );
}


BarChartGroupData makeGroup(int x, double y) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        width: 16,
        borderRadius: BorderRadius.circular(6),
        color: Colors.blueAccent,
      ),
    ],
  );
}

}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class DiagnosisItem extends StatelessWidget {
  final String label;
  final String percent;
  const DiagnosisItem({super.key, required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(percent),
        ],
      ),
    );
  }
}
