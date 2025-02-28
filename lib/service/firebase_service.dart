import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final _realDB = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch the latest data under "readings"
  Future<Map<String, dynamic>?> realDBRead() async {
    try {
      // Get the currently logged-in user's UID
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }
      final String uid = user.uid;

      // Reference to the user's readings node
      final DatabaseReference ref = _realDB.ref("UsersData/$uid/readings");

      // Query the latest entry based on timestamp key
      final DataSnapshot snapshot = await ref.orderByKey().limitToLast(1).get();

      if (snapshot.exists) {
        // Extract the latest timestamp and its associated data
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final latestTimestamp = data.keys.first; // Get the latest timestamp
        final latestData = Map<String, dynamic>.from(data[latestTimestamp]);
        latestData['timestamp'] =
            latestTimestamp; // Include the timestamp in the result
        return latestData;
      } else {
        throw Exception("No data available.");
      }
    } catch (e) {
      print("Error reading data: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAllReadings() async {
    try {
      // Get the currently logged-in user's UID
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }
      final String uid = user.uid;

      // Reference to the user's readings node
      final DatabaseReference ref = _realDB.ref("UsersData/$uid/readings");

      // Query all data
      final DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        // Extract all data
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);

        // Process all timestamps and their data
        Map<String, dynamic> allData = {};
        data.forEach((timestamp, value) {
          allData[timestamp] = Map<String, dynamic>.from(value as Map);
        });

        return allData;
      } else {
        throw Exception("No data available.");
      }
    } catch (e) {
      print("Error reading data: $e");
      return null;
    }
  }

  // Method to fetch apiaries
  Future<List<Map<String, dynamic>>?> fetchApiaries() async {
    try {
      // Get the currently logged-in user's UID
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }
      final String uid = user.uid;

      // Reference to the user's apiaries collection
      final CollectionReference apiariesRef =
          _firestore.collection('Users').doc(uid).collection('Apiaries');

      // Fetch all apiaries
      final QuerySnapshot snapshot = await apiariesRef.get();

      if (snapshot.docs.isNotEmpty) {
        // Process the data into a List of Maps
        List<Map<String, dynamic>> apiaries = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>, // Include document fields
          };
        }).toList();

        return apiaries;
      } else {
        throw Exception("No apiaries found.");
      }
    } catch (e) {
      print("Error fetching apiaries: $e");
      return null;
    }
  }

  // Method to fetch hives
  Future<List<Map<String, dynamic>>?> fetchHives(String apiaryId) async {
    try {
      // Get the currently logged-in user's UID
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }
      final String uid = user.uid;

      // Reference to the user's apiaries collection
      final CollectionReference hivesRef = _firestore
          .collection('Users')
          .doc(uid)
          .collection('Apiaries')
          .doc(apiaryId)
          .collection('Hives');

      // Fetch all apiaries
      final QuerySnapshot snapshot = await hivesRef.get();

      if (snapshot.docs.isNotEmpty) {
        // Process the data into a List of Maps
        List<Map<String, dynamic>> hives = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>, // Include document fields
          };
        }).toList();

        return hives;
      } else {
        throw Exception("No hives found.");
      }
    } catch (e) {
      print("Error fetching hives: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchCurrentQueen(
      String apiaryId, String hiveId) async {
    try {
      // Get the currently logged-in user's UID
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }
      final String uid = user.uid;

      // Reference to the user's apiaries collection
      final DocumentReference currentQueenRef = _firestore
          .collection('Users')
          .doc(uid)
          .collection('Apiaries')
          .doc(apiaryId)
          .collection('Hives')
          .doc(hiveId);

      // Fetch the current hive document
      final DocumentSnapshot snapshot = await currentQueenRef.get();

      if (snapshot.exists) {
        // Safely cast the snapshot data to a Map<String, dynamic> and access 'Current Queen'
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          return data['Current Queen'] as Map<String, dynamic>?;
        } else {
          print("Document data is not a map");
          return null;
        }
      } else {
        print("No Current Queen Data Found");
        return null;
      }
    } catch (e) {
      print("Error fetching queens: $e");
      return null;
    }
  }

  // Method to fetch queens
  Future<List<Map<String, dynamic>>?> fetchOldQueens(
      String apiaryId, String hiveId) async {
    try {
      // Get the currently logged-in user's UID
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }
      final String uid = user.uid;

      // Reference to the user's apiaries collection
      final CollectionReference queensRef = _firestore
          .collection('Users')
          .doc(uid)
          .collection('Apiaries')
          .doc(apiaryId)
          .collection('Hives')
          .doc(hiveId)
          .collection("Past Queens");

      // Fetch all queens
      final QuerySnapshot snapshot = await queensRef.get();

      if (snapshot.docs.isNotEmpty) {
        // Process the data into a List of Maps
        List<Map<String, dynamic>> hives = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>, // Include document fields
          };
        }).toList();

        return hives;
      } else {
        print("No Old Queen Data Found");
        return null;
      }
    } catch (e) {
      print("Error fetching queens: $e");
      return null;
    }
  }

  Future<void> addQueenNote(
      String apiaryId, String hiveId, String newNote) async {
    try {
      // Get the currently logged-in user's UID
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }
      final String uid = user.uid;

      // Reference to the specific hive document
      final DocumentReference hiveRef = _firestore
          .collection('Users')
          .doc(uid)
          .collection('Apiaries')
          .doc(apiaryId)
          .collection('Hives')
          .doc(hiveId);

      // Add the new note to the 'Notes' array field under the 'Current Queen' field
      await hiveRef.update({
        'Current Queen.Notes': FieldValue.arrayUnion([newNote]),
      });

      print("New note added successfully!");
    } catch (e) {
      print("Error adding note: $e");
    }
  }

  Future<void> deleteCurrentQueen(String apiaryId, String hiveId) async {
    try {
      // Get the currently logged-in user's UID
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }
      final String uid = user.uid;

      // Reference to the specific hive document
      final DocumentReference hiveRef = _firestore
          .collection('Users')
          .doc(uid)
          .collection('Apiaries')
          .doc(apiaryId)
          .collection('Hives')
          .doc(hiveId);

      // Delete the 'Current Queen' field
      await hiveRef.update({
        'Current Queen': FieldValue.delete(),
      });

      print("Current Queen map deleted successfully!");
    } catch (e) {
      print("Error deleting current queen: $e");
    }
  }

  Future<void> addOldQueen(String apiaryId, String hiveId,
      Map<String, dynamic> oldQueenInfoMap) async {
    try {
      // Get the currently logged-in user's UID
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }
      final String uid = user.uid;

      // Reference to the "Past Queens" collection
      final CollectionReference queensRef = _firestore
          .collection('Users')
          .doc(uid)
          .collection('Apiaries')
          .doc(apiaryId)
          .collection('Hives')
          .doc(hiveId)
          .collection("Past Queens");

      // Add the old queen data
      await queensRef.add(oldQueenInfoMap);

      print("Old queen added successfully!");
    } catch (e) {
      print("Error adding old queen: $e");
    }
  }

  Future<void> addNewQueen(String apiaryId, String hiveId, Map<String, dynamic> newQueenInfoMap) async {
    try {
      // Get the currently logged-in user's UID
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }
      final String uid = user.uid;

      // Reference to the specific hive document
      final DocumentReference queensRef = _firestore
          .collection('Users')
          .doc(uid)
          .collection('Apiaries')
          .doc(apiaryId)
          .collection('Hives')
          .doc(hiveId);

      // Add new queen info as a map to the hive document
      await queensRef.set(newQueenInfoMap, SetOptions(merge: true));  // Using 'set' to update the document

    } catch (e) {
      print("Error adding new queen: $e");
      throw e;  // Rethrow the error after logging it
    }
  }

}
