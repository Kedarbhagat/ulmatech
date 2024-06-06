import 'dart:async';
import 'dart:math';

import 'package:carousel_calendar/carousel_calendar.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ulmatech/screens/signinScreen.dart';
import '../resources/FirebaseCRUD.dart';
import '../resources/auth.dart';
import 'addMedecine.dart';
// Define a list of predefined colors
List<Color> _randomColors = [
  const Color(0xFFf8cff1),
  const Color(0xFFC2B6FF),
  const Color(0xFFFE9695),
  const Color(0xFFCEFCBE),
  const Color(0xFFFAC291),
  const Color(0xFFBAE6FF),
  const Color(0xFFFFFDC3),
];

// Function to generate a random color from the list
Color _getRandomColor() {
  Random random = Random();
  return _randomColors[random.nextInt(_randomColors.length)];
}
Future<List<Map<String, String>>> getListData() async {
  List<Map<String, String>> fetchedMedicines = await Crud().getUserMedicines(credUID);
  return fetchedMedicines;
}

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

var date = 0;

class _homeScreenState extends State<homeScreen> {
  late Future<List<Map<String, String>>> userMedicinesFuture;


  late StreamSubscription<InternetConnectionStatus> connectionSubscription;

  @override
  void initState() {
    super.initState();
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
    userMedicinesFuture = getListData();
  }
  void refreshMedicines() {
    setState(() {
      userMedicinesFuture = getListData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Hello!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.medical_services_sharp, color: Color(0xFF6F8BEF)),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () async {
                    await AuthMethod().logOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const SigninScreen()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage('https://th.bing.com/th?id=OIP.hNXsq5wSiRZECbJ6XPl75AHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2')
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 210, 0),
              child: Text("5 Medicines Left"),
            ),
            Container(
              height: 168,
              child: CalendarCarousel(
                monthSelectorMargin: const EdgeInsets.only(bottom: 2.0),
                weekdayMargin: const EdgeInsets.symmetric(vertical: 12.0),
                weekdayAbb: WeekdayAbbreviation.two,
                unselectedColor: Colors.grey.shade100,
                unselectedTextColor: Colors.black,
                selectedColor: const Color(0xFF6f8bef),
                dayCarouselHeight: 110,
                showYearAlways: true,
                onChanged: (nm) {
                  setState(() {
                    date = nm as int;
                  });
                },
              ),
            ),
            FutureBuilder<List<Map<String, String>>>(
              future: userMedicinesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  Center(child: Container(
                    height: 400,
                      child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    height: 400,
                      child: Image.asset('assets/nothing.png'));
                } else {
                  return Container(
                    height: 400,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final medicine = snapshot.data![index];
                        Color randomColor = _getRandomColor(); // Generate a random color
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: randomColor,
                              borderRadius: BorderRadius.circular(10.0), // Set rounded corners
                            ),
                            child: ListTile(
                              title: Text(
                                '${medicine['medicineName']}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0), // Set rounded corners
                                    child: Image.asset(
                                      'assets/${medicine['medicineType']}',
                                      scale: 2.6,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Text('Type: ${medicine['medicineType']}'),
                                      Text('Quantity: ${medicine['medicineQuantity']}'),
                                      Text('Frequency: ${medicine['medicineFrequency']}'),
                                      Text('Times Per Day: ${medicine['medicineTimesDay']}'),
                                      Text('Food Status: ${medicine['medicineFoodStatus']}'),
                                    ],
                                  ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(Icons.notifications_none_outlined , color: Colors.green,)
                                ],
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
            const SizedBox(
              height: 3,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Divider(height: 8, color: Color(0xFF6f8bef))),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddMedecine()),
                          );
                          if (result == true) {
                            refreshMedicines();
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 40.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6f8bef),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                      const Expanded(child: Divider(height: 10, color: Color(0xFF6f8bef))),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.home, size: 40, color: Color(0xFF6f8bef)),
                      SizedBox(width: 30),
                      Icon(Icons.stacked_bar_chart, size: 40, color: Color(0xFF6f8bef)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
