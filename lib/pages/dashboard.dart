import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../utils/constants.dart';
import '../widgets/HumidityDisplay.dart';
import '../widgets/WeightDisplay.dart';
import '../service/firebase_service.dart'; // Ensure correct path

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, dynamic>? latestData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final data = await _firebaseService.realDBRead();
    setState(() {
      latestData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bee Box'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFDF8D2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Display loading indicator if latestData is null
              if (latestData == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                // Row for Temperature Displays
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TemperatureColumn(
                      title: 'Inside Temperature',
                      currentValue: double.parse(
                          latestData!['in_temperature'].toString()),
                    ),
                    TemperatureColumn(
                      title: 'Outside Temperature',
                      currentValue: double.parse(
                          latestData!['out_temperature'].toString()),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Row for Humidity Displays
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HumidityColumn(
                      title: 'Inside Humidity',
                      currentValue:
                          double.parse(latestData!['in_humidity'].toString()),
                    ),
                    HumidityColumn(
                      title: 'Outside Humidity',
                      currentValue:
                          double.parse(latestData!['out_humidity'].toString()),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Row for Weight Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressBar(
                          percent: 0.75,
                          radius: 80,
                          lineWidth: 10,
                          progressColor: Colors.green,
                          backgroundColor: Colors.grey.shade300,
                          label: '75%',
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Weight',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000080),
                          ),
                        ),
                        Text(
                          '${latestData!['weight']}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class TemperatureColumn extends StatelessWidget {
  final String title;
  final double currentValue;

  const TemperatureColumn({
    required this.title,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Thermometer(
          minValue: -10,
          maxValue: 50,
          currentValue: currentValue,
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000080),
          ),
        ),
        Text(
          '${currentValue.toStringAsFixed(1)}°C',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class HumidityColumn extends StatelessWidget {
  final String title;
  final double currentValue;

  const HumidityColumn({
    required this.title,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HumidityDrop(
          minValue: 0,
          maxValue: 100,
          currentValue: currentValue,
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000080),
          ),
        ),
        Text(
          '${currentValue.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class Thermometer extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final double currentValue;

  const Thermometer({
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(40, 150),
      painter: ThermometerPainter(
        minValue: minValue,
        maxValue: maxValue,
        currentValue: currentValue,
      ),
    );
  }
}

class ThermometerPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final double currentValue;

  ThermometerPainter({
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final bulbRadius = size.width / 2;
    final rect = Rect.fromLTWH(
      size.width / 4,
      0,
      size.width / 2,
      size.height - bulbRadius * 2,
    );
    final bulbCenter = Offset(size.width / 2, size.height - bulbRadius);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(20)),
      paint,
    );
    canvas.drawCircle(bulbCenter, bulbRadius, paint);

    final tempFraction =
        ((currentValue - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
    final fillHeight = rect.height * tempFraction;
    final fillPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final filledRect = Rect.fromLTWH(
      rect.left,
      rect.bottom - fillHeight,
      rect.width,
      fillHeight,
    );
    canvas.drawRect(filledRect, fillPaint);
    canvas.drawCircle(bulbCenter, bulbRadius, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
