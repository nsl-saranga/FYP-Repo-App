import 'package:flutter/material.dart';
import '../models/temperature_data.dart';
import '../models/humidity_data.dart';
import '../models/weight_data.dart';
import '../utils/constants.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/timely_chart_mutiple.dart';
import '../widgets/timely_chart_single.dart';
import '../service/firebase_service.dart';
import '../utils/constants.dart';

class TimeAnalysis extends StatefulWidget {
  const TimeAnalysis({super.key});

  @override
  State<TimeAnalysis> createState() => _TimeAnalysisState();
}

class _TimeAnalysisState extends State<TimeAnalysis> {
  List<TemperatureData> insideTempData = [];
  List<TemperatureData> outsideTempData = [];
  List<HumData> insideHumData = [];
  List<HumData> outsideHumData = [];
  List<WeightData> weightData = [];
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await _firebaseService.getAllReadings();
      if (data != null && data is Map<String, dynamic>) {
        print("All Readings: $data");

        setState(() {
          insideTempData = data.entries.map((entry) {
            final int unixTimestamp = int.tryParse(entry.key) ?? 0;
            final DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
            final double insideTemperature = double.tryParse(
                    entry.value['in_temperature']?.toString() ?? '') ??
                0.0;
            return TemperatureData(dateTime, insideTemperature);
          }).toList();

          outsideTempData = data.entries.map((entry) {
            final int unixTimestamp = int.parse(entry.key);
            final DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
            final double outsideTemperature =
                double.tryParse(entry.value['out_temperature'].toString()) ??
                    0.0;

            return TemperatureData(dateTime, outsideTemperature);
          }).toList();

          insideHumData = data.entries.map((entry) {
            final int unixTimestamp = int.tryParse(entry.key) ?? 0;
            final DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
            final double insideHumidity =
                double.tryParse(entry.value['in_humidity']?.toString() ?? '') ??
                    0.0;
            return HumData(dateTime, insideHumidity);
          }).toList();

          outsideHumData = data.entries.map((entry) {
            final int unixTimestamp = int.tryParse(entry.key) ?? 0;
            final DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
            final double outsideHumidity = double.tryParse(
                    entry.value['out_humidity']?.toString() ?? '') ??
                0.0;
            return HumData(dateTime, outsideHumidity);
          }).toList();

          weightData = data.entries.map((entry) {
            final int unixTimestamp = int.tryParse(entry.key) ?? 0;
            final DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
            final double weight =
                double.tryParse(entry.value['weight']?.toString() ?? '') ?? 0.0;
            return WeightData(dateTime, weight);
          }).toList();
        });
      } else {
        print("No data found.");
      }
    } catch (e) {
      print("Error fetching readings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Analysis'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFDF8D2),
      body: Stack(
        children: [
          // Background image with opacity
          // Positioned.fill(
          //   child: Opacity(
          //     opacity:  0.8, // Set the opacity here
          //     child: Image.asset(
          //       backgroundImage, // Adjust the path according to your image location
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // Main content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                TimeChartWidget(
                  title: "Temperature Analysis",
                  insideData: insideTempData,
                  outsideData: outsideTempData,
                ),
                SizedBox(height: 15),
                TimeChartWidget(
                  title: "Humidity Analysis",
                  insideData: insideHumData,
                  outsideData: outsideHumData,
                ),
                SizedBox(height: 15),
                SingleTimeChartWidget(
                  title: "Weight Analysis",
                  Data: weightData,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
