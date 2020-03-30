import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:login_screen_app/Model/usefulData.dart';

class AddProduct extends StatefulWidget {
  //final String userId;
  AddProduct();
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var formKey = GlobalKey<FormState>();
  double width = 300;
  String url;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController urlController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  Future<DocumentReference> documentReference;
  String title, description, category, price, quantity;
  File _image;
  String extension, barResult;


  // TextEditingController addressController = TextEditingController();
  // TextEditingController pincodeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // width = MediaQuery.of(context).size.width;
    //print(userData);
    urlController.text = '';
    titleController.text = '';
    categoryController.text = '';
    descriptionController.text = '';
    priceController.text = '';
    quantityController.text = '1';
    url = null;
   
    //barResult='hello this is a normal message';
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     //  urlController.text
    //     //   url =
    //     //       //'data:image/png;base64,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';
    //     //       'https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwjOh8Hhs7rmAhU463MBHQWYAfkQjRx6BAgBEAQ&url=https://design.google/library/evolving-google-identity/&psig=AOvVaw0smnnxVwPKwru9byQRMVw8&ust=1576593808699009';
    //     //
    //     //   url =
    //     //     'https://images.pexels.com/photos/2519818/pexels-photo-2519818.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';
    //   });
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // width = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    urlController.dispose();
    titleController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //context.extension();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('New Product'),
      ),
      body:  SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Form(
                  key: formKey,
                  //autovalidate: true,
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 2,
                        child: GestureDetector(
                          onTap: getImage,
                          child: Container(
                            height: (MediaQuery.of(context).size.height -
                                    kToolbarHeight -
                                    kBottomNavigationBarHeight) *
                                0.4,
                            width: (MediaQuery.of(context).size.width),
                            child: FittedBox(
                              child: _image == null
                                  ? Icon(
                                      Icons.add_a_photo,
                                    )
                                  : Image.file(_image),
                              fit: BoxFit.fill,
                              //NetworkImage(url, scale: 1),
                              // fit: BoxFit.fill,
                              // )
                              // decoration: BoxDecoration(
                              //   // shape: BoxShape.rectangle,
                              //   image: DecorationImage(
                              //     image: ,
                              //     fit: BoxFit.fill,
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      ),
                      // TextField(
                      //   decoration: InputDecoration(hintText: 'Url of image'),
                      //   controller: urlController,
                      //   keyboardType: TextInputType.text,
                      //   onSubmitted: (val) {
                      //     setState(() {
                      //       url = val == null
                      //           ? 'https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwjOh8Hhs7rmAhU463MBHQWYAfkQjRx6BAgBEAQ&url=https%3A%2F%2Fdesign.google%2Flibrary%2Fevolving-google-identity%2F&psig=AOvVaw0smnnxVwPKwru9byQRMVw8&ust=1576593808699009'
                      //           : val;
                      //     });
                      //     urlController.text = '';
                      //   },
                      // ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Category Name'),
                        validator: (val) =>
                            val.isEmpty ? 'cannot be empty' : null,
                        onSaved: (val) => category = val,
                        keyboardType: TextInputType.text,
                        // initialValue: widget.data['pincode'],
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Product Title'),
                        validator: (val) =>
                            val.isEmpty ? 'cannot be empty' : null,
                        onSaved: (val) => title = val,
                        keyboardType: TextInputType.text,
                        // initialValue: widget.data['pincode'],
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        onSaved: (val) => price = val,
                        validator: (val) =>
                            val.isEmpty ? 'cannot be empty' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Quantity'),
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        onSaved: (val) => quantity = val,
                        validator: (val) =>
                            val.isEmpty ? 'cannot be empty' : null,
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Product Description'),
                          onSaved: (val) => description = val,
                          keyboardType: TextInputType.multiline,
                          validator: (val) =>
                              val.isEmpty ? 'cannot be empty' : null,
                          //  minLines: 1,
                          maxLines: null,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.green,
                          ),
                          RaisedButton(
                            child: Text('Add'),
                            // disabledColor: Colors.grey,
                            color: Colors.green ,
                            //color: Colors.grey,
                            onPressed: () async {
                                    // setState(() {
                                    //   enable = true;
                                    // });
                                   
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Scaffold(
                                          appBar: AppBar(),
                                          body: Center(
                                              child:
                                                  CircularProgressIndicator()));
                                    }));
                                    await addProduct();
                                    // setState(() {
                                    //   enable = false;
                                    // });
                                    Navigator.of(context).pop();
                                    await showDiagolueBox(barResult);

                                    Navigator.of(context).pop(true);
                                  }
                               
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> showDiagolueBox(String res) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: 200.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                res,
                style: TextStyle(color: Colors.green),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.all(15.0),
            //   child: Text(
            //     'Awesome',
            //     style: TextStyle(color: Colors.red),
            //   ),
            // ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Got It!',
                  style: TextStyle(color: Colors.red, fontSize: 18.0),
                ))
          ],
        ),
      ),
    );
    return showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  void getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //print(image.);
    List l =
        image.uri.pathSegments[image.uri.pathSegments.length - 1].split('.');
    // print(l[1]);
    extension = l[1];
    setState(() {
      _image = image;
    });
  }

  Future<void> uploadImage() async {
    final String fileName =
        Timestamp.now().toDate().toIso8601String() + '.' + '$extension';
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('$userId').child(fileName);
    final StorageUploadTask uploadTask = storageRef.putFile(
      _image,
      // StorageMetadata(
      //   contentType: 'image/jpg',
      // ),
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    try {
      url = await downloadUrl.ref.getDownloadURL();
     // print('URL Is $url');
      return;
    } catch (e) {
      throw e;
    }
  }

  Future<void> showBar(String str) {
    SnackBar snackbar = new SnackBar(
      content: new Text(str),
      duration: Duration(seconds: 2),
    );
    return scaffoldKey.currentState.showSnackBar(snackbar).closed;
  }

  Future<void> addProduct() async {
    Map<String, dynamic> other;
    if (!formKey.currentState.validate()) {
      print('incorrect or fields are empty');
      //showBar('invalid fields');
      barResult = 'invalid fields';
      return;
    }
    formKey.currentState.save();
   
    try {
      await uploadImage();
      print('pic uploading');
    } catch (e) {
      print(e);
      //  showBar('pic upload network error');
      barResult = 'pic upload network error';
      return;
    }

    String docId;
//getting data from a category
    try {
      docId = Firestore.instance
          .collection('users')
          .document('$userId')
          .collection('products')
          .document()
          .documentID;

      // if (!documentSnapshot.exists) {
      //   other = Map.from(data);
      // } else {
      //   other = documentSnapshot.data;
      //   other.addAll(data);
      // }
      // print('299 ' + other.toString());
    } catch (e) {
      print('got error while creating document');
      //showBar('unable to add');
      barResult = 'unable to add';
      return;
    }
    Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'price': price,
      'quantity': quantity,
      'images': url,
      'category': category,
      'id': docId,
      'shopId': userId
      
    };

    // Firestore.instance
    //     .collection('users')
    //     .document('$userId')
    //     .collection('products')
    //     .document('$category'.toLowerCase())
    //     .get()
    //     .then((ds) {
    //   if (ds.data == null) {
    //     other = Map.from(data);
    //   } else {
    //     other = ds.data;
    //     other.addAll(data);
    //   }
    //   print('286 ' + other.toString());
    // }).catchError((onError) {
    //   print(onError);
    //   showBar('network error to get data');
    //   return;
    // });
//writing data into category
    try {
      await Firestore.instance
          .collection('users')
          .document('$userId')
          .collection('products')
          .document(docId)
          .setData(data);
      print('added product');
    } catch (e) {
      print('product not added');
      // showBar('product not added');
      barResult = 'product not added';
      return;
    }
//getting list of categories and adding a new one
    try {
      //  other = userData;
      print(userData);
      //  List<dynamic> l = ['$category'.toLowerCase()];
      // for (var val in other['keywords']) {
      //   l.insert(0, val);
      // }

      other = userData;
      List<dynamic> l = List();
      l.addAll(other['keywords']);
      print('l or other data before addition ' + l.toString());
      List ll = ['$category'.toLowerCase()];
      print(ll);
      if (!l.contains('$category'.toLowerCase())) {
        l.addAll(ll);
        print('l data after adding is ' + l.toString());
      }

      // l.addAll(other['keywords']);
      //  l.add('$category'.toLowerCase());
      //  print('other  data after addition ' + l.toString());
      // List<dynamic> ll = ['$category'.toLowerCase()];
      // if (!l.contains('$category'.toLowerCase())) {
      //   l.addAll(ll);
      //   print('l data after adding is ' + l.toString());
      // }
      other['keywords'] = l;
    } catch (e) {
      print('error while merging a new category locally' + e.toString());
      // showBar('unable to add');
      barResult = 'unable to add';
      return;
    }
//updating category list
    try {
      await Firestore.instance
          .collection('users')
          .document('$userId')
          .updateData(other);

      print('successfully updated');
      userData = other;
      // showBar('added successfully');
      barResult = 'added successfully';
      return;
    } catch (e) {
      print('error while updating category ' + e.toString());
      //  showBar('unable to add');
      barResult = 'unable to add';
      return;
    }
  }
}
