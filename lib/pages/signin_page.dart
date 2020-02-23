import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_screen_app/Model/usefulData.dart';
import 'package:login_screen_app/pages/signup_page.dart';
import 'package:login_screen_app/services/auth.dart';

class SignInPage extends StatefulWidget {
  final Auth auth;
  final VoidCallback loginCallback, logoutCallback;
  SignInPage(this.auth, this.loginCallback, this.logoutCallback);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  String _email, _pwd;
  //String userId = '';
  final formKey1 = new GlobalKey<FormState>();
  final formKey2 = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final emailKey = new GlobalKey();
//  FirebaseUser user;
  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(microseconds: 3000),
    );

    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.bounceInOut);

    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
    print('sig ' + currentProfile.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black38,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          showBackgroundImage(),
          showForegroundScreen(),
        ],
      ),
    );
  }

  Widget showBackgroundImage() {
    return new Image(
      image: new AssetImage("assets/tower.jpg"),
      fit: BoxFit.cover,
      color: Colors.black87,
      colorBlendMode: BlendMode.darken,
    );
  }

  Widget showForegroundScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 100),
      child: new Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        // verticalDirection:VerticalDirection.down

        children: <Widget>[
          showLogo(),
          showForm(),
        ],
      ),
    );
  }

  Widget showLogo() {
    return Container(
      // margin: EdgeInsets.only(top: 100),
      child: new FlutterLogo(
        size: _iconAnimation.value * 100,
      ),
    );
  }

  Widget showForm() {
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: new Theme(
        data: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
          accentColor: Colors.amber,
          inputDecorationTheme: new InputDecorationTheme(
            labelStyle: new TextStyle(
              color: Colors.teal,
              fontSize: 16.0,
            ),
          ),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            showEmailTextForm(),
            showPasswordTextForm(),
            showSellerCheckBox(),
            showSignInButton(),
            showSignInWithGoogleButton(),
            //  showSignOutButton(),
            //  Row(
            //  children: <Widget>[
            showUserSignUpFormButton(),
            showForgotPassword(),
            showResendEmailLink()
            //  ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget showEmailTextForm() {
    return Form(
      key: formKey1,
      child: new TextFormField(
        // key: emailKey,
        validator: (_val) => _val.contains('@') ? null : 'invalid email',
        onSaved: (_val) => _email = _val.trim(),
        decoration: new InputDecoration(labelText: "Email"),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget showPasswordTextForm() {
    return Form(
      key: formKey2,
      child: new TextFormField(
        validator: (_val) => _val.length < 8 ? 'password is too short' : null,
        onSaved: (_val) => _pwd = _val.trim(),
        decoration: new InputDecoration(labelText: "Password"),
        keyboardType: TextInputType.text,
        obscureText: true,
      ),
    );
  }

  Widget showSignInButton() {
    return new Container(
        margin: EdgeInsets.only(top: 10),
        child: new MaterialButton(
          onPressed: validateAndLogin,
          child: new Text(
            'Login',
          ),
          color: Colors.blueAccent,
          splashColor: Colors.greenAccent,
        ));
  }

  Widget showSignInWithGoogleButton() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.blueAccent,
      child: new MaterialButton(
        onPressed: validateAndSignInWithGoogle,
        child: new Text("Sign In with Google"),
        splashColor: Colors.greenAccent,
      ),
    );
  }

  Widget showUserSignUpFormButton() {
    return new Container(
      // margin: EdgeInsets.only(top: 10),
      child: new FlatButton(
        child: new Text('New User Registration',
            style: TextStyle(color: Colors.teal, fontSize: 14)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return SignUpPage(widget.auth, widget.loginCallback);
            }),
          );
        },
      ),
    );
  }

  Widget showSellerCheckBox() {
    return Row(
      children: <Widget>[
        Checkbox(
          onChanged: (value) {
            print(currentProfile.toString() + 'checkbox');
            setState(() {
              isChecked = value;
              currentProfile = value;
            });
          },
          value: isChecked,
          checkColor: Colors.blue,
        ),
        Text(
          'Login as Seller',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  // Widget showSignOutButton() {
  //   return new Container(
  //     margin: EdgeInsets.only(top: 10),
  //     color: Colors.blueAccent,
  //     child: new MaterialButton(
  //       onPressed: () {
  //         // widget.auth.signOut();
  //         widget.logoutCallback();
  //       },
  //       child: new Text("Sign Out"),
  //       splashColor: Colors.greenAccent,
  //     ),
  //   );
  // }

  void validateAndLogin() async {
    if (validateAndSave()) {
      //print(userId+' before login');
      try {
        await login();
        if (userId != null) {
          // print("userId is not null");
          try {
            await createUserProfile();
          } catch (e) {
            print('profile creation error');
            showBar('Sorry unable to login');
            return;
          }
          if (widget.auth.ismailVerified() == true) {
            print(' email verified');
            widget.loginCallback();
          } else {
            showBar('verify your email');
            print('verify your email');
          }
        } else {
          showBar('Please register to continue');
          print('userId   is null');
        }
      } catch (e) {
        print('error in signin validateandlogin()');
        return;
      }
      // print(userId+' after login');
    }
  }

  bool validateAndSave() {
    if (formKey1.currentState.validate() == true &&
        formKey2.currentState.validate() == true) {
      formKey1.currentState.save();
      formKey2.currentState.save();
      //  print('form is validated and saved');
      // showBar('valid');
      return true;
    } else {
      showBar('please validate the credentials');
      print('please validate');
    }
    return false;
  }

  Future<void> login() async {
    // if (validateAndSave() == false) return;
    print('inside signin login()');
    try {
      return await widget.auth.signInWithEmailAndPassword(_email, _pwd);
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'ERROR_WRONG_PASSWORD') showBar('WRONG_PASSWORD');
      if (e.code == 'ERROR_USER_NOT_FOUND') showBar('USER NOT FOUND');
      if (e.code == 'ERROR_INVALID_EMAIL') showBar('INVALID EMAIL');
      if (e.code == 'ERROR_TOO_MANY_REQUESTS')
        showBar('Accessing TOO MANy times');
      if (e.code == 'ERROR_USER_DISABLED') showBar('Account disabled');
      throw e;
    }
    //  catch (e) {
    //   print(e.toString());
    //    if (e.toString() == 'ERROR_WRONG_PASSWORD') showBar('WRONG_PASSWORD');
    //     if (e.toString() == 'ERROR_USER_NOT_FOUND')
    //       showBar('EMAIL_USER_NOT_FOUND');
    //     if (e.toString() == 'ERROR_INVALID_EMAIL') showBar('_INVALID_EMAIL');
    //  // showBar('poor net conn');
    //   throw e;
    // }
    // try {
    //   return await createUserProfile();
    // } catch (e) {
    //   print(e.toString());
    //   showBar(e.toString());
    //   return;
    // }

    // if (userId != null) {
    //  // print('4');
    //   widget.loginCallback();
    // } else {
    //   print('userId is null');
    // }
    // print('after receiving userid');
  }

  void validateAndSignInWithGoogle() async {
    print('inside login with google');
    try {
      await widget.auth.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_INVALID_ACTION_CODE')
        showBar('Please try again later');
      if (e.code == 'ERROR_OPERATION_NOT_ALLOWED')
        showBar('your google account has restricted to login');
      if (e.code == 'ERROR_INVALID_CREDENTIAL') showBar('INVALID credential');
      if (e.code == 'USER_DISABLED') showBar('USER_DISABLED');
      if (e.code == 'ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL')
        showBar('ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL');
      return;
    } catch (e) {
      return;
    }
    try {
      await createUserProfile();
    } catch (e) {
      print(e.toString());
      showBar(e.toString());
      return;
    }
    if (userId != null) {
      print('4');
      widget.loginCallback();
    } else {
      print('userId is null');
    }
  }

  void showBar(String str) {
    SnackBar snackbar = new SnackBar(
      content: new Text(str),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Future<void> createUserProfile() async {
    //user.reload();
    if (firebaseUser == null) {
      throw Exception;
    }
    print('creating user profile');
    Map<String, dynamic> data = {
      'userId': '${firebaseUser.uid}',
      'userName': '${firebaseUser.displayName}',
      'emailId': '${firebaseUser.email}',
      'photoUrl': '${firebaseUser.photoUrl}',
      'phoneNumber': '${firebaseUser.phoneNumber}',
      'category': '',
      'businessName': '',
      'address': '',
      'pincode': '',
      'keywords': '',
      'profile': isChecked == true ? 'Seller' : 'Buyer',
      // 'currentProfile': isChecked == true ? 'Seller' : 'Buyer',
    };
    documentReference =
        Firestore.instance.collection('users').document('$userId');
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await documentReference.get();
    } catch (e) {
      print(e.toString());
      //  showBar(e.toString());
      throw e;
    }

    if (documentSnapshot.exists == false) {
      print('doc doesnot exists');
      // try {
      //   await documentReference.updateData({
      //     'currentProfile': isChecked == true ? 'Seller' : 'Buyer',
      //   });
      //   print('profile updated success');
      //   return;
      // } catch (e) {
      //   print(e.toString());
      //   //  showBar(e.toString());
      //   throw e;
      // }
      try {
        await documentReference.setData(data);
        print('profile creation success');
        return;
      } catch (e) {
        print('unable to set profile data');
        //  showBar(e.toString());
        throw e;
      }
    }
  }

  Widget showForgotPassword() {
    return new Container(
      // margin: EdgeInsets.only(top: 10),
      child: new FlatButton(
        child: new Text('Forgot Password',
            style: TextStyle(color: Colors.teal, fontSize: 14)),
        onPressed: () async {
          //sendPasswordResetEmail()
          if (formKey1.currentState.validate()) {
            formKey1.currentState.save();
            try {
              await widget.auth.sendPasswordResetEmail(_email);
              //.then((_) {
              showBar('Password reset link has been sent to your email');
              // });
            } on PlatformException catch (e) {
              if (e.code == 'ERROR_INVALID_EMAIL') showBar('INVALID_EMAIL');
              if (e.code == 'ERROR_USER_NOT_FOUND') showBar('Account invalid');
            } catch (e) {
              print(e.toString());
            }
          } else {
            formKey1.currentState.validate();
          }
        },
      ),
    );
  }

  Widget showResendEmailLink() {
    return Container(
      // margin: EdgeInsets.only(top: 10),
      child: new FlatButton(
        child: new Text('Resend Email Verification',
            style: TextStyle(color: Colors.teal, fontSize: 14)),
        onPressed: () async {
          //sendPasswordResetEmail()
          if (formKey1.currentState.validate()) {
            formKey1.currentState.save();
            try {
              await widget.auth.sendVerificationEmail();
              //.then((_) {
              showBar('Password reset link has been sent to your email');
              // });
            } on PlatformException catch (e) {
              if (e.code == 'ERROR_INVALID_EMAIL') showBar('INVALID_EMAIL');
              if (e.code == 'ERROR_USER_NOT_FOUND') showBar('Account invalid');
            } catch (e) {
              print(e.toString());
            }
          } else {
            formKey1.currentState.validate();
          }
        },
      ),
    );
  }
}
