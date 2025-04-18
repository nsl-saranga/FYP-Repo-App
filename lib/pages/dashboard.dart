import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../utils/constants.dart';
import '../widgets/HumidityDisplay.dart';
import '../widgets/WeightDisplay.dart';
import '../service/firebase_service.dart';

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
        title: const Text(
          'Live Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      backgroundColor: formBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Status Card
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: customColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    // BoxShadow(
                    //   color: Colors.black.withOpacity(0.1),
                    //   blurRadius: 10,
                    //   spreadRadius: 2,
                    // ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusIndicator('Status', 'Normal', Icons.check_circle, Colors.green),
                    _buildStatusIndicator('Last Update', 'Just now', Icons.access_time, const Color.fromARGB(255, 248, 146, 48)),
                  ],
                ),
              ),

              if (latestData == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                // Temperature Cards
                _buildSensorCard(
                  title: 'Temperature',
                  children: [
                    _buildSensorDisplay(
                      label: 'Inside',
                      value: '${double.parse(latestData!['in_temperature'].toString()).toStringAsFixed(1)}°C',
                      icon: Icons.thermostat,
                      color: const Color.fromARGB(255, 242, 207, 13),
                    ),
                    _buildSensorDisplay(
                      label: 'Outside',
                      value: '${double.parse(latestData!['out_temperature'].toString()).toStringAsFixed(1)}°C',
                      icon: Icons.thermostat_outlined,
                      color: const Color.fromARGB(255, 248, 146, 48),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Humidity Cards
                _buildSensorCard(
                  title: 'Humidity',
                  children: [
                    _buildSensorDisplay(
                      label: 'Inside',
                      value: '${double.parse(latestData!['in_humidity'].toString()).toStringAsFixed(1)}%',
                      icon: Icons.water_drop,
                      color: Colors.blue,
                    ),
                    _buildSensorDisplay(
                      label: 'Outside',
                      value: '${double.parse(latestData!['out_humidity'].toString()).toStringAsFixed(1)}%',
                      icon: Icons.water_drop_outlined,
                      color: Colors.lightBlue,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Weight Card
                _buildSensorCard(
                  title: 'Hive Weight',
                  children: [
                    Column(
                      children: [
                        CircularProgressBar(
                          percent: double.parse(latestData!['weight'].toString()) / 100,
                          radius: 70,
                          lineWidth: 12,
                          progressColor: const Color.fromARGB(255, 242, 207, 13),
                          backgroundColor: Colors.grey.shade200,
                          label: '${latestData!['weight']}%',
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Honey Level',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildStatusIndicator(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSensorCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: customColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black.withOpacity(0.1),
          //   blurRadius: 10,
          //   spreadRadius: 2,
          // ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _buildSensorDisplay({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 30, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4037),
          ),
        ),
      ],
    );
  }
}

class CircularProgressBar extends StatelessWidget {
  final double percent;
  final double radius;
  final double lineWidth;
  final Color progressColor;
  final Color backgroundColor;
  final String label;
  final TextStyle labelStyle;

  const CircularProgressBar({
    required this.percent,
    required this.radius,
    required this.lineWidth,
    required this.progressColor,
    required this.backgroundColor,
    required this.label,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: CircularProgressIndicator(
            value: percent,
            strokeWidth: lineWidth,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        Text(label, style: labelStyle),
      ],
    );
  }
}