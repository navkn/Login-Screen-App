//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_app/Model/usefulData.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //DocumentReference documentReference;
  final formKey1 = new GlobalKey<FormState>();
  final formKey2 = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String userName = '', phNumber = '', url = '';
  String category = '', businessName = '', address = '', pincode = '';
  bool ukey = true, emailkey = true, phkey = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phnumberController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  bool usr = false,
      mail = false,
      ph = false,
      cat = false,
      bus = false,
      addr = false,
      pin = false;
  String profile = userData['profile'];
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      usernameController.text = userData['userName'];
      phnumberController.text = userData['phoneNumber'];
      emailController.text = userData['emailId'];
      categoryController.text = userData['category'];
      businessNameController.text = userData['businessName'];
      addressController.text = userData['address'];
      pincodeController.text = userData['pincode'];
      setState(() {
        url = userData['photoUrl'] == null
            ? 'https://images.pexels.com/photos/3532552/pexels-photo-3532552.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
            //  ? 'https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwjOh8Hhs7rmAhU463MBHQWYAfkQjRx6BAgBEAQ&url=https%3A%2F%2Fdesign.google%2Flibrary%2Fevolving-google-identity%2F&psig=AOvVaw0smnnxVwPKwru9byQRMVw8&ust=1576593808699009'
            : userData['photoUrl'];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    phnumberController.dispose();
    categoryController.dispose();
    emailController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    businessNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        //  WillPopScope(
        //   onWillPop: (){
        //     Navigator.of(context).pop(widget.data);
        //     return Future.value(false);
        //   },
        //   child:
        Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Profile'),
        //  automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              showForm(),
              showDynamicWidget(),
              showUpdateButton(),
            ],
          ),
        ),
      ),
      // ),
    );
  }

  Widget showForm() {
    return Form(
      key: formKey1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            new Container(
              width: 100.0,
              height: 100.0,
              child: url == null
                  ? Icon(Icons.verified_user)
                  : Container(width: 0, height: 0),
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: url != null
                      ? new NetworkImage(url)
                      : Container(width: 0, height: 0),
                ),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
              keyboardType: TextInputType.text,
              onSaved: (_name) => userName = _name,
              controller: usernameController,
              validator: (val) =>
                  val.length == 0 ? 'Please provide valid user name' : null,
              onChanged: (_) {
                usr = true;
              },
            ),
            // SizedBox(
            //   height: 20,
            // ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: emailController,
              enabled: false,
              validator: null,
              onChanged: (_) {
                mail = true;
              },
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     Container(
            //       width: 200,
            //       child:
            TextFormField(
              decoration: InputDecoration(labelText: 'PhoneNumber'),
              controller: phnumberController,
              validator: (val) {
                //correct validation is required
                return val.length != 10
                    ? 'Please provide valid phone number'
                    : null;
              },
              keyboardType: TextInputType.number,
              onSaved: (val) {
                phNumber = val;
              },
              onChanged: (_) {
                ph = true;
              },
            ),
            // ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   height: 35,
            //   child: RaisedButton(
            //     child: Text('verify'),
            //     onPressed: verifyMobileNumber,
            //   ),
            // ),
            //   ],
            // ),
            // SizedBox(
            //   height: 20,
            // ),
          ],
        ),
      ),
    );
  }

  Widget showUpdateButton() {
    return RaisedButton(
      child: Text('Update'),
      onPressed: () {
        if (usr || mail || ph || cat || bus || addr || pin)
          updateContent();
        else {
          showBar('nothing to update');
        }
      },
      color: Colors.lightGreen,
    );
  }

  void updateContent() async {
    final form1 = formKey1.currentState;
    final form2 = formKey2.currentState;
   // print(form2.toString() + ' form2');
    if (form1.validate() == false) return;

    if (form2 != null && form2.validate()) form2.save();
    form1.save();

    //print('updating');
    Map<String, dynamic> upd = {
      'phoneNumber': phNumber,
      'userName': userName,
      'category': category,
      'businessName': businessName,
      'address': address,
      'pincode': pincode,
      'userId': userId,
      'profile': profile
    };
    //print('doc ref is ' + documentReference.toString());

    // Firestore.instance.runTransaction((t) {
    //    t.update(documentReference, upd).then((_) {
    //     print("updated successfully");
    //   });
    // return  t.get(pincodesReference).then((v){
    //     var data=v.data;
    //     if(data.isEmpty){
    //      var data = {
    //         '$category': {
    //           '$userId': {'shop-name': '$businessName', 'images': []}
    //         }
    //       };
    //       t.set(documentReference, data);
    //     }
    //     else{
    //       if (data.containsKey('$category')) {
    //       if (data['$category'].containsKey('$userId')) {
    //         //print(data['super market']['3qnaFkY1TUisEalpKLxIaBMFil1']);
    //         data['$category']
    //             ['$userId'] = {'shop-name': '$businessName', 'images': []};

    //         print(data);
    //       } else {
    //         Map<dynamic, dynamic> other = data['$category'];
    //         other.putIfAbsent('$userId', () {
    //           return {'shop-name': '$businessName', 'images': []};
    //         });
    //         data['$category'] = other;
    //         print(other);
    //         print(data['$category']);
    //         print(data);
    //         // print(data['super market']);
    //         // print(data['super market']['3qnaFkY1TUisEalpKLxIaBMFil1']);
    //         // print(other);
    //       }
    //     } else {
    //       data.putIfAbsent('$category', () {
    //         return {
    //           '$userId': {'shop-name': '$businessName', 'images': []}
    //         };
    //       });
    //       print(data);
    //     }
    //      t.update(pincodesReference,data);
    //     showBar('business updated successfully');
    //     }

    //   });

    // });

    //
    try {
      await documentReference.updateData(upd);
      upd.forEach((key, value) {
        userData[key] = value;
      });
      print('updated successfully');
      //showBar('updated successfully');
      // return;
    } catch (e) {
      print(e);

      //print('doc ref is ' + documentReference.toString());
      showBar('update failed');
      //return;
      // throw e;
    }
    try {
      Map<String, dynamic> data = {};
      pincodesReference =
          Firestore.instance.collection('pincodes').document('$pincode');
     // print(pincodesReference);
      pincodesReference.get().then((ds) async {
        data = ds.data;
        //print(data);
        if (data.isEmpty) {
          data = {
            '$category': {
              '$userId': {'shop-name': '$businessName', 'images': []}
            }
          };
          //print(data);
          await pincodesReference.setData(data);
          showBar('business updated successfully');
        } else if (data.containsKey('$category')) {
          if (data['$category'].containsKey('$userId')) {
            //print(data['super market']['3qnaFkY1TUisEalpKLxIaBMFil1']);
            data['$category']
                ['$userId'] = {'shop-name': '$businessName', 'images': []};

            //print(data);
          } else {
            Map<dynamic, dynamic> other = data['$category'];
            other.putIfAbsent('$userId', () {
              return {'shop-name': '$businessName', 'images': []};
            });
            data['$category'] = other;
            //print(other);
            //print(data['$category']);
            //print(data);
            // print(data['super market']);
            // print(data['super market']['3qnaFkY1TUisEalpKLxIaBMFil1']);
            // print(other);
          }
        } else {
          data.putIfAbsent('$category', () {
            return {
              '$userId': {'shop-name': '$businessName', 'images': []}
            };
          });
          //print(data);
        }
        await pincodesReference.updateData(data);
        showBar('business updated successfully');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget showBussinessProfileForm() {
    return Form(
      key: formKey2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                'Business Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Category'),
              readOnly: userData['category'] != "" ? true : false,
              validator: (val) => val == null ? 'cannot be empty' : null,
              onSaved: (val) => category = val,
              initialValue: userData['category'],
              onChanged: (_) {
                cat = true;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Business Name'),
              validator: (val) => val == null ? 'cannot be empty' : null,
              readOnly: userData['businessName'] != "" ? true : false,
              onSaved: (val) => businessName = val,
              initialValue: userData['businessName'],
              onChanged: (_) {
                bus = true;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Address'),
              validator: (val) => val == null ? 'cannot be empty' : null,
              onSaved: (val) => address = val,
              readOnly: userData['address'] != "" ? true : false,
              initialValue: userData['address'],
              onChanged: (_) {
                addr = true;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'PinCode'),
              validator: (val) => val == null ? 'cannot be empty' : null,
              onSaved: (val) => pincode = val,
              keyboardType: TextInputType.phone,
              readOnly: userData['pincode'] != "" ? true : false,
              initialValue: userData['pincode'],
              onChanged: (_) {
                pin = true;
              },
            ),
          ],
        ),
      ),
    );
  }

  void showBar(String str) {
    SnackBar snackbar = new SnackBar(
      content: new Text(str),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget showAddBusinessProfileButton() {
    return RaisedButton(
      child: Text('Add Business Profile'),
      onPressed: () {
        setState(() {
          profile = 'Seller';
          // currentProfile = true;
        });
      },
      color: Colors.lightGreen,
    );
  }

  Widget showDynamicWidget() {
    //print('prof ' + currentProfile.toString());
    //print(profile);
    if (currentProfile == false && profile == 'Buyer')
      return SizedBox(
        height: 0,
      );
    if (currentProfile == false && profile == 'Seller')
      return SizedBox(
        height: 0,
      );
    if (currentProfile == true && profile == 'Buyer')
      return showAddBusinessProfileButton();
    if (currentProfile == true && profile == 'Seller')
      return showBussinessProfileForm();
    return SizedBox(
      height: 0,
    );
  }
}
