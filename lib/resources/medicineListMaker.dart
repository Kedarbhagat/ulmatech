import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'FirebaseCRUD.dart';
String credentials = FirebaseAuth.instance.currentUser!.uid;
class listFormer {

  late final String medicineName;

  late final String medicineType;

  late final int medicineQuantity;

  late final String medicineStartDate;

  late final String medicineEndDate;

  late final String medicineFrequency;

  late final int medicineTimesDay;

  late final String medicineFoodStatus;


  Map<String ,String> mapMaker({required medicineName , required medicineType, required medicineQuantity , required medicineStartDate ,
  required medicineEndDate ,required medicineFrequency , required medicineTimesDay , required medicineFoodStatus
  }){
 Map<String,String>  medicineMap =
     {
      'medicineName':medicineName ,
       'medicineType':medicineType,
       'medicineQuantity':medicineQuantity.toString(),
       'medicineStartDate':medicineStartDate,
       'medicineEndDate':medicineEndDate ,
       'medicineFrequency':medicineFrequency ,
       'medicineTimesDay':medicineTimesDay.toString(),
       'medicineFoodStatus':medicineFoodStatus


    } ;

 return medicineMap ;


  }
  List<Map<String, String>> addMedicine({ required String medicineName, required String medicineType,required int medicineQuantity,
    required  String medicineStartDate,required String medicineEndDate, required String medicineFrequency,
    required int medicineTimesDay, required String medicineFoodStatus}) {
    List<Map<String, String>> currentList = []; // Assuming you have an existing list
    currentList.add(mapMaker(
      medicineName: medicineName,
      medicineType: medicineType,
      medicineQuantity: medicineQuantity,
      medicineStartDate: medicineStartDate,
      medicineEndDate: medicineEndDate,
      medicineFrequency: medicineFrequency,
      medicineTimesDay: medicineTimesDay,
      medicineFoodStatus: medicineFoodStatus,
    ));
    // You can further update the UI or perform other actions here
    Crud().addUserWithMedicines(credentials, currentList) ;
    return currentList ;
  }

}