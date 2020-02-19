import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_screen_app/Model/usefulData.dart';

abstract class BaseAuth {
  Future<String> signInWithGoogle();
  Future<String> signInWithEmailAndPassword(String email, String pwd);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
  Future<void> sendVerificationEmail();
  bool ismailVerified();
  Future<FirebaseUser> signUpWithEmailAndPassword(String email, String pwd);
  Future<void> sendPasswordResetEmail(String email);
}

class Auth implements BaseAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // FirebaseUser _firebaseUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signInWithEmailAndPassword(String email, String pwd) async {
    // _firebaseAuth
    //     .signInWithEmailAndPassword(email: email, password: pwd)
    //     .catchError((e) {
    //   // showBar(e.message);
    // }).then((authResult) {
    //   firebaseUser = authResult.user;
    //   return userId = firebaseUser.uid;
    // }).catchError((err) {
    //   print(
    //       'google server busy to validate credentials or poor internet connection');
    // });
    // return null;

    try {
      AuthResult authCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: pwd);
      firebaseUser = authCredential.user;
      return userId = firebaseUser.uid;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  @override
  Future<String> signInWithGoogle() async {
    print('inside auth');
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        throw Exception;
      }
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      firebaseUser = authResult.user;
      userId = firebaseUser.uid;

      return firebaseUser.uid;
    } catch (e) {
      print(e.toString());
      throw e;
      //throw e;
    }
    // print('inside auth');
    // AuthCredential authCredential;

    // print('1');
    // _googleSignIn.disconnect();
    // print('k');
    // Future<GoogleSignInAccount> googleSignInAccount = _googleSignIn.signIn();
    // googleSignInAccount.then((googleSignInAccount) {
    //   print('2');
    //   Future<GoogleSignInAuthentication> googleSignInAuthentication =
    //       googleSignInAccount.authentication;
    //   print('k2');
    //   googleSignInAuthentication.then((googleSignInAuthentication) {
    //     print('3');
    //     authCredential = GoogleAuthProvider.getCredential(
    //         accessToken: googleSignInAuthentication.accessToken,
    //         idToken: googleSignInAuthentication.idToken);
    //   })
    //   .catchError((err) {
    //     print('unable to authenticate user please check ur internet');
    //     throw err;
    //   })
    //   .then((_) {
    //     print('4');
    //     //After fetching authcredential and trying to signin with them
    //     _firebaseAuth.signInWithCredential(authCredential).then((authResult) {
    //       print('5');
    //       firebaseUser = authResult.user;
    //       userId = firebaseUser.uid;
    //       return userId;
    //     }).catchError((err) {
    //       print(
    //           'google server busy to validate credentials or poor internet connection');
    //     });
    //   });
    // }).catchError((err) {
    //   print('unable to initiate google signin');
    //   throw err;
    // }).whenComplete(() {
    //   return userId;
    // });
  }

  @override
  Future<void> signOut() async {
    // _firebaseAuth.signOut().then((_) {
    //   print('signout the firebase account success');
    //   _googleSignIn.signOut().then((googleSignInAccount) {
    //     print('signout the google account success');
    //     return;

    //   }).catchError((err) {
    //     print('unable to signout the google account');
    //     throw err;
    //   });
    // }).catchError((err) {
    //   print('unable to signout the firebase account');
    //   throw err;
    // });
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    firebaseUser = await _firebaseAuth.currentUser();
    return firebaseUser.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    } //return firebaseUser.sendEmailVerification();
  }

  @override
  bool ismailVerified() {
    // firebaseUser = await _firebaseAuth.currentUser();
    //if(_firebaseUser!=null)
    return firebaseUser.isEmailVerified;
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    firebaseUser = await _firebaseAuth.currentUser();
    return firebaseUser;
  }

  @override
  Future<FirebaseUser> signUpWithEmailAndPassword(
      String email, String pwd) async {
    //   _firebaseAuth
    //       .createUserWithEmailAndPassword(email: email, password: pwd)
    //       .then((authResult) {
    //     return firebaseUser = authResult.user;
    //   }).catchError((e) {
    //     // showBar(e.message);
    //     print(
    //         'google server busy to validate credentials or poor internet connection');
    //     throw e;
    //   });
    //   //return null;
    // }

    firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: pwd)
            .catchError((e) {
      // showBar(e.message);
      throw e;
    }))
        .user;
    userId = firebaseUser.uid;
    return firebaseUser;
  }
}
