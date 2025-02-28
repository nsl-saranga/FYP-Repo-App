import 'package:flutter/material.dart';
import '../service/firebase_service.dart';
import '../utils/constants.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'timely_data.dart';
import 'dashboard.dart';
import 'queen_history.dart';

class HiveScreen extends StatefulWidget {
  final String apiaryId;
  const HiveScreen({super.key, required this.apiaryId});

  @override
  _HiveScreenState createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  late Future<List<Map<String, dynamic>>?> _hivesFuture;

  @override
  void initState() {
    super.initState();
    _fetchHives();
  }

  void _fetchHives() {
    setState(() {
      _hivesFuture = FirebaseService().fetchHives(widget.apiaryId);
    });
  }

  void navigateToQueenHistory(
      BuildContext context, String apiaryId, String hiveId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QueenHistory(apiaryId: apiaryId, hiveId: hiveId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi Liyanage!'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFDF8D2),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _hivesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hives found'));
          } else {
            final hives = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                _fetchHives();
              },
              child: ListView.builder(
                itemCount: hives.length,
                itemBuilder: (context, index) {
                  final hive = hives[index];
                  final hiveID = hive['id'] ?? '';
                  return Container(
                    margin: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const CircleAvatar(
                                backgroundColor: accentColor,
                                radius: 30,
                                backgroundImage:
                                    AssetImage('assets/beehive.png'),
                              ),
                              Text(
                                hive['Name'] ?? 'Unknown Name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardPage(),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 3,
                                    horizontal: 1,
                                  ),
                                  child: Text(
                                    'Live',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TimeAnalysis(),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          accentColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 0,
                                  ),
                                  child: Text(
                                    'History',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: () {
                                  navigateToQueenHistory(
                                      context, widget.apiaryId, hiveID);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 3,
                                    horizontal: 3,
                                  ),
                                  child: Text(
                                    'Queen',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
