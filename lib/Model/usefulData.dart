import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
bool currentProfile = false;
FirebaseUser firebaseUser;
String userId;
DocumentReference documentReference;
DocumentReference  pincodesReference;
DocumentSnapshot documentSnapshot;
Map<String, dynamic> userData = {};
String searchCode='600119';
List<Map<dynamic, dynamic>> cartProducts = List();

List<Map<dynamic, dynamic>> listMap = List();
List<DocumentSnapshot> listOfDocuments = List();
Future<QuerySnapshot> querySnapshot;
bool firstInstance=false;
Map<int,Uint8List> mapOfImages={};
List<int> indexes=List();

List<Map<dynamic, dynamic>> listMapq = List();
List<DocumentSnapshot> listOfDocumentsq = List();
Future<QuerySnapshot> querySnapshotq;
bool firstInstanceq=false;
Map<int,Uint8List> mapOfImagesq={};
List<int> indexesq=List();
String prevShopId;
// DocumentSnapshot get getSnapshotData{
// return  documentReference.get();

// }