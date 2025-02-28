import 'package:flutter/material.dart';
import '../service/firebase_service.dart';
import '../utils/constants.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_queen.dart';
import 'package:flutter/services.dart';

class QueenHistory extends StatefulWidget {
  final String apiaryId;
  final String hiveId;

  const QueenHistory({super.key, required this.apiaryId, required this.hiveId});

  @override
  _QueenHistoryState createState() => _QueenHistoryState();
}

class _QueenHistoryState extends State<QueenHistory> {
  late Future<List<Map<String, dynamic>>?> _oldQueensFuture;
  late Future<Map<String, dynamic>?> _currentQueenFuture;
  TextEditingController noteController = TextEditingController();
  TextEditingController replacedReasonController= TextEditingController();
  TextEditingController replacedDateController= TextEditingController();
  TextEditingController queenSequenceController= TextEditingController();
  DateTime? replacedDate;
  TextEditingController originController = TextEditingController();
  DateTime? introducedDate;


  @override
  void initState() {
    super.initState();
    _fetchQueens();
  }

  void _fetchQueens() {
    setState(() {
      _currentQueenFuture =
          FirebaseService().fetchCurrentQueen(widget.apiaryId, widget.hiveId);
      _oldQueensFuture =
          FirebaseService().fetchOldQueens(widget.apiaryId, widget.hiveId);
    });
  }

  String calculateYearsActive(Timestamp? dateIntroduced, Timestamp? dateReplaced) {
    if (dateIntroduced == null || dateReplaced == null) {
      return 'Unknown';
    }
    DateTime introducedDate = dateIntroduced.toDate();
    DateTime replacedDate = dateReplaced.toDate();
    int yearsActive = replacedDate.year - introducedDate.year;

    if (replacedDate.month < introducedDate.month ||
        (replacedDate.month == introducedDate.month &&
            replacedDate.day < introducedDate.day)) {
      yearsActive--;
    }
    return yearsActive < 1 ? "Below 1 year" : "$yearsActive years";
  }

  String calculateAge(Timestamp? dateIntroduced) {
    if (dateIntroduced == null) {
      return 'Unknown';
    }
    DateTime introducedDate = dateIntroduced.toDate();
    DateTime currentDate = DateTime.now();
    int ageInYears = currentDate.year - introducedDate.year;

    if (currentDate.month < introducedDate.month ||
        (currentDate.month == introducedDate.month &&
            currentDate.day < introducedDate.day)) {
      ageInYears--;
    }
    return ageInYears < 1 ? "Below 1 year" : "$ageInYears years";
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget buildCurrentQueenCard(Map<String, dynamic> currentQueen) {
    final introducedDate = currentQueen['Introduced Date'] as Timestamp?;
    final origin = currentQueen['Origin'] ?? 'Unknown';
    final notes = currentQueen['Notes'] as List<dynamic>?;

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange.shade100,
                  radius: 35,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/Queen.png',
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Origin: $origin',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Introduced: ${introducedDate?.toDate().toLocal().toString().split(' ')[0] ?? 'Unknown'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Age: ${calculateAge(introducedDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Notes:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    AddQueenNote();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(2),
                  ),
                  child: const Icon(Icons.add, size: 24),
                ),
              ],
            ),
            notes != null && notes.isNotEmpty
                ? Column(
              children: notes.reversed.map((note) {
                return Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  width: double.infinity, // Ensure same width for all notes
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Text(
                    note,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                );
              }).toList(),
            )
                : const Text('No notes available.'),
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  ReplaceCurrentQueen();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                ),
                child: const Text(
                  'Replace Queen',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildOldQueensTable(List<Map<String, dynamic>> queens) {
    // Sort queens by Queen Sequence
    // Sort queens by Queen Sequence
    queens.sort((a, b) {
      int seqA = int.tryParse(a['Queen Sequence']?.toString() ?? '0') ?? 0;
      int seqB = int.tryParse(b['Queen Sequence']?.toString() ?? '0') ?? 0;

      return seqA.compareTo(seqB); // Sorts in ascending order
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20.0,
        headingRowColor: MaterialStateColor.resolveWith(
              (states) => Colors.orange,
        ),
        columns: const [
          DataColumn(
            label: Text(
              'Queen Sequence',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Date Introduced',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Date Replaced',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Years Active',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Origin',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: queens.map((queen) {
          final introducedDate = queen['Introduced Date'] as Timestamp?;
          final removedDate = queen['Replaced Date'] as Timestamp?;
          final yearsActive = introducedDate != null
              ? calculateYearsActive(introducedDate, removedDate)
              : 0;

          return DataRow(
            cells: [
              DataCell(Text(queen['Queen Sequence'] ?? 'Unknown')),
              DataCell(Text(
                ' ${introducedDate?.toDate().toLocal().toString().split(' ')[0] ?? 'Unknown'}',
              )),
              DataCell(Text(
                ' ${removedDate?.toDate().toLocal().toString().split(' ')[0] ?? 'Unknown'}',
              )),
              DataCell(Text(yearsActive.toString())),
              DataCell(Text(queen['Origin'] ?? 'Unknown')),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Queen History'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            buildSectionTitle("Current Queen"),
            FutureBuilder<Map<String, dynamic>?>(
              future: _currentQueenFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No current queen data found.'),
                        ElevatedButton(
                          onPressed: () {
                            AddNewQueen();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                          ),
                          child: const Text(
                            'Add New Queen',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else {
                  return buildCurrentQueenCard(snapshot.data!);
                }
              },
            ),
            buildSectionTitle("Past Queens"),
            FutureBuilder<List<Map<String, dynamic>>?>(
              future: _oldQueensFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No queen history data found.'));
                } else {
                  return buildOldQueensTable(snapshot.data!);
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Future AddQueenNote()=> showDialog(context: context, builder: (context)=>AlertDialog(
    content:Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);

                    },
                    child: const Icon(Icons.cancel)),
                const SizedBox(width: 60.0,),
                const Text(
                  "Add",
                  style: TextStyle(
                      color: Color.fromARGB(255, 169, 158, 60),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Note",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 193, 37),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),

              ],
            ),
            const SizedBox(height: 20.0,),

            const Text("New Note",style: TextStyle(color:Colors.black,fontSize: 15.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0,),
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              decoration:BoxDecoration(
                  color: const Color.fromARGB(70, 251, 247, 5),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black)
              ),
              child: TextField(
                controller: noteController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            Center(child: ElevatedButton (onPressed: ()async{
              await FirebaseService().addQueenNote(widget.apiaryId, widget.hiveId, noteController.text).then((value) {
                Navigator.pop(context);
              });
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, ),child: const Text("Add"),)),
          ],
        ),
      ),
    ),
  ));

  Future ReplaceCurrentQueen() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.cancel),
                      ),
                      const SizedBox(width: 60.0),
                      const Text(
                        "Replace",
                        style: TextStyle(
                          color: Color.fromARGB(255, 169, 158, 60),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Queen",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 193, 37),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Queen Sequence",
                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(70, 251, 247, 5),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: queenSequenceController,
                      keyboardType: TextInputType.number,  // ensures numeric keyboard is shown
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,  // allows only digits
                      ],
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),

                  const Text(
                    "Replaced Date",
                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          replacedDateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format date as a string
                          replacedDate = pickedDate; // Store the selected DateTime
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(70, 251, 247, 5),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextField(
                          controller: replacedDateController,
                          decoration: const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Replaced Reason",
                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(70, 251, 247, 5),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: replacedReasonController,
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),
    Center(
      child: ElevatedButton(
        onPressed: () async {
          try {
            final currentQueen = await FirebaseService().fetchCurrentQueen(widget.apiaryId, widget.hiveId);

            final Timestamp? introducedDate = currentQueen?['Introduced Date'] as Timestamp?;
            final String origin = currentQueen?['Origin'] ?? 'Unknown';

            await FirebaseService().deleteCurrentQueen(widget.apiaryId, widget.hiveId);

            Map<String, dynamic> oldQueenInfoMap = {
              "Queen Sequence": queenSequenceController.text,
              "Introduced Date": introducedDate,
              "Origin": origin,
              "Replaced Date": Timestamp.fromDate(replacedDate!),
              "Replaced Reason": replacedReasonController.text,
            };

            await FirebaseService().addOldQueen(widget.apiaryId, widget.hiveId, oldQueenInfoMap);

            // Close the screen after successful operation
            if (context.mounted) {
              Navigator.pop(context);
            }
          } catch (e) {
            print("Error: $e"); // Handle errors properly
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
        ),
        child: const Text("Add"),
      ),
    ),
  ],
      ),
    ),
  )));


  Future AddNewQueen()=> showDialog(context: context, builder: (context)=>AlertDialog(
    content:Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);

                    },
                    child: const Icon(Icons.cancel)),
                const SizedBox(width: 60.0,),
                const Text(
                  "Add",
                  style: TextStyle(
                      color: Color.fromARGB(255, 169, 158, 60),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "New Queen",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 193, 37),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),

              ],
            ),
            const SizedBox(height: 20.0,),
            const Text(
              "Replaced Date",
              style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    replacedDateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format date as a string
                    replacedDate = pickedDate; // Store the selected DateTime
                  });
                }
              },
              child: AbsorbPointer(
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(70, 251, 247, 5),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: replacedDateController,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
            ),

            const Text("Queen Origin",style: TextStyle(color:Colors.black,fontSize: 15.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0,),
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              decoration:BoxDecoration(
                  color: const Color.fromARGB(70, 251, 247, 5),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black)
              ),
              child: TextField(
                controller: originController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            Center(child: ElevatedButton (onPressed: ()async{
              Map<String, dynamic> newQueenInfoMap = {
                "Current Queen": {
                  "Introduced Date": Timestamp.fromDate(replacedDate!),
                  "Origin": originController.text,
                },
              };
              await FirebaseService().addNewQueen(widget.apiaryId, widget.hiveId, newQueenInfoMap).then((value) {
                Navigator.pop(context);
              });
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, ),child: const Text("Add"),)),
          ],
        ),
      ),
    ),
  ));
}
