//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_app/Model/usefulData.dart';
import 'package:login_screen_app/pages/home_page.dart';
import 'package:login_screen_app/pages/signin_page.dart';
import 'package:login_screen_app/services/auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus { NOT_DETERMINED, LOGGED_IN, LOGGED_OUT }

class RootPage extends StatefulWidget {
  final Auth auth;

  RootPage(this.auth);
  @override
  _RootPage createState() {
    return _RootPage();
  }
}
//typedef loginCallback LoginCallback(String str);

class _RootPage extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;
  @override
  void initState() {
    super.initState();
    _authStatus = AuthStatus.NOT_DETERMINED;
    // print('inside rootpage init method');
    widget.auth.getCurrentUser().then((firebaseUser) {
      if (firebaseUser != null) {
        userId = firebaseUser.uid;
        setState(() {
          _authStatus = AuthStatus.LOGGED_IN;
        });
      } else {
        setState(() {
          _authStatus = AuthStatus.LOGGED_OUT;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return waitingScreen();
        break;
      case AuthStatus.LOGGED_IN:
        return HomePage(logoutCallback);
        break;
      case AuthStatus.LOGGED_OUT:
        return SignInPage(widget.auth, loginCallback, logoutCallback);
        break;
      default:
        return waitingScreen();
    }
  }

  Widget waitingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting Screen'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text('wait for sometime'),
      ),
    );
  }

  void loginCallback() async {
    print('inside logincallback');
    //_currentProfile=currentProfile;
    if (userId == null) await widget.auth.getCurrentUser();
    print('inside logincallback' + userId.toString());
    setState(() {
      print('inside login setting state');
      // userId = firebaseUser.uid.toString();
      _authStatus = AuthStatus.LOGGED_IN;
    });

    //  setState(() {});
  }

  void logoutCallback() async {
    // print(widget.auth.getCurrentUser());
    await widget.auth.signOut();
    clearUsefulData();
    setState(() {
      _authStatus = AuthStatus.LOGGED_OUT;
    });
  }

  void clearUsefulData() {
    userId = null;
    firebaseUser = null;
    documentReference = null;
    currentProfile = false;
    documentReference = null;
    pincodesReference = null;
    documentSnapshot = null;
    userData = {};
    cartProducts = List();
    listMap = List();
    listOfDocuments = List();
    querySnapshot = null;
    firstInstance = false;
    mapOfImages = {};
    indexes = List();
    listMapq = List();
    listOfDocumentsq = List();
    querySnapshotq = null;
    firstInstanceq = false;
    mapOfImagesq = {};
    indexesq = List();
    prevShopId = null;
    cartUId = null;
    currentDocId = null;
    qsCart = null;
    cartProdData = List();
    cartImages = {};
    cartItemIndexes = List();
    qty = List();
    cartDocs = List();
  }
}
