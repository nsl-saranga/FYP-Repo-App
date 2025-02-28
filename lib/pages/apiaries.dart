import 'package:flutter/material.dart';
import '../service/firebase_service.dart';
import '../utils/constants.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../pages/hives.dart';

class ApiaryScreen extends StatefulWidget {
  const ApiaryScreen({super.key});

  @override
  _ApiaryScreenState createState() => _ApiaryScreenState();
}

class _ApiaryScreenState extends State<ApiaryScreen> {
  late Future<List<Map<String, dynamic>>?> _apiariesFuture;

  @override
  void initState() {
    super.initState();
    _fetchApiaries(); // Initialize fetching of data
  }

  void _fetchApiaries() {
    setState(() {
      _apiariesFuture = FirebaseService().fetchApiaries();
    });
  }

  void navigateToHives(BuildContext context, String apiaryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HiveScreen(apiaryId: apiaryId),
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
      // backgroundColor: const Color(0xFFFDF8D2),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _apiariesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No apiaries found'));
          } else {
            final apiaries = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                _fetchApiaries(); // Refresh data when user pulls to refresh
              },
              child: ListView.builder(
                itemCount: apiaries.length,
                itemBuilder: (context, index) {
                  final apiary = apiaries[index];
                  final apiaryID = apiary['id'] ?? ''; // Extract ID safely
                  return Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF8D2),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: accentColor,
                                radius: 30,
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/apiary.png',
                                    fit: BoxFit.contain,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                apiary['Name'] ?? 'Unknown Name',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Location: ${apiary['Location'] ?? 'Unknown'}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Hives',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                '${apiary['Status'] ?? 'Unknown'}',
                                style: const TextStyle(
                                    color: accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  navigateToHives(context, apiaryID);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                ),
                                child: const Text(
                                  'View Hives',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
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
