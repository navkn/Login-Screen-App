import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_app/Model/usefulData.dart';
import 'package:login_screen_app/pages/cart_page.dart';
import 'package:login_screen_app/pages/display_shop.dart';
import 'package:login_screen_app/pages/products_page.dart';
import 'package:login_screen_app/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback logoutCallback;
  HomePage(this.logoutCallback);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //String url = '';
  Map<String, dynamic> shops;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Future<DocumentSnapshot> dsnap;
  TextEditingController pincodeController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final formKey1 = new GlobalKey<FormState>();
  final formKey2 = new GlobalKey<FormState>();
  // double _height = 600;
  bool showShops = true;
  bool searchResult = false;
  String prodSearch;
  List<String> listOfIds = [];
  List<String> listOfnames = [];

  List<String> newListOfShops = [];
  void initState() {
    super.initState();
    fetchNearbyStores();
    //_height = MediaQuery.of(context).size.height - kToolbarHeight;
    // print('home ' + currentProfile.toString());
    pincodeController.text='600119';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('height:' +
          (MediaQuery.of(context).size.height - kToolbarHeight).toString());
      documentReference.get().then((DocumentSnapshot ds) {
        documentSnapshot = ds;
        ds.data.forEach((key, value) {
          if (key == 'userName') {
            //       url = data['photoUrl'] == null
            //     ? 'https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwjOh8Hhs7rmAhU463MBHQWYAfkQjRx6BAgBEAQ&url=https%3A%2F%2Fdesign.google%2Flibrary%2Fevolving-google-identity%2F&psig=AOvVaw0smnnxVwPKwru9byQRMVw8&ust=1576593808699009'
            //     : data['photoUrl'];
            setState(() {
              userData[key] = value;
            });
          } else
            userData[key] = value;
        });
        print('user data is' + userData.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomePage'),
        ),
        drawer: new Drawer(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new AppBar(
                title: Text(userData['userName'] == null
                    ? 'Try again'
                    : 'Mr.' + userData['userName']),
                // actions: <Widget>[
                //   new Container(
                //     width: 10.0,
                //     height: 10.0,
                //     decoration: new BoxDecoration(
                //       shape: BoxShape.circle,
                //       image: new DecorationImage(
                //         fit: BoxFit.fill,
                //         image: new NetworkImage(url),
                //       ),
                //     ),
                //   ),
                // ],
                automaticallyImplyLeading: false,
              ),
              // new ListTile(
              //   title:Text(data['userName'] == null
              //       ? 'Try again'
              //       : 'Welcome,Mr.' + data['userName']),
              // ),
              new ListTile(
                // contentPadding: EdgeInsets.all(2),
                title: new Text(
                  'Home',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  //print(widget.auth.getCurrentUser());
                },
              ),
              new Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              new ListTile(
                title: new Text('User Profile', style: TextStyle(fontSize: 14)),
                onTap: () {
                  moveToProfilePage();
                },
              ),
              new Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              currentProfile == true && userData['profile'] == 'Seller'
                  ? ListTile(
                      title: Text('Products', style: TextStyle(fontSize: 14)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          print(140);
                          return ProductsPage();
                        }));
                      },
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
              currentProfile == true && userData['profile'] == 'Seller'
                  ? new Divider(
                      color: Colors.grey,
                      thickness: 2,
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
              new ListTile(
                title: new Text('Cart', style: TextStyle(fontSize: 14)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    print(140);
                    return CartPage();
                  }));
                },
              ),
              new Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              new ListTile(
                title: new Text('SignOut', style: TextStyle(fontSize: 14)),
                onTap: () {
                  widget.logoutCallback();
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            // constraints: BoxConstraints(minHeight: 0,minWidth: 0,maxHeight: 600,maxWidth: 300),
            //height: 320,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Container(
                  height: (MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          kBottomNavigationBarHeight) *
                      0.10,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 12,
                        child: Form(
                          key: formKey1,
                          child: TextFormField(
                            maxLength: 10,
                            autovalidate: true,
                           // initialValue: '600119',
                            decoration: InputDecoration(labelText: 'PinCode'),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              //correct validation is required
                              return val.length != 6 ? 'Invalid pincode' : null;
                            },
                            controller: pincodeController,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 0,
                          width: 0,
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: RaisedButton(
                          child: Text('SHOPS'),
                          onPressed: () {
                            if (!formKey1.currentState.validate()) return;
                            formKey1.currentState.save();
                            searchCode = pincodeController.text;
                            print(searchCode);
                            fetchNearbyStores();
                            setState(() {
                              showShops = true;
                              refreshPage();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: (MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          kBottomNavigationBarHeight) *
                      0.10,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 12,
                        child: Form(
                          key: formKey2,
                          child: TextFormField(
                            //maxLength: 6,
                            // autovalidate: true,
                            decoration: InputDecoration(
                                labelText: 'Enter product name'),
                            keyboardType: TextInputType.text,

                            validator: (val) {
                              //correct validation is required
                              if (val.length == 0) {
                                refreshPage();
                                showShops = true;
                              }
                              return val.length == 0
                                  ? 'Enter product name'
                                  : null;
                            },
                            controller: searchController,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 0,
                          width: 0,
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: RaisedButton(
                          child: Text('Search'),
                          onPressed: () {
                            if (!formKey2.currentState.validate()) return;
                            formKey2.currentState.save();
                            prodSearch = searchController.text;
                            print(prodSearch);
                            // fetchNearbyStores();
                            findProduct(prodSearch);
                            setState(() {
                              showShops = false;
                              // searchResult = true;
                              //   // refreshPage();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: (MediaQuery.of(context).size.height -
                            kToolbarHeight -
                            kBottomNavigationBarHeight) *
                        0.80,
                    child: showShops == true ? listOfShops() : showShopsFunc())
              ],
            ),
          ),
        )
        // RaisedButton(
        //   child: Text('clcick'),
        //   onPressed: fetchNearbyStores,
        // ),
        //   SafeArea(
        // child: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child:
        //   SearchBar(
        //     onSearch: searchPinCode,
        //               ),
        //             ),
        //           ),
        //
        );
  }

  void moveToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        print('inside home page entering into profilepage ' +
            userData.toString());
        return ProfilePage();
      }),
    ).then((_) async {
      await documentReference.get().then((DocumentSnapshot ds) {
        print('entering into profilepage ' + ds.data.toString());
        ds.data.forEach((key, value) {
          userData[key] = value;
        });
        print('out from profile page');
      });
    });
  }

  void fetchNearbyStores() {
    pincodesReference =
        Firestore.instance.collection('/pincodes').document('$searchCode');

    if (dsnap == null) {
      dsnap = pincodesReference.get();
      dsnap.then((v) {
        shops = v.data;
        print(shops);
      });
    }
  }

  Widget listOfShops() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: refreshPage,
      child: FutureBuilder(
        future: dsnap,
        builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return showData(snapshot.data);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return somethingWentWrong();
        },
      ),
    );
  }

  Widget somethingWentWrong() {
    return Text('No Shops in this area');
  }

  Widget showData(DocumentSnapshot ds) {
    //  Uint8List imagefile;
    //  print(ds.data);
    shops = ds.data;
    // print(shops);
    // print(shops['super market'][0]);
    // var categories = shops.keys;

    // Map<String, dynamic> listOfShops = {};
    if (shops == null) {
      return somethingWentWrong();
    }
    listOfIds = [];
    listOfnames = [];

    shops.forEach((k, v) {
      var key = shops[k];
      //  print(key);
      //  String  value=shops[k];
      // var i = 0;
      key.forEach((k, v) {
        //  print(k);

        listOfIds.add(k);
        // print(v);
        listOfnames.add(v['shop-name']);
        //  i++;
      });
      //  temp.addAll(shops[k]);
      // temp.putIfAbsent(shops[k],shops[k][shops[k]]);
      // temp.
      //    print(temp);
      //   //temp = ;
      //   shops[k].forEach((k1, v1) {
      //     listOfshops.putIfAbsent(shops[k][k1], shops[k][k1]['shop-name']);
    });
    print(listOfnames);
    print(listOfIds);
    // listOfId=listOfIds;
    // listOfname=listOfnames;

    // });
    // print(temp);
    // if (firstInstance == false) {
    //   firstInstance = true;
    //   listOfDocuments = data.documents;
    //   // print(listOfDocuments);
    //   for (var doc in listOfDocuments) {
    //     Map<String, dynamic> map = doc.data;
    //     for (var key in map.keys) {
    //       listMap.add(map[key]);
    //     }
    //   }
    // }
    //  print(listMap);

    //  print(ls.toString());
    return ListView.builder(
      itemCount: listOfnames.length,
      itemBuilder: (BuildContext context, int index) {
        // String k = listOfnames.keys.elementAt(index);
        return Card(
          child: ListTile(
            title: Text(listOfnames[index]),
            // subtitle: Text(listOfIds[index]),
            onTap: () {
              getShop(listOfIds[index]);
            },
          ),
        );
      },
    );
  }

  Widget showShopsFunc() {
    print('list:' + listOfnames.toString());
    return ListView.builder(
      itemCount: listOfnames.length,
      itemBuilder: (BuildContext context, int index) {
        // String k = listOfnames.keys.elementAt(index);

        return Card(
          child: ListTile(
            title: Text(listOfnames[index]),
            // subtitle: Text(listOfIds[index]),
            onTap: () {
              getShop(listOfIds[index]);
            },
          ),
        );
      },
    );
  }

  Future<void> refreshPage() {
    setState(() {
      dsnap = pincodesReference.get();
      listOfIds = [];
      listOfnames = [];
    });
    return dsnap;
  }

  void getShop(String listOfId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        print('inside home page entering into profilepage ' +
            userData.toString());
        return DisplayShop(listOfId);
      }),
    );
  }

  void findProduct(String s) {
    // listOfId.forEach((s) {
    // Query _colRef = Firestore.instance.collectionGroup('products');
    List<String> listOfId = [];
    List<String> listOfname = [];
    //print('ids before removal:'+listOfIds.toString());
    int n = 0;
    listOfIds.forEach((id) {
      CollectionReference _colref =
          Firestore.instance.collection('/users/' + id + '/products');
      Query query = _colref.where('title', isEqualTo: s);
      query.getDocuments().then((ds) {
        if (ds.documents.length == 0) {
          listOfId.add(id);
          listOfname.add(listOfnames[n]);
          n++;
          print('found ' + listOfId.toString());
        }
        print(ds.documents.length);
        // ds.documents.forEach((f) {
        //   print("datasnap:" + f.data.keys.toString());
        //  // newListOfShops.add(f.data);
        // });
        // print('is:'+listOfId.toString());
        print("ids after " + listOfIds.toString());
        print("ids after " + listOfnames.toString());
        setState(() {
          listOfId.forEach((f) {
            listOfIds.remove(f);
          });
          listOfname.forEach((f) {
            listOfnames.remove(f);
          });
          // showShopsFunc();
        });
      });
    });

    // Query _colRef = Firestore.instance
    //     // .collection('/users')
    //     // .where('pincode', isEqualTo: "600097");
    //     // _colRef=_colRef.firestore
    //     .collectionGroup('products');
    // Query query = _colRef.where("title", isEqualTo: s);
    // _col.getDocuments().then((v){
    //     v.documents.forEach((f){

    //     });
    // });
    // query.snapshots();
    //print(query.toString());

    // query.getDocuments().then((ds) {
    //   // print('query:' + ds.toString());
    //   // print(query.reference().path.toString());
    //   ds.documents.forEach((f) {
    //     print("datasnap:" + f.data.keys.toString());
    //   });
    //   // print(ds.documents.length);
    // }).catchError((e) {
    //   print('error thrown' + e.toString());
    // });
    // });
  }
}
