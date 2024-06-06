import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ulmatech/screens/signupScreen.dart';

class Crud {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<List<Map<String, String>>> getUserMedicines(String userID) async {
    List<Map<String, String>> userMedicines = [];
    print("hello 1") ;
    try
    {
      DocumentSnapshot userDoc = await _db.collection('users').doc(userID).get();
      if (userDoc.exists) {
        print("hello 2") ;
        var userData = userDoc.data();
        if (userData != null && userData is Map<String, dynamic> && userData['medicines'] != null) {
          // Convert each entry in the list to Map<String, String>
          print("hello 3") ;
          for (var entry in userData['medicines']) {
            Map<String, String> convertedEntry = {};
            entry.forEach((key, value) {
              convertedEntry[key] = value.toString();
            });
            print("this is converted list"+convertedEntry.toString()) ;
            userMedicines.add(convertedEntry);
          }
          return userMedicines;
        }
      }
      return [];
    } catch (e) {
      print("Error fetching user medicines: $e");
      return []; // Return empty list on error
    }
  }












  Future<void> addUserWithMedicines(String userID, List<Map<String, String>> medicines) async {
    // Ensure Firestore is initialized
    await Firebase.initializeApp();

    // Fetch the current medicines array
    DocumentSnapshot userDoc = await _db.collection('users').doc(userID).get();
    List<dynamic> existingMedicines = [];

    if (userDoc.exists) {
      var userData = userDoc.data();
      if (userData != null && userData is Map<String, dynamic> && userData['medicines'] != null) {
        existingMedicines = List<dynamic>.from(userData['medicines']);
      }
    }

    // Add new medicines to the existing list (ensuring no duplicates)
    List<Map<String, String>> newMedicinesToAdd = medicines.where((medicine) {
      return !existingMedicines.contains(medicine);
    }).toList();

    if (newMedicinesToAdd.isNotEmpty) {
      if (userDoc.exists) {
        // Update the Firestore document with the updated list
        await _db.collection('users').doc(userID).update({
          'medicines': FieldValue.arrayUnion(newMedicinesToAdd),
        });
      } else {
        // Create a new document with the initial medicines list
        await _db.collection('users').doc(userID).set({
          'username': UserName ,
          'medicines': newMedicinesToAdd,
        });
      }
    }
  }
}
