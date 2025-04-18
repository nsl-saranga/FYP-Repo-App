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
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _fetchApiaries();
  }

  void _fetchApiaries() {
    setState(() {
      _apiariesFuture = _firebaseService.fetchApiaries();
    });
  }

  void _navigateToHives(BuildContext context, String apiaryId) {
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
        title: const Text(
          'My Apiaries',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        backgroundColor: primaryColor, // Orange accent
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      backgroundColor: formBackground, // Light cream background
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: _apiariesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 248, 146, 48),
                  strokeWidth: 3,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchApiaries,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 248, 146, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.hive_outlined,
                      size: 60,
                      color: Color(0xFF5D4037),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No apiaries found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchApiaries,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 248, 146, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Refresh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final apiaries = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async => _fetchApiaries(),
                color: const Color.fromARGB(255, 248, 146, 48),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: apiaries.length,
                  itemBuilder: (context, index) {
                    final apiary = apiaries[index];
                    final apiaryId = apiary['id'] ?? '';
                    final apiaryName = apiary['Name'] ?? 'Unknown Apiary';
                    final location = apiary['Location'] ?? 'Unknown Location';
                    final status = apiary['Status'] ?? 'Active';

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        color: customColor,
                        borderRadius: BorderRadius.circular(16),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.1),
                        //     spreadRadius: 1,
                        //     blurRadius: 10,
                        //     offset: const Offset(0, 4),
                        //   ),
                        // ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: const Color.fromARGB(255, 248, 146, 48).withOpacity(0.3),
                            onTap: () => _navigateToHives(context, apiaryId),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Image.asset(
                                          'assets/new.png', // Replace with your actual asset path
                                          width: 50,
                                          height: 50,
                                          color: accentColor,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              apiaryName,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF5D4037),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              location,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF5D4037),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Divider(height: 1, thickness: 1, color: textColor),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => _navigateToHives(context, apiaryId),
                                        // icon: const Icon(Icons.chevron_right, size: 20),
                                        label: const Text(
                                            'View Hives',
                                             style: const TextStyle(
                                               fontSize: 15,
                                               color: formBackground
                                             ),),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                          backgroundColor: accentColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar:  CustomBottomNavigationBar(),
    );
  }
}