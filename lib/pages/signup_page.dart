import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:login_screen_app/Model/usefulData.dart';
import 'package:login_screen_app/services/auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final Auth auth;
  final VoidCallback loginCallback;
  SignUpPage(this.auth, this.loginCallback);

  @override
  _SignUpPage createState() {
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  final registerScaffold = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String _email, _pwd, profile = 'Buyer', userName = '';
  // FirebaseUser user;
  bool isChecked = false;
  UserUpdateInfo userUpdateInfo = new UserUpdateInfo();

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
  }

  void showBar(String str) {
    SnackBar snackbar = new SnackBar(
      content: new Text(str),
    );
    registerScaffold.currentState.showSnackBar(snackbar);
  }

  void verifyEmail() async {
    if (widget.auth.ismailVerified()) {
      widget.loginCallback();
      Navigator.pop(context);
    } else {
      widget.auth.sendVerificationEmail().then((_) async {
        showBar('verify ur email');
        print('verify ur email to continue');
        await createUserProfile();
      }).catchError((onError) {
        showBar('unable to send email');
        print('unable to send email');
      });
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (isChecked)
      profile = 'Seller';
    else
      profile = 'Buyer';

    if (form.validate() == true) {
      form.save();

      userUpdateInfo.displayName = userName;
      print('username is' + userName);
      return true;
    }
    return false;
  }

  void validateAndSignUp() async {
    if (validateAndSave()) {
      try {
        await widget.auth.signUpWithEmailAndPassword(
          _email,
          _pwd,
        );
        if (firebaseUser == null) {
          userId = '';
          print('account not created for user');
          showBar('Sorry!! Please try again');
        } else {
          //  print(userUpdateInfo.displayName);
          try {
            firebaseUser.updateProfile(userUpdateInfo);
            print(firebaseUser.displayName);
            print('profile created');
            firebaseUser.reload();
            verifyEmail();
          } on PlatformException catch (e) {
            if (e.code == 'ERROR_USER_DISABLED') showBar('USER DISABLED!!');
            if (e.code == 'ERROR_USER_NOT_FOUND') showBar('USER NOT FOUND!!');
          }
        }
      } on PlatformException catch (e) {
        if (e.code == 'ERROR_WRONG_PASSWORD') showBar('WRONG_PASSWORD');
        if (e.code == 'ERROR_MAIL_ALREADY_IN_USE')
          showBar('mail already in use');
        if (e.code == 'ERROR_INVALID_EMAIL') showBar('INVALID EMAIL');
      }

      // });
    }
  }

  Widget showCreateAccountButton() {
    return new Container(
      margin: EdgeInsets.only(top: 10),
      child: new MaterialButton(
        onPressed: validateAndSignUp,
        child: new Text(
          'Create an Account',
        ),
        color: Colors.blueAccent,
        splashColor: Colors.greenAccent,
      ),
    );
  }

  Widget showPasswordField() {
    return new TextFormField(
      validator: (_val) => _val.length < 8 ? 'password is too short' : null,
      onSaved: (_val) => _pwd = _val.trim(),
      decoration: new InputDecoration(labelText: "Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
    );
  }

  Widget showEmailField() {
    return new TextFormField(
      validator: (_val) => _val.contains('@') ? null : 'invalid email',
      onSaved: (_val) => _email = _val.trim(),
      decoration: new InputDecoration(labelText: "Enter Email"),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget showUserNameField() {
    return new TextFormField(
      validator: (_val) => _val.isEmpty ? 'enter your name' : null,
      onSaved: (_val) => userName = _val,
      decoration: new InputDecoration(labelText: "Enter your full name"),
      keyboardType: TextInputType.text,
    );
  }

  Widget showLogo() {
    return new FlutterLogo(
      size: _iconAnimation.value * 100,
    );
  }

  Widget showForm() {
    return new Form(
      key: formKey,
      child: new Container(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              showUserNameField(),
              showEmailField(),
              showPasswordField(),
              showCreateAccountButton(),
              Row(
                children: <Widget>[
                  Checkbox(
                    onChanged: (value) {
                      setState(() {
                        isChecked = value;
                        profile = isChecked == true ? 'Seller' : 'Buyer';
                      });
                    },
                    value: isChecked,
                    checkColor: Colors.blue,
                  ),
                  Text(
                    'Register as Seller',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: registerScaffold,
      backgroundColor: Colors.black38,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/tower.jpg"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              showLogo(),
              showForm(),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> createUserProfile() async {
    //user.reload();
    Map<String, dynamic> data = {
      'userId': '${firebaseUser.uid}',
      'userName': userName,
      'emailId': '${firebaseUser.email}',
      'photoUrl': '${firebaseUser.photoUrl}',
      'phoneNumber': '${firebaseUser.phoneNumber}',
      'category': '',
      'businessName': '',
      'address': '',
      'pincode': '',
      'keywords': '',
    };
    Map<String, dynamic> other = {
      'profile': profile,
      //'last_name': lastName,
    };
    data.addAll(other);

    documentReference =
        Firestore.instance.collection('users').document('$userId');
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists == true) {
        print('doc exists');
        showBar('Already a registered user');
      } else {
        try {
          return documentReference.setData(data).then((_) {
            print('profile created inside firestore');
            showBar('successfully registered ');
          });
        } catch (e) {
          print('unable to prepare userdocument');
          showBar('Please try again later');
          // throw e;
          return;
        }
      }
    } catch (e) {
      print(e.toString());
      showBar('poor network');
      //throw e;
      return;
    }
  }
}
