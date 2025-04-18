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
  State<HiveScreen> createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  late Future<List<Map<String, dynamic>>?> _hivesFuture;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _fetchHives();
  }

  Future<void> _fetchHives() async {
    setState(() {
      _hivesFuture = _firebaseService.fetchHives(widget.apiaryId);
    });
  }

  void _navigateToQueenHistory(String hiveId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QueenHistory(
          apiaryId: widget.apiaryId,
          hiveId: hiveId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'My Hives',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        backgroundColor: primaryColor, // Orange accent
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      backgroundColor: formBackground,
      body: Stack(
        children: [
          // Content
          SafeArea(
            child: _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildContent() {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _hivesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
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
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchHives,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Retry'),
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
                  Icons.notifications_off,
                  size: 60,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No hives found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchHives,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        } else {
          final hives = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _fetchHives,
            color: primaryColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hives.length,
              itemBuilder: (context, index) => _buildHiveCard(hives[index]),
            ),
          );
        }
      },
    );
  }

  Widget _buildHiveCard(Map<String, dynamic> hive) {
    final hiveId = hive['id'] ?? '';
    final hiveName = hive['Name'] ?? 'Unknown Hive';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: customColor,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.2),
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
            onTap: () {}, // Optional: Add an onTap action for the entire card
            splashColor: accentColor.withOpacity(0.3),
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
                          'assets/bees.png', // Replace with your actual asset path
                          width: 50,
                          height: 50,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hiveName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: $hiveId',
                              style: TextStyle(
                                fontSize: 14,
                                color: textColor.withOpacity(0.7),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: textColor),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        label: 'Live',
                        icon: Icons.visibility,
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardPage(),
                            ),
                          );
                        },
                      ),
                      _buildActionButton(
                        label: 'History',
                        icon: Icons.history,
                        color: accentColor,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TimeAnalysis(),
                            ),
                          );
                        },
                      ),
                      _buildActionButton(
                        label: 'Queen',
                        icon: Icons.auto_awesome,
                        color: Colors.green,
                        onPressed: () => _navigateToQueenHistory(hiveId),
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
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import '../service/firebase_service.dart';
// import '../utils/constants.dart';
// import '../widgets/bottom_navigation_bar.dart';
// import 'timely_data.dart';
// import 'dashboard.dart';
// import 'queen_history.dart';
//
// class HiveScreen extends StatefulWidget {
//   final String apiaryId;
//   const HiveScreen({super.key, required this.apiaryId});
//
//   @override
//   _HiveScreenState createState() => _HiveScreenState();
// }
//
// class _HiveScreenState extends State<HiveScreen> {
//   late Future<List<Map<String, dynamic>>?> _hivesFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchHives();
//   }
//
//   void _fetchHives() {
//     setState(() {
//       _hivesFuture = FirebaseService().fetchHives(widget.apiaryId);
//     });
//   }
//
//   void navigateToQueenHistory(
//       BuildContext context, String apiaryId, String hiveId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => QueenHistory(apiaryId: apiaryId, hiveId: hiveId),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Hi Liyanage!'),
//         backgroundColor: primaryColor,
//         centerTitle: true,
//       ),
//       backgroundColor: const Color(0xFFFDF8D2),
//       body: FutureBuilder<List<Map<String, dynamic>>?>(
//         future: _hivesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No hives found'));
//           } else {
//             final hives = snapshot.data!;
//             return RefreshIndicator(
//               onRefresh: () async {
//                 _fetchHives();
//               },
//               child: ListView.builder(
//                 itemCount: hives.length,
//                 itemBuilder: (context, index) {
//                   final hive = hives[index];
//                   final hiveID = hive['id'] ?? '';
//                   return Container(
//                     margin: const EdgeInsets.fromLTRB(40, 20, 40, 20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 3,
//                           blurRadius: 7,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               const CircleAvatar(
//                                 backgroundColor: accentColor,
//                                 radius: 30,
//                                 backgroundImage:
//                                     AssetImage('assets/beehive.png'),
//                               ),
//                               Text(
//                                 hive['Name'] ?? 'Unknown Name',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           const DashboardPage(),
//                                     ),
//                                   );
//                                 },
//                                 style: ButtonStyle(
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Colors.blue),
//                                   shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                   ),
//                                 ),
//                                 child: const Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: 3,
//                                     horizontal: 1,
//                                   ),
//                                   child: Text(
//                                     'Live',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 5),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           const TimeAnalysis(),
//                                     ),
//                                   );
//                                 },
//                                 style: ButtonStyle(
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           accentColor),
//                                   shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                   ),
//                                 ),
//                                 child: const Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: 0,
//                                     horizontal: 0,
//                                   ),
//                                   child: Text(
//                                     'History',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 5),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   navigateToQueenHistory(
//                                       context, widget.apiaryId, hiveID);
//                                 },
//                                 style: ButtonStyle(
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Colors.green),
//                                   shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                   ),
//                                 ),
//                                 child: const Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: 3,
//                                     horizontal: 3,
//                                   ),
//                                   child: Text(
//                                     'Queen',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           }
//         },
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(),
//     );
//   }
// }
