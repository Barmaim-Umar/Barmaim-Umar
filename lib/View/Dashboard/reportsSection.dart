import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChartPage(),
    );
  }
}

class ChartPage extends StatelessWidget {
  final List<ChartData> chartData = [
    ChartData('Sun', 300, 200, 500),
    ChartData('Mon', 300, 100, 400),
    ChartData('Tue', 150, 120, 350),
    ChartData('Wed', 400, 50, 450),
    ChartData('Thu', 100, 0, 100),
    ChartData('Fri', 50, 60, 150),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: SfCartesianChart(
          borderColor: Colors.transparent,
          title: ChartTitle(
              text: 'Delivery Reports Chart',
              textStyle: TextStyle(color: Colors.white)),
          primaryXAxis: CategoryAxis(
            majorGridLines: MajorGridLines(width: 0),
            axisLine: AxisLine(width: 0), borderColor: Colors.transparent, borderWidth: 0.0,
            labelStyle:
            TextStyle(color: Colors.white), // Remove X-axis grid lines
          ),
          primaryYAxis: NumericAxis(
            majorGridLines:
            MajorGridLines(width: 0), // Remove Y-axis grid lines
            axisLine: AxisLine(width: 0), // Hide Y-axis line
            labelFormat: '{value}',
            labelStyle: TextStyle(color: Colors.white),
            // Show percentage format for Y-axis labels
          ),
          series: <ChartSeries>[
            StackedColumnSeries<ChartData, String>(
              dataLabelSettings: DataLabelSettings(isVisible: true),
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.day,
              yValueMapper: (ChartData data, _) => data.onTime,
              name: 'On Time',

              color: Colors.green, // Green color for "On Time" series
            ),
            StackedColumnSeries<ChartData, String>(
              dataLabelSettings: DataLabelSettings(isVisible: true),
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.day,
              yValueMapper: (ChartData data, _) => data.late,
              name: 'Late',
              color: Color.fromARGB(255, 255, 251, 0), // Orange color for "Late" series
            ),
            StackedColumnSeries<ChartData, String>(
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: Colors.white),
              ),
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.day,
              yValueMapper: (ChartData data, _) => data.total,
              name: 'Total',
              color: Colors.blue, // Blue color for "Total" series
            ),
          ],
          legend: Legend(
              textStyle: TextStyle(color: Colors.white), isVisible: true),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.day, this.onTime, this.late, this.total);
  final String day;
  final int onTime;
  final int late;
  final int total;
}
