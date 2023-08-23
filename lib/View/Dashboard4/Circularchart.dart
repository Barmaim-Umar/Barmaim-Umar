import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CircularChart extends StatefulWidget {
  const CircularChart({Key? key}) : super(key: key);

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart> {
  final List<ChartData> chartData = [
    ChartData('David', 25, const Color.fromRGBO(9,0,136,1)),
    ChartData('Steve', 38, const Color.fromRGBO(147,0,119,1)),
    ChartData('Jack', 34, const Color.fromRGBO(228,0,124,1)),
    ChartData('Others', 12, const Color.fromRGBO(255,189,57,1))
  ];
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            height: '80%',
              width: '80%',
              widget: PhysicalModel(
                  shape: BoxShape.circle,
                  elevation: 10,
                  shadowColor: Colors.blue,
                  color: const Color.fromRGBO(230, 230, 230, 1),
                  child: Container())),
          CircularChartAnnotation(
              widget: const Text('62%',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 25)))
        ],
        series: <CircularSeries>[
          DoughnutSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              // Radius of doughnut
              radius: '10%',
          )
        ]
    );
  }
}
class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
