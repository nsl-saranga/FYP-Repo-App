import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class SingleTimeChartWidget extends StatelessWidget {
  final String title;
  final List<dynamic> Data;

  const SingleTimeChartWidget({
    super.key,
    required this.title,
    required this.Data,
  });

  @override
  Widget build(BuildContext context) {
    if (Data.isEmpty) {
      return const Text('No data available');
    }

    // Sort data by dateTime to ensure proper line connection
    final sortedData = List.from(Data)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // Debug: Print data points to check for issues
    print('Chart Data Points for $title:');
    for (var item in sortedData) {
      print('DateTime: ${item.dateTime}, Weight: ${item.weight}');
    }

    DateTime minDate = sortedData.first.dateTime;
    DateTime maxDate = sortedData.last.dateTime;

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
          majorGridLines: const MajorGridLines(width: 0),
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
        legend: const Legend(isVisible: false), // No need for legend with single series
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries>[
          LineSeries<dynamic, DateTime>(
            dataSource: sortedData,
            xValueMapper: (dynamic item, _) => item.dateTime,
            yValueMapper: (dynamic item, _) => item.weight,
            name: "Weight",
            color: Colors.green,
            width: 2.5, // Make the line more visible
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,

            ),
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            // Enable this to check if there are nulls or zeros creating gaps
            // emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
          ),
        ],
      ),
    );
  }
}