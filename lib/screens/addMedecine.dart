import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:icon_forest/amazingneoicons.dart';
import 'package:icon_forest/app_crypto_icons.dart';
import 'package:icon_forest/ternav_icons_duotone.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ulmatech/resources/medicineListMaker.dart';
import 'package:ulmatech/screens/homeScreen.dart';
import 'package:ulmatech/widgets/comparment.dart';
import 'package:ulmatech/widgets/text_Field.dart';
import 'package:ulmatech/resources/FirebaseCRUD.dart';

import '../main.dart';

class AddMedecine extends StatefulWidget {
  const AddMedecine({super.key});

  @override
  State<AddMedecine> createState() => _AddMedecineState();
}

class _AddMedecineState extends State<AddMedecine> {
  TextEditingController _medicineNameController = TextEditingController();
  TextEditingController _timesPerDayController = TextEditingController();
  String type = '';
  String medicineFoodStatus  = '' ;
  int quantityCount = 2;
  DateTime? startDate;
  DateTime? endDate;
  late StreamSubscription<InternetConnectionStatus> connectionSubscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Start listening for internet connection changes
    connectionSubscription = InternetConnectionChecker().onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.disconnected) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Image.asset("assets/connection.png",  scale: 2,) ;
          },
        );
      } else if (status == InternetConnectionStatus.connected) {
        Navigator.of(context).pop(); // Close the dialog when internet is reconnected
      }
    });


  }

  String frequencyOfDays = "Every Day";
  Map<String, bool> weekdays = {
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
  };

  String selectedFoodStatus = '';

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _selectFrequencyOfDays(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text("Every Day"),
                    leading: Radio<String>(
                      value: "Every Day",
                      groupValue: frequencyOfDays,
                      onChanged: (String? value) {
                        setState(() {
                          frequencyOfDays = value!;
                          weekdays.updateAll((key, value) => false);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ...weekdays.keys.map((String key) {
                    return CheckboxListTile(
                      title: Text(key),
                      value: weekdays[key],
                      onChanged: (bool? value) {
                        setModalState(() {
                          weekdays[key] = value!;
                          if (weekdays.values.every((element) => element == true)) {
                            setState(() {
                              frequencyOfDays = "Every Day";
                            });
                          } else {
                            setState(() {
                              frequencyOfDays = "Custom";
                            });
                          }
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }



  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      // 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Medicine Added',
      'Your medicine has been added successfully',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Add Medicines",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _medicineNameController,
                decoration: InputDecoration(
                  hintText: "Medicine Name",
                  filled: false,
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1.0,
                    ),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 220.0),
              child: Text(
                "Compartment",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: const Row(
                  children: [
                   Compartment(number: 1),
                    Compartment(number: 2),
                    Compartment(number: 3),
                    Compartment(number: 4),
                    Compartment(number: 5),
                    Compartment(number: 6),
                    Compartment(number: 7),
                    Compartment(number: 8),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 280.0),
              child: Text(
                "Color",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    colorCircle(color: const Color(0xFFf8cff1)),
                    colorCircle(color: const Color(0xFFC2B6FF)),
                    colorCircle(color: const Color(0xFFFE9695)),
                    colorCircle(color: const Color(0xFFCEFCBE)),
                    colorCircle(color: const Color(0xFFFAC291)),
                    colorCircle(color: const Color(0xFFBAE6FF)),
                    colorCircle(color: const Color(0xFFFFFDC3)),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 290.0),
              child: Text(
                "Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          type = 'capsulecropped.jpg';
                        });
                        print(type);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: type == 'capsulecropped.jpg' ? Border.all(color: Colors.blue, width: 2.0) : null,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Image.asset(
                              'assets/capsulecropped.jpg',
                              scale: 1.3,
                            ),

                            const Text("Capsules") ,
                            const SizedBox(
                              height: 70,
                            ),

                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          type = 'cream.jpeg';
                        });
                        print(type);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: type == 'cream.jpeg' ? Border.all(color: Colors.blue, width: 2.0) : null,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Image.asset(
                              'assets/cream.jpeg',
                              scale: 1.3,
                            ),
                            const Text("Creams")
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          type = 'syrup.jpeg';
                        });
                        print(type);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: type == 'syrup.jpeg' ? Border.all(color: Colors.blue, width: 2.0) : null,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Image.asset(
                              'assets/syrup.jpeg',
                              scale: 1.3,
                            ),
                            const Text("syrup")
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 250.0),
              child: Text(
                "Quantity",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 45,
                  width: 260,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      "Take $quantityCount",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      quantityCount--;
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    height: 40,
                    width: 40,
                    child: const Center(
                      child: Icon(
                        Icons.remove,
                        color: Color(0xFF6f8bef),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      quantityCount++;
                    });
                  },
                  child: Container(
                    color: const Color(0xFF6f8bef),
                    height: 40,
                    width: 40,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 250.0),
              child: Text(
                "Set Date",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      height: 45,
                      width: 260,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          startDate == null
                              ? "Start Date"
                              : "${startDate.toString().split(' ')[0]}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      height: 45,
                      width: 260,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          endDate == null
                              ? "End Date"
                              : "${endDate.toString().split(' ')[0]}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 170.0),
              child: Text(
                "Frequency of Days",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () => _selectFrequencyOfDays(context),
                child: SingleChildScrollView(
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        frequencyOfDays,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 120, 0),
              child: Text(
                "How many times a Day",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Center(
                  child:
                  TextField(
                    controller: _timesPerDayController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter number of times per day",
                      hintStyle: TextStyle(color: Colors.black),
                      contentPadding: EdgeInsets.symmetric(horizontal: 40 , vertical: 10),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFoodStatus= 'Before food';
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedFoodStatus == 'Before food' ? const Color(0xFFb2c3fe) : const Color(0xFFf2f1ff),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: const Text("Before food"  ,style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFoodStatus = 'After food';
                      });
                    },
                    child: Container(

                      decoration: BoxDecoration(
                        color: selectedFoodStatus == 'After food' ? const Color(0xFFb2c3fe) : const Color(0xFFf2f1ff),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      child: const Text("After food" , style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    _isLoading = true; // Set loading state to true
                  });

                  print(selectedFoodStatus);

                  // Perform the asynchronous operation
                  await listFormer().addMedicine(
                    medicineName: _medicineNameController.text,
                    medicineType: type,
                    medicineQuantity: quantityCount,
                    medicineStartDate: startDate.toString(),
                    medicineEndDate: endDate.toString(),
                    medicineFrequency: frequencyOfDays,
                    medicineTimesDay: int.parse(_timesPerDayController.text),
                    medicineFoodStatus: selectedFoodStatus,
                  );

                  await getListData();

                  Navigator.pop(context, true);

                  setState(() {
                    _isLoading = false;
                  });
                  _showNotification();
                },

                child: Container(
                  height: 50,
                  child: (_isLoading)?const SizedBox(
                    height: 20 ,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white,)):const Text(
                    "Add",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(26)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorCircle({required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
