import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../models/temperature_data.dart';
import '../models/humidity_data.dart';
import '../utils/constants.dart';

class TimeChartWidget extends StatelessWidget {
  final String title;
  final List<dynamic> insideData;
  final List<dynamic> outsideData;

  const TimeChartWidget({
    super.key,
    required this.title,
    required this.insideData,
    required this.outsideData,
  });

  @override
  Widget build(BuildContext context) {
    if (insideData.isEmpty || outsideData.isEmpty) {
      return const Text('No data available');
    }

    // Sort data by dateTime to ensure proper line connection
    final sortedInsideData = List.from(insideData)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    final sortedOutsideData = List.from(outsideData)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // Use the earliest and latest dates from both datasets
    List<DateTime> allDates = [
      ...sortedInsideData.map((item) => item.dateTime),
      ...sortedOutsideData.map((item) => item.dateTime)
    ];

    DateTime minDate = allDates.reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime maxDate = allDates.reduce((a, b) => a.isAfter(b) ? a : b);

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: customColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          minimum: minDate,
          maximum: maxDate,
          intervalType: DateTimeIntervalType.auto,
          dateFormat: DateFormat('MM/dd\nhh:mm a'),
          labelRotation: -45,
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0.5),
          axisLine: const AxisLine(width: 1),
        ),
        title: ChartTitle(
          text: title,
          textStyle: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          alignment: ChartAlignment.center,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries>[
          LineSeries<dynamic, DateTime>(
            dataSource: sortedInsideData,
            xValueMapper: (dynamic item, _) => item.dateTime,
            yValueMapper: (dynamic item, _) {
              if (item is TemperatureData) {
                return item.temperature;
              } else if (item is HumData) {
                return item.humidity;
              }
              return 0;
            },
            name: 'Inside',
            color: Colors.blue,
            width: 2.0,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              height: 4,
              width: 4,
            ),
            // Explicitly disable data labels
            dataLabelSettings: const DataLabelSettings(isVisible: false),
          ),
          LineSeries<dynamic, DateTime>(
            dataSource: sortedOutsideData,
            xValueMapper: (dynamic item, _) => item.dateTime,
            yValueMapper: (dynamic item, _) {
              if (item is TemperatureData) {
                return item.temperature;
              } else if (item is HumData) {
                return item.humidity;
              }
              return 0;
            },
            name: 'Outside',
            color: const Color.fromARGB(255, 248, 146, 48),
            width: 2.0,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              height: 4,
              width: 4,
            ),
            // Explicitly disable data labels
            dataLabelSettings: const DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }
}